import { expect, test as base  } from '@playwright/test';
import { AuthPage } from './fixtures/auth';

const test = base.extend<{ authPage: AuthPage }>({
  authPage: async ({ page }, use) => {
    const authPage = new AuthPage(page);
    await use(authPage);
    expect(await authPage.deleteAccount(), `Should delete account email: ${authPage.email}`).toBeTruthy();
  },
});

test('index page should have logo', async ({ page, authPage }) => {
	await page.goto('/');
	await expect(page.getByRole('link', { name: 'LETSDEBATE LIVE' })).toBeVisible();
});

test('user able to register', async ({ page, authPage }) => {
  await authPage.register();
  await authPage.openAccountMenu();
  await expect(page.getByRole('button', { name: 'Logout' })).toBeVisible();
  await page.getByRole('button', { name: 'Logout' }).click();

	// check if the page is / redirected to home page
	await expect(new URL(page.url()).pathname, "Should be redirected to home page").toBe('/');
});

test('user able to login', async ({ page, authPage }) => {
  await authPage.register();
  await authPage.logout();
  await authPage.login();
  await authPage.openAccountMenu();
  await expect(page.getByRole('button', { name: 'Logout' })).toBeVisible();
  await page.getByRole('button', { name: 'Logout' }).click();
	// check if the page is / redirected to home page
	await expect(new URL(page.url()).pathname, "Should be redirected to home page").toBe('/');
});
