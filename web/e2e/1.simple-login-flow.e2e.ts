import { expect, test } from '@playwright/test';

test('index page should have logo', async ({ page }) => {
	await page.goto('/');
	await expect(page.getByRole('link', { name: 'LETSDEBATE LIVE' })).toBeVisible();
});

test('anon control-room should be redirect back home', async ({ page }) => {
	await page.goto('/profile/user3/control-room');

	await expect(page.getByRole('heading', { name: 'Backstage' })).toBeHidden();
});

test('page login and control room should be visible', async ({ page }) => {
	await page.goto('/');
	await expect(page.getByRole('link', { name: 'LETSDEBATE LIVE' })).toBeVisible();

	await page.getByRole('button').click();

	await page.getByRole('button', { name: 'Login' }).click();
	// await page.waitForTimeout(300);
	await page.locator('input[name="email"]').fill('TeamUser3-C@example.com');
	await page.locator('input[name="password"]').fill('TeamUser3-C');
	await page.locator('form').getByRole('button', { name: 'Login' }).click();
	await page.waitForTimeout(300);

	await page.getByRole('button').click();

	await expect(page.getByRole('button', { name: 'Control Room' })).toBeVisible();
	await page.getByRole('button', { name: 'Control Room' }).click();
	await page.waitForLoadState('domcontentloaded');
	await page.waitForTimeout(300);
	await expect(page.getByRole('heading', { name: 'Backstage' })).toBeVisible();
});
