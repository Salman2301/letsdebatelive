<script lang="ts">
	import UserImage from '../user-image/UserImage.svelte';

	import { goto } from '$app/navigation';
	import { clickOutside } from '$lib/action/clickOutside';
	import { authUserData } from '../../stores/auth.store';
	import { openModal } from '../modal/modal.store';
	import { getSupabase } from '$lib/supabase';

	let showPopup = $state(false);

	const supabase = getSupabase();

	async function handleCreateFeed() {
		if (!$authUserData) return;
		showPopup = false;
		goto(`/profile/${$authUserData.username}/new-feed`);
	}

	function gotoClosePopup(link: string) {
		showPopup = false;
		goto(link);
	}

	function openLogin() {
		showPopup = false;
		openModal({ key: 'login' });
	}

	function openRegister() {
		showPopup = false;
		openModal({ key: 'register' });
	}
</script>

<div class="icon-container" use:clickOutside={() => (showPopup = false)}>
	<button onclick={() => (showPopup = !showPopup)}>
		<UserImage user={$authUserData} />
	</button>

	{#if showPopup}
		<div class="popup">
			{#if $authUserData}
				<div class="signed-in">
					<input class="username" value={$authUserData.username} readonly/>
				</div>
			{/if}
			<button class="btn-popup" onclick={handleCreateFeed}> Create Feed </button>
			{#if $authUserData === null}
				<button class="btn-popup" onclick={openLogin}> Login </button>
				<button class="btn-popup bg-primary/70" onclick={openRegister}> Create account </button>
			{:else}
				{@const username = $authUserData.username}
			
				<button
					class="btn-popup"
					onclick={() => gotoClosePopup(`/profile/${username}/control-room`)}
				>
					Control room
				</button>
				<button class="btn-popup" onclick={() => gotoClosePopup(`/u/${username}`)}>
					Live page
				</button>
				<button class="btn-popup" onclick={() => gotoClosePopup(`/profile/${username}/settings`)}>
					Setting
				</button>
				<button
					class="btn-popup logout"
					onclick={() => {
						supabase.auth.signOut();
						$authUserData = null;
						gotoClosePopup(`/profile/logout?${Date.now()}`);
					}}
				>
					Logout
				</button>
			{/if}
		</div>
	{/if}
</div>

<style lang="postcss">
	.icon-container {
		position: relative;
	}
	.popup {
		position: absolute;
		width: 200px;
		right: 0px;
		margin-top: 10px;
		@apply bg-accent-gray;
		border-radius: 4px;
		overflow: hidden;
		z-index: 1000;
	}

	.signed-in {
		@apply flex justify-center;
		@apply px-1 py-2;
		border-bottom: 1px solid var(--color-light-gray);
		&::before {
			content: '@';
			@apply pr-1;
			@apply text-white/60;
		}

		input {
			@apply bg-transparent border-none outline-none;
			@apply text-sm;
			@apply text-white/60;
			field-sizing: content;
			max-width: 140px;
		}
	}

	.btn-popup {
		font-size: 14px;
		text-align: center;
		width: 100%;
		padding: 10px 0px;
		border-bottom: 1px solid var(--color-light-gray);
	}
	.btn-popup:hover {
		@apply text-white;
		@apply bg-primary;
	}
	.logout:hover {
		@apply bg-accent-red;
	}
	.btn-popup:last-child {
		border-bottom: 0px;
	}
</style>
