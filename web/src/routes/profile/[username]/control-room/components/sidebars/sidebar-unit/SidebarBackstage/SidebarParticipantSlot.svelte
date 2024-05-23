<script lang="ts">
	import SettingIcon from '$lib/components/icon/SettingIcon.svelte';
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import Button from '$lib/components/button/Button.svelte';
	import ParticipantCard from './ParticipantCard.svelte';

	import UserBan from '$lib/components/icon/UserBan.svelte';
	import DeviceCamera from '$lib/components/icon/DeviceCamera.svelte';
	import DeviceMic from '$lib/components/icon/DeviceMic.svelte';
	import DeviceScreen from '$lib/components/icon/DeviceScreen.svelte';
	import DeviceMicDisabled from '$lib/components/icon/DeviceMicDisabled.svelte';
	import DeviceCameraDisabled from '$lib/components/icon/DeviceCameraDisabled.svelte';
	import DeviceScreenDisabled from '$lib/components/icon/DeviceScreenDisabled.svelte';
	import DeviceUserProfile from '$lib/components/icon/DeviceUserProfile.svelte';
	import DeviceUserProfileDisabled from '$lib/components/icon/DeviceUserProfileDisabled.svelte';
	import ParticipantCardList from './ParticipantCardList.svelte';
	import NoParticipant from './NoParticipant.svelte';

	import { getContext } from 'svelte';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	
	import { isLessThanLg } from '$lib/stores/screen-size.store';
	import { authUserData } from '$lib/components/auth/auth.store';
	import { getSupabase } from '$lib/supabase';

	import type { Tables } from '$lib/schema/database.types';
	import type { Readable, Writable } from 'svelte/store';

	interface Props {
		type: 'backstage' | 'stage';
		showSetting: boolean;
		title: string;
	}
	
	const supabase = getSupabase(getContext);

	let { type, showSetting=$bindable(false), title }: Props = $props();

	let participants: Writable<Tables<'live_debate_participants'>[]> = getContext(
		'ctx_table$participants'
	);
	let liveDebate: Writable<Tables<'live_debate'>> = getContext('ctx_table$liveDebate');
	let teamMapColor: Readable<Record<string, string>> = getContext('ctx$teamMapColor');

	let filteredParticipants: Tables<'live_debate_participants'>[] = $derived($participants.filter(participant => participant.location === type));

	let viewMode: "list" | "grid" = $state("list");
	let showBulkDropdown = $state(false);

	function toggleBulkAction() {
		showBulkDropdown = !showBulkDropdown;
	}

	function toggleSetting() {
		showSetting = !showSetting;
	}

	let deviceEnable: Partial<Tables<'live_debate_participants'>> = $derived({
		cam_enable: !filteredParticipants.some(item => !item.cam_enable),
		mic_enable: !filteredParticipants.some(item => !item.mic_enable),
		screenshare_enable: !filteredParticipants.some(item => !item.screenshare_enable),
		profile_image_enable: !filteredParticipants.some(item => !item.profile_image_enable)
	});

	async function toggleDevice(device: keyof Tables<'live_debate_participants'>) {
		const toUpdate = {
			[device]: !deviceEnable[device]
		};

		// INFO: keep the `await`, on remove if removed it doesn't update
		const {data, error } = await supabase
			.from('live_debate_participants')
			.update(toUpdate)
			.eq('live_debate', $liveDebate.id);
	}


	async function handleCopyLink() {
		const url = `${window.location.origin}/profile/${$authUserData?.username}/live`;
		navigator.clipboard.writeText(url);
		newToast({
			type: "info",
			message: "Link copied to clipboard"
		})
	}
</script>

<div class="heading">
	<Heading2 content={title} />
	<div class="right-content">
		<button class="icon-container" onclick={toggleSetting}>
			{#if showSetting}
				<svg
					width="15"
					height="15"
					viewBox="0 0 15 15"
					fill="none"
					xmlns="http://www.w3.org/2000/svg"
				>
					<path
						d="M2 13L13 2M2 2L13 13"
						stroke="currentcolor"
						stroke-width="3"
						stroke-linecap="round"
					/>
				</svg>
			{:else}
				<SettingIcon />
			{/if}
		</button>
	</div>
</div>

{#if showSetting}
	<!-- svelte-ignore deprecated_slot_element -->
	<slot name="setting"></slot>
{:else}
	<div class="header-center">
		<Button
			color="primary"
			fillType="outline-solid"
			label={$isLessThanLg ? `Copy ${title} link` : ''}
			onclick={handleCopyLink}
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

		<button class="dropdown-container" onclick={toggleBulkAction}>
			<div class="dropdown-label">Bulk Action</div>
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
	</div>

	{#if showBulkDropdown}
		<div class="bulkaction">
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
			<div class="description">Enable / disable all the user devices</div>
			<div class="icons">
				<div class="left">
					<button class="icon" onclick={() => toggleDevice('cam_enable')}>
						{#if deviceEnable.cam_enable}
							<DeviceCamera />
						{:else}
							<DeviceCameraDisabled />
						{/if}
					</button>
					<button class="icon" onclick={() => toggleDevice('mic_enable')}>
						{#if deviceEnable.mic_enable}
							<DeviceMic />
						{:else}
							<DeviceMicDisabled />
						{/if}
					</button>
					<button class="icon" onclick={() => toggleDevice('screenshare_enable')}>
						{#if deviceEnable.screenshare_enable}
							<DeviceScreen />
						{:else}
							<DeviceScreenDisabled />
						{/if}
					</button>
					<button class="icon" onclick={() => toggleDevice('profile_image_enable')}>
						{#if deviceEnable.profile_image_enable}
							<DeviceUserProfile />
						{:else}
							<DeviceUserProfileDisabled />
						{/if}
					</button>
				</div>
				<button class="icon text-accent-red">
					<UserBan />
				</button>
			</div>
		</div>
	{/if}
	<div class="view-mode-container">
		<button
			class="view-mode grid"
			class:active={viewMode==="grid"}
			onclick={() => (viewMode = "grid")}
		>
		<svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path d="M7.5 2.25H2.25V7.5H7.5V2.25Z" stroke="currentcolor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
			<path d="M15.75 2.25H10.5V7.5H15.75V2.25Z" stroke="currentcolor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
			<path d="M15.75 10.5H10.5V15.75H15.75V10.5Z" stroke="currentcolor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
			<path d="M7.5 10.5H2.25V15.75H7.5V10.5Z" stroke="currentcolor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
			</svg>
			
		</button>
		<button
			class="view-mode list"
			class:active={viewMode==="list"}
			onclick={() => (viewMode = "list")}
		>
		<svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path d="M6 4.5H15.75" stroke="currentcolor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
			<path d="M6 9H15.75" stroke="currentcolor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
			<path d="M6 13.5H15.75" stroke="currentcolor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
			<path d="M2.25 4.5H2.2575" stroke="currentcolor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
			<path d="M2.25 9H2.2575" stroke="currentcolor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
			<path d="M2.25 13.5H2.2575" stroke="currentcolor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
f			</svg>
			
		</button>
	</div>
	<div class="participant-card-container">
		{#if viewMode === "grid"}
			{#each filteredParticipants as participant (participant.participant_id)}
				<ParticipantCard
					participant={participant}
					live_debate={$liveDebate}
					teamMapColor={$teamMapColor}
				/>
			{:else}
				<NoParticipant type={type}/>	
			{/each}
		{:else}
		{#each filteredParticipants as participant (participant.participant_id)}
			<ParticipantCardList
				participant={participant}
				live_debate={$liveDebate}
				teamMapColor={$teamMapColor}
			/>
			{:else}
				<NoParticipant type={type}/>	
		{/each}
		{/if}
	</div>
{/if}

<style lang="postcss">
	.heading {
		@apply flex items-center my-4 justify-between;
		@apply px-4;
	}
	.icon-container {
		padding: 4px;
		cursor: pointer;

		width: 40px;
		height: 40px;
		@apply flex items-center justify-center;
	}
	.icon-container:hover {
		background-color: white;
		color: rgb(var(--color-primary-dark));
		border-radius: 100%;
	}
	.right-content {
		@apply flex items-center justify-center gap-2;
	}

	.bulkaction {
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
	.icon {
		@apply cursor-pointer;
	}
	.icon:hover {
		@apply text-primary-dark;
	}
	.header-center {
		@apply w-full flex justify-between items-center px-4;
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

	.view-mode-container {
		@apply flex w-full justify-end;
		@apply pr-4;
	}
	.view-mode {
		color: rgba(255,255,255, 0.6);
		background-color: white;
		@apply cursor-pointer;
		@apply px-2 py-1;
		@apply bg-secondary-dark/20;
	}
	.grid {
		@apply rounded-l;
	}
	.list {
		@apply rounded-r;
	}
	.view-mode.active {
		color: rgba(255, 255, 255, 1);
	}
	.participant-card-container {
		@apply my-2 mt-4;
		@apply flex flex-wrap justify-between gap-2 px-4;
	}
</style>
