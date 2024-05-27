<script lang="ts">
	import { getSupabase } from '$lib/supabase';
	import Input from '$lib/components/form/input/Input.svelte';
	import Modal from './Modal.svelte';
	import BigButton from '$lib/components/button/BigButton.svelte';
	import { currentModal } from './modal.store';
	import { z } from 'zod';
	import { hasErrorParse } from '$lib/utils/type';
	import ZodError from '../form/ZodError.svelte';
	import { REGEX_PASSWORD_VALIDATION } from '$lib/utils/regEx';
	import InPassword from '../form/input/InPassword.svelte';
	import { onMount, getContext } from 'svelte';
	import { newToast } from '../toast/Toast.svelte';
	import { goto, invalidateAll } from '$app/navigation';
	import { authUserData } from '../auth/auth.store';

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

	const supabase = getSupabase(getContext);
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

			const { data: userData, error: errorData } = await supabase.from('user_data').select();
			if (userData?.[0]) $authUserData = userData?.[0];
			invalidateAll();

			isLoading = false;
			$currentModal = null;
		} catch (e) {
			isLoading = false;
			console.error(e);
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
		if (session) $currentModal = null; // close the modal
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
