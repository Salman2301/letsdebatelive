<script lang="ts">
	import Input from '$lib/components/form/input/Input.svelte';
	import Modal from './Modal.svelte';
	import BigButton from '$lib/components/button/BigButton.svelte';
	import { currentModal } from './modal.store';
	import { enhance } from '$app/forms';
	import { z } from 'zod';
	import { hasErrorParse } from '$lib/utils/type';
	import ZodError from '../form/ZodError.svelte';
	import { REGEX_PASSWORD_VALIDATION } from '$lib/utils/regEx';
	import InPassword from '../form/input/InPassword.svelte';

	const form = {
		email: '',
		password: ''
	};

	const loginSchema = z.object({
		email: z.string().email(),
		password: z.string().regex(REGEX_PASSWORD_VALIDATION, {
			message:
				'Minimum 8 characters, at least one uppercase letter, one lowercase letter, one number and one special character'
		})
	});

	let parsed: z.SafeParseReturnType<typeof form, typeof form>;
	let hasErrors: Record<keyof typeof form, boolean>;
	let isLoading: boolean = false;

	function handleSubmit(event: SubmitEvent & { currentTarget: EventTarget & HTMLFormElement }) {
		parsed = loginSchema.safeParse(form);
		hasErrors = hasErrorParse(parsed);
		console.log(loginSchema.safeParse(form));
	}
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
		<InPassword
			bind:value={form.password}
			hasError={!!hasErrors?.password}
		/>
		<div class="text-content">
			<button class="w-full text-left" onclick={() => currentModal.set('register')}>
				Already Register? click here
			</button>
			<button class="w-full text-right" onclick={() => currentModal.set('forgot-password')}>
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
