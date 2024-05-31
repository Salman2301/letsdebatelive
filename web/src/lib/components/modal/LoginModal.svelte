<script lang="ts">
	import Input from '$lib/components/form/input/Input.svelte';
	import Modal from './Modal.svelte';
	import InPassword from '../form/input/InPassword.svelte';
	import BigButton from '$lib/components/button/BigButton.svelte';
	import ZodError from '../form/ZodError.svelte';

	import { z } from 'zod';
	import { getSupabase } from '$lib/supabase';
	import { closeModal, currentModal } from './modal.store';
	import { onMount, getContext } from 'svelte';
	import { hasErrorParse } from '$lib/utils/type';
	import { newToast } from '../toast/Toast.svelte';
	import { REGEX_PASSWORD_VALIDATION } from '$lib/utils/regEx';
	import { goto, invalidateAll } from '$app/navigation';
	import { authUserData } from '$lib/stores/auth.store';

	const form = {
		email: '',
		password: ''
	};

	const loginSchema = z.object({
		email: z.string().email(),
		password: z.string().regex(REGEX_PASSWORD_VALIDATION, {
			message: 'Invalid password'
		})
	});

	const supabase = getSupabase();
	let parsed: z.SafeParseReturnType<typeof form, typeof form>;
	let hasErrors: Record<keyof typeof form, boolean>;
	let isLoading: boolean = false;

	async function handleSubmit(
		event: SubmitEvent & { currentTarget: EventTarget & HTMLFormElement }
	) {
		try {
			event.preventDefault();
			parsed = loginSchema.safeParse(form);
			hasErrors = hasErrorParse(parsed);
			isLoading = true;

			if (!parsed.success) throw new Error('Form error');

			const {
				data: { session }
			} = await supabase.auth.getSession();
			if (session) throw new Error('Already signed in!');

			const { data, error } = await supabase.auth.signInWithPassword({
				email: form.email,
				password: form.password
			});

			invalidateAll();
			reloadPage();
			if (error) {
				newToast({ type: 'error', message: error.message });
				throw new Error(error.message);
			}

			const res = await supabase.auth.getUser();
			if (res.error || !res.data || !res.data.user || !res.data.user.id)
				throw new Error('Failed to retrived user');
			const { data: userData, error: errorData } = await supabase
				.from('user_data')
				.select()
				.eq('id', res.data.user.id);
			if (userData?.[0]) $authUserData = userData?.[0];
			invalidateAll();

			isLoading = false;
			closeModal();
		} catch (e) {
			isLoading = false;
			console.error(e);
			newToast({
				type: 'error',
				message: 'Failed to get the current user!'
			});
		}
	}

	function reloadPage() {
		const thisPage = window.location.pathname;

		goto('/', { invalidateAll: true }).then(() => goto(thisPage));
	}

	onMount(async () => {
		const {
			data: { session }
		} = await supabase.auth.getSession();
		if (session) closeModal();
	});
</script>

<Modal title="Login">
	<form class="container" onsubmit={(event) => handleSubmit(event)}>
		<Input
			bind:value={form.email}
			type="email"
			autofocus={true}
			name="email"
			hasError={!!hasErrors?.email}
		/>
		<InPassword bind:value={form.password} hasError={!!hasErrors?.password} />
		<div class="text-content">
			<button class="w-full text-left" onclick={() => currentModal.set('register')} type="button">
				Create an account? click here
			</button>
			<button
				class="w-full text-right"
				onclick={() => currentModal.set('forgot-password')}
				type="button"
			>
				Forgot password?
			</button>
		</div>
		<BigButton color="secondary" label="Login" {isLoading} />
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
