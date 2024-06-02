import { expect, test as base} from '@playwright/test';
import { AuthPage } from './fixtures/auth';

const test = base.extend<{ authPage: AuthPage }>({
  authPage: async ({ page }, use) => {
    const authPage = new AuthPage(page);
    await use(authPage);
    expect(await authPage.deleteAccount(), `Should delete account email: ${authPage.email}`).toBeTruthy();
  },
});

test('index page should have logo', async ({ page }) => {
	await page.goto('/');
	await expect(page.getByRole('link', { name: 'LETSDEBATE LIVE' })).toBeVisible();
});

test('Goto new debate', async ({ page, authPage }) => {
  await page.goto("/");
  await authPage.register();

  await authPage.openAccountMenu();
  await page.getByRole('button', { name: 'Create Debate' }).click();
  await page.waitForTimeout(300);

  await expect(new URL(page.url()).pathname, "Should be redirected to new debate page").toMatch(/new\-debate/);
});
