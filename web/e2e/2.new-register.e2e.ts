import { expect, test } from '@playwright/test';
import { createClient } from '@supabase/supabase-js'; 

const supabase = createClient(
  process.env.PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SECRET_KEY!
);

const TEST_EMAIL = 'E2eRegister-1@example.com';
const TEST_PASSWORD = 'E2eRegister-1';

test('index page should have logo', async ({ page }) => {
	await page.goto('/');
	await expect(page.getByRole('link', { name: 'LETSDEBATE LIVE' })).toBeVisible();
});

test('user able to register', async ({ page }) => {
  await deleteUserByEmail(TEST_EMAIL);

  await page.goto('/');
	await page.getByRole('button').click();

  await page.getByRole('button', { name: 'Create account' }).click();
  await page.waitForTimeout(300);

	await page.locator('input[name="email"]').fill(TEST_EMAIL);
	await page.locator('input[name="password"]').fill(TEST_PASSWORD);
	await page.getByRole('button', { name: 'Register', exact: true }).click();
  await page.waitForTimeout(300);
  await page.getByRole('button').click();
  await page.waitForTimeout(300);

  await expect(page.getByRole('button', { name: 'Logout' })).toBeVisible();
	await page.getByRole('button', { name: 'Logout' }).click();
	await page.waitForTimeout(300);

	// check if the page is / redirected to home page
	await expect(new URL(page.url()).pathname, "Should be redirected to home page").toBe('/');
});


const deleteUserByEmail = async (email) => {
  try {
    const { data: { users }, error: getUserError } = await supabase.auth.admin.listUsers();

    const user = users.find(e=>e.email === email.toLowerCase())
    if (!user) return;
    
    const userId = user.id;

    const { error: deleteUserError } = await supabase.auth.admin.deleteUser(userId);
    if(!deleteUserError) console.log('User deleted successfully');
  } catch { }
};
