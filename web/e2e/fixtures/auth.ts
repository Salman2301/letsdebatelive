import { SupabaseClient, createClient } from '@supabase/supabase-js';
import type { Page } from '@playwright/test';
import type { Database } from '../../src/lib/schema/database.types';

const supabase: SupabaseClient<Database> = createClient(
	process.env.PUBLIC_SUPABASE_URL!,
	process.env.SUPABASE_SECRET_KEY!
);

function getRandomEmail() {
	const host = `E2eRegister-${Math.floor(Math.random() * 1000)}`;
	return { email: `${host}@example.com`, password: host };
}

export class AuthPage {
	public readonly email: string;
	public readonly password: string;

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
		await this.page.goto('/');
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
		await this.page.goto('/');
	}

	async logout() {
		await this.openAccountMenu();
		await this.page.getByRole('button', { name: 'Logout' }).click();
	}

	async deleteAccount() {
		return await deleteUserByEmail(this.email);
	}

	async openAccountMenu() {
		await this.page.getByRole('button').first().click();
	}

	async getUser() {
		const {
			data: { users },
			error: getUserError
		} = await supabase.auth.admin.listUsers();

		if (!getUserError) throw new Error('Error getting user');
		const user = users.find((e) => e.email === this.email.toLowerCase());
		if (!user) throw new Error('User not found');
		return user;
	}
}

const deleteUserByEmail = async (email) => {
	try {
		const {
			data: { users },
			error: getUserError
		} = await supabase.auth.admin.listUsers();

		const user = users.find((e) => e.email === email.toLowerCase());
		if (!user) return true;

		const userId = user.id;
		// Delete must be done in this order to avoid foreign key constraint
		await supabase.from('live_feed_invite_co_host').delete().eq('invited_by', userId).throwOnError(),
		await supabase.from('live_feed_user_role').delete().eq('user_id', userId).throwOnError()

		// Delete reference to user in all table
		await Promise.all([
			supabase.from('live_feed_participants').delete().eq('participant_id', userId).throwOnError(),
			supabase.from('live_feed').delete().eq('host', userId).throwOnError()
		]);

		const { error: deleteUserError } = await supabase.auth.admin.deleteUser(userId);

		if (deleteUserError) throw new Error('User not deleted');
		return true;
	} catch (e) {
		console.error(e);
		return false;
	}
};
