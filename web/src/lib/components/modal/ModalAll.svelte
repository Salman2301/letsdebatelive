<script lang="ts">
	import ForgotPasswordModal from './ForgotPasswordModal.svelte';
	import LoginModal from './LoginModal.svelte';
	import RegisterModal from './RegisterModal.svelte';
	import { currentModal } from './modal.store';
</script>

{#if $currentModal === 'login'}
	<LoginModal />
{:else if $currentModal === 'register'}
	<RegisterModal />
{:else if $currentModal === 'forgot-password'}
	<ForgotPasswordModal />
{:else if $currentModal === 'reset-password'}
	<ForgotPasswordModal />
{/if}
