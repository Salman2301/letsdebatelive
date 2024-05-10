<script lang="ts">
	import Input from '$lib/components/form/Input.svelte';
	import Modal from './Modal.svelte';
	import BigButton from '../button/BigButton.svelte';
	import { currentModal } from './modal.store';
</script>

<Modal title="Login">
	<div class="container">
		<Input value="" placeholder="Email" type="email" />
		<Input value="" placeholder="Password" type="password" />
		<div class="text-content">
			<button class="w-full text-left" onclick={()=>currentModal.set("register")}> Already Register? click here </button>
			<button class="w-full text-right" onclick={()=>currentModal.set("forgot-password")}> Forgot password? </button>
		</div>
		<BigButton color="secondary" label="Login" />
	</div>
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
		color: white;
		text-decoration: underline;
		cursor: pointer;
	}
</style>
