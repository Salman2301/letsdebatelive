import { superValidate, message } from 'sveltekit-superforms';
import { fail } from '@sveltejs/kit';
import { z } from 'zod';
import { zod } from 'sveltekit-superforms/adapters';
import type { Actions, PageServerLoad } from './$types.js';

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8)
});



export const load: PageServerLoad = async () => {
	const form = await superValidate(zod(loginSchema));
	return { form };
};

export const actions = {
	login: async ({ request }) => {
		const form = await superValidate(request, zod(loginSchema));

		console.log('POST', form);

		if (!form.valid) return fail(400, { form });

		return message(
			form,
			'An AI will review your information and get back to you soon. Thank you for being a cog in a fully automated machine.'
		);
	}
} satisfies Actions;
