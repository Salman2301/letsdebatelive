<script lang="ts">
	import Input from '$lib/components/form/input/Input.svelte';
	import Modal from './Modal.svelte';
	import BigButton from '$lib/components/button/BigButton.svelte';
	import { currentModal } from './modal.store';
	import { z } from 'zod';
	import { hasErrorParse } from '$lib/utils/type';
	import ZodError from '../form/ZodError.svelte';
	// import supabase from '$lib/supabase';
	import { getContext, onMount } from 'svelte';
	import { newToast } from '../toast/Toast.svelte';
	import type { SupabaseClient } from '@supabase/supabase-js';
	// import { checkLoginSetStore } from '../auth';

	const form = {
		email: ''
	};

	const forgotSchema = z.object({
		email: z.string().email()
	});
	const supabase = getContext<SupabaseClient>("lib_supabase");

	let parsed: z.SafeParseReturnType<typeof form, typeof form>;
	let hasErrors: Record<keyof typeof form, boolean>;
	let isLoading: boolean = false;

	async function handleSubmit(
		event: SubmitEvent & { currentTarget: EventTarget & HTMLFormElement }
	) {
		try {
			event.preventDefault();
			parsed = forgotSchema.safeParse(form);
			hasErrors = hasErrorParse(parsed);
			isLoading = true;

			if (!parsed.success) throw new Error('Form error');

			const {
				data: { session }
			} = await supabase.auth.getSession();
			if (session) throw new Error('Already signed in!');

			const { data, error } = await supabase.auth.resetPasswordForEmail(form.email);

			if (error) {
				newToast({ type: 'error', message: error.message });
				throw new Error(error.message);
			}
			// await checkLoginSetStore();

			isLoading = false;
			$currentModal = null;
		} catch (e) {
			isLoading = false;
			console.error(e);
		}
	}

	onMount(async () => {
		const {
			data: { session }
		} = await supabase.auth.getSession();
		if (session) $currentModal = null; // close the modal
	});
</script>

<Modal title="Reset Password">
	<form class="container" onsubmit={(event) => handleSubmit(event)}>
		<Input
			bind:value={form.email}
			type="email"
			autofocus={true}
			name="email"
			hasError={!!hasErrors?.email}
		/>
		<div class="text-content">
			<button class="w-full text-left" onclick={() => currentModal.set('login')} type="button">
				Login again?
			</button>
			<button class="w-full text-right" onclick={() => currentModal.set('register')} type="button">
				Create an account?
			</button>
		</div>
		<BigButton color="secondary" label="Send" {isLoading} />
		<div class="text-content">
			<ZodError {parsed} />
		</div>
	</form>
</Modal>

<style lang="postcss">
	.container {
		@apply flex items-center flex-col gap-2;
		margin-top: 40px;
	}
	.text-content {
		width: 280px;
		margin-bottom: 10px;
	}
	button {
		font-size: 12px;
		color: #ccc;
	}
	button:hover {
		@apply text-white;
		text-decoration: underline;
		cursor: pointer;
	}
</style>
