<script lang="ts">
	import SettingIcon from '$lib/components/icon/SettingIcon.svelte';
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import Button from '$lib/components/button/Button.svelte';
	import BackstagerCard from './BackstagerCard.svelte';

	import UserBan from '$lib/components/icon/UserBan.svelte';
	import DeviceCamera from '$lib/components/icon/DeviceCamera.svelte';
	import DeviceMic from '$lib/components/icon/DeviceMic.svelte';
	import DeviceScreen from '$lib/components/icon/DeviceScreen.svelte';
	import DeviceUserProfile from '$lib/components/icon/DeviceUserProfile.svelte';
	import { isLessThanLg } from '$lib/stores/screen-size.store';
	import { backstage_participants } from '$lib/dummy/backstage';
	import type { Tables } from '$lib/schema/database.types';

	let backstagers: Tables<'live_debate_participants'>[] = backstage_participants;

	let showBulkDropdow = $state(false);

	function toggleBulkAction() {
		showBulkDropdow = !showBulkDropdow;
	}
</script>

<div class="heading">
	<Heading2 content="Backstage" />
	<div class="right-content">
		<Button
			color="primary"
			fillType="outline-solid"
			label={$isLessThanLg ? 'Copy Backstage link' : ''}
		>
			<svg
				slot="icon-left"
				xmlns="http://www.w3.org/2000/svg"
				viewBox="0 0 24 24"
				id="Hyperlink-3--Streamline-Ultimate"
				height="24"
				width="24"
				><g
					><path
						d="m10.46 18.37 -2.74 2.74a2.86 2.86 0 0 1 -3.94 0l-0.89 -0.89a2.77 2.77 0 0 1 -0.82 -2 2.74 2.74 0 0 1 0.82 -2l5.8 -5.81a2.8 2.8 0 0 1 3.94 0l0.89 0.9A1 1 0 1 0 14.94 10l-0.89 -0.89a4.79 4.79 0 0 0 -6.77 0l-5.81 5.8a4.79 4.79 0 0 0 0 6.77l0.89 0.89a4.78 4.78 0 0 0 6.78 0l2.73 -2.73a1 1 0 0 0 0 -1.42 1 1 0 0 0 -1.41 -0.05Z"
						fill="#fff"
						stroke-width="1"
					/><path
						d="m22.53 2.36 -0.9 -0.89a4.8 4.8 0 0 0 -6.77 0L12 4.38a1 1 0 1 0 1.41 1.41l2.91 -2.9a2.79 2.79 0 0 1 3.94 0l0.89 0.9a2.74 2.74 0 0 1 0.82 2 2.77 2.77 0 0 1 -0.82 2l-5.8 5.8a2.77 2.77 0 0 1 -2 0.82 2.75 2.75 0 0 1 -2 -0.82A1 1 0 0 0 10 14.93a4.76 4.76 0 0 0 3.39 1.41 4.75 4.75 0 0 0 3.38 -1.4l5.81 -5.81a4.79 4.79 0 0 0 0 -6.77Z"
						fill="#fff"
						stroke-width="1"
					/></g
				></svg
			>
		</Button>
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
		@apply flex items-center justify-center gap-2;
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
