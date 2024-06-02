import type { Page } from '@playwright/test';
import { createClient } from '@supabase/supabase-js'; 

const supabase = createClient(
  process.env.PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SECRET_KEY!
);

function getRandomEmail() {
  const host = `E2eRegister-${Math.floor(Math.random() * 1000)}`;
  return { email: `${host}@example.com`, password: host };
}

export class AuthPage {
  private readonly email: string;
  private readonly password: string;

  constructor(public readonly page: Page) {
    const { email, password } = getRandomEmail();
    this.email = email;
    this.password = password;
  }


  async register() {
    await this.page.goto('/');

    await this.openAccountMenu();

    await this.page.getByRole('button', { name: 'Create account' }).click();
    await this.page.waitForTimeout(300);

    await this.page.locator('input[name="email"]').fill(this.email);
    await this.page.locator('input[name="password"]').fill(this.password);
    await this.page.getByRole('button', { name: 'Register', exact: true }).click();
    await this.page.waitForTimeout(500);
  }

  async login() {
    await this.page.goto('/');
    await this.openAccountMenu();

    await this.page.getByRole('button', { name: 'Login' }).click();
    // await this.page.waitForTimeout(300);
    await this.page.locator('input[name="email"]').fill(this.email);
    await this.page.locator('input[name="password"]').fill(this.password);
    await this.page.locator('form').getByRole('button', { name: 'Login', exact: true }).click();
    await this.page.waitForTimeout(500);
  }

  async logout() {
    await this.openAccountMenu();
    await this.page.getByRole('button', { name: 'Logout' }).click();
  }

  async deleteAccount() {
    deleteUserByEmail(this.email);
  }

  async openAccountMenu() {
    await this.page.getByRole('button').first().click();
  }
}

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