<script lang="ts">
	import UserImage from '../user-image/UserImage.svelte';

	import { goto } from '$app/navigation';
	import { clickOutside } from '$lib/action/clickOutside';
	import { authUserData } from '../../stores/auth.store';
	import { openModal } from '../modal/modal.store';
	import { getContext } from 'svelte';
	import { getSupabase } from '$lib/supabase';

	let showPopup = $state(false);

	const supabase = getSupabase();

	async function handleCreateDebate() {
		if (!$authUserData) return;
		showPopup = false;
		goto(`/profile/${$authUserData.username}/new-debate`);
	}

	function gotoClosePopup(link: string) {
		showPopup = false;
		goto(link);
	}
</script>

<div class="icon-container" use:clickOutside={() => (showPopup = false)}>
	<button onclick={() => (showPopup = !showPopup)}>
		<UserImage user={$authUserData} />
	</button>

	{#if showPopup}
		<div class="popup">
			<button class="btn-popup" onclick={handleCreateDebate}> Create Debate </button>
			{#if $authUserData === null}
				<button class="btn-popup" onclick={() => openModal({ key: 'login' })}> Login </button>
				<button class="btn-popup bg-primary/70" onclick={() => openModal({ key: 'register' })}>
					Create account
				</button>
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
