import { expect, test as base } from '@playwright/test';
import { AuthPage } from './fixtures/auth';

const test = base.extend<{ authPage: AuthPage }>({
	authPage: async ({ page }, use) => {
		const authPage = new AuthPage(page);
		await use(authPage);
		expect(
			await authPage.deleteAccount(),
			`Should delete account email: ${authPage.email}`
		).toBeTruthy();
	}
});

test('index page should have logo', async ({ page }) => {
	await page.goto('/');
	await expect(page.getByRole('link', { name:'VISTA LVE' })).toBeVisible();
});

test('Create a  new feed', async ({ page, authPage }) => {
	await page.goto('/');
	await authPage.register();

	await authPage.openAccountMenu();
	await page.getByRole('button', { name: 'Create Feed' }).click();
	await page.waitForTimeout(300);

	await expect(new URL(page.url()).pathname, 'Should be redirected to new feed page').toMatch(
		/new\-feed/
	);

	// STAGE 1
	const title = `Test live - ${genId()}`;
	await page.getByPlaceholder('Enter title for your live').fill(title);

	const teamNames = ['Team A', 'Team B', 'Team C', 'Team Delete'];
	for await (const [i, teamName] of Object.entries(teamNames)) {
		await page.getByTestId('new-team-input').fill(teamName);
		await page.getByTestId('team-submit-btn').click();
		await page.waitForTimeout(300);

		// TODO: Test set as default

		expect(
			await page.getByTestId('team-title-input').nth(Number(i)).inputValue(),
			`It should have created team name: ${teamName}`
		).toBe(teamName);
	}

	await page.getByTestId('btn-team-del').nth(3).click();
	await page.waitForTimeout(300);

	expect(
		await page.getByTestId('btn-team-del').count(),
		'Should have deleted one of the team'
	).toBe(3);

	await page.getByRole('button', { name: 'Next' }).click();
	await page.waitForTimeout(300);

	// STAGE 2
	expect(await page.getByRole('heading', { name: 'My (Host) Setup (2 / 5)' })).toBeTruthy();

	await page.getByTestId('in-display-name').fill('Display');

	await page.getByRole('button', { name: 'Next' }).click();
	await page.waitForTimeout(300);

	// STAGE 3
	const cohostEmail = 'test@email.com';
	await page.getByTestId('in-co-host').fill(cohostEmail);
	await page.getByTestId('add-co-host').click();
	await page.waitForTimeout(300);

	expect(
		await page.getByTestId('cohost-item-email').textContent(),
		`Should have created invite to cohost ${cohostEmail}`
	).toBe(cohostEmail);

	await page.getByRole('button', { name: 'Next' }).click();
	await page.waitForTimeout(300);

	// STAGE 4
	// TODO: ADD more test
	await page.getByRole('button', { name: 'Next' }).click();
	await page.waitForTimeout(300);

	//STAGE 5
	await page.getByRole('button', { name: 'Publish' }).click();
	await page.waitForTimeout(300);

	expect(
		new URL(await page.url()).pathname,
		'Page shoud redirect to control room once completed!'
	).toMatch(/control\-room/);
});

export function genId(maxLen?: number) {
	if (typeof maxLen === 'undefined') maxLen = 6;

	const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	let id = '';
	for (let i = 0; i < maxLen; i++) {
		id += charset.charAt(Math.floor(Math.random() * charset.length));
	}

	return id;
}
