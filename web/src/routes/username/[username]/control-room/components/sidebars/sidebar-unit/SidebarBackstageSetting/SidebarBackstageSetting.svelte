<script lang="ts">
	import SettingIcon from '$lib/components/icon/SettingIcon.svelte';
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import Button from '$lib/components/button/Button.svelte';
	import BackstagerCard from './BackstagerCard.svelte';

	import { backstage_participants } from '$lib/dummy/backstage';
	import type { Tables } from '$lib/schema/database.types';
	import UserBan from '$lib/components/icon/UserBan.svelte';
	import DeviceCamera from '$lib/components/icon/DeviceCamera.svelte';
	import DeviceMic from '$lib/components/icon/DeviceMic.svelte';
	import DeviceScreen from '$lib/components/icon/DeviceScreen.svelte';
	import DeviceUserProfile from '$lib/components/icon/DeviceUserProfile.svelte';

	let backstagers: Tables<'live_debate_participants'>[] = backstage_participants;

	let showBulkDropdow = $state(false);

	function toggleBulkAction() {
		showBulkDropdow = !showBulkDropdow;
	}
</script>

<div class="heading">
	<Heading2 content="Backstage" />
	<div class="right-content">
		<Button color="primary" fillType="outline-solid" label="Copy backstage link"></Button>
		<div class="icon-container">
			<SettingIcon />
		</div>
	</div>
</div>

<div class="dropdown-end">
	<button class="dropdown-container" onclick={toggleBulkAction}>
		<div class="dropdown-label">Bulk Action</div>
		<svg width="21" height="12" viewBox="0 0 21 12" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path d="M1 1L9.5 10.5L20 1" stroke="white" stroke-width="2" stroke-linecap="round" />
		</svg>
	</button>
</div>

{#if showBulkDropdow}
	<div class="backstage-bulkaction">
		<button class="header" onclick={toggleBulkAction}>
			<div class="title">Bulk Action</div>

			<svg
				width="21"
				height="12"
				viewBox="0 0 21 12"
				fill="none"
				xmlns="http://www.w3.org/2000/svg"
			>
				<path d="M1 1L9.5 10.5L20 1" stroke="white" stroke-width="2" stroke-linecap="round" />
			</svg>
		</button>
		<div class="description">Enable / disable all the backstager user devices</div>
		<div class="icons">
			<div class="left">
				<DeviceCamera />
				<DeviceMic />
				<DeviceScreen />
				<DeviceUserProfile />
			</div>
			<UserBan />
		</div>
	</div>
{/if}

<div class="backstager-card-container">
	{#each backstagers as backstager}
		<BackstagerCard {backstager} />
	{/each}
</div>

<style lang="postcss">
	.heading {
		@apply flex items-center my-4 justify-between;
		@apply px-4;
	}
	.icon-container {
		padding: 4px;
		cursor: pointer;
	}
	.icon-container:hover {
		background-color: white;
		color: rgb(var(--color-primary-dark));
		border-radius: 100%;
	}
	.right-content {
		@apply flex items-center justify-center gap-4;
	}

	.backstage-bulkaction {
		background-color: #3a0e63;
		@apply p-2 px-4;
		@apply my-2;
		/* opacity: 0.6; */
		margin-top: -52px;
		z-index: 4;
		@apply relative;
		/* transform: translateY(-60px); */
	}

	.header {
		@apply flex w-full items-center justify-between;
	}
	.title {
		@apply text-lg;
		@apply font-semibold;
	}
	.description {
		color: #ccc;
		font-size: 12px;
	}

	.icons {
		@apply my-2;
		@apply flex justify-between w-full;
	}
	.left {
		@apply flex gap-4;
		@apply text-primary;
	}
	.dropdown-end {
		@apply w-full flex justify-end pr-4;
	}
	.dropdown-container {
		background-color: #3a0e63;
		@apply p-2;
		@apply my-2;
		width: 140px;
		@apply flex items-center justify-end;
		@apply rounded;
	}

	.dropdown-label {
		width: 150px;
	}

	.backstager-card-container {
		@apply my-2;
		@apply flex flex-wrap justify-between gap-2 px-4;
	}
</style>
