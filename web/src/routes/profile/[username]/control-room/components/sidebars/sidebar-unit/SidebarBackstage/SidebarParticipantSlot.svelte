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
	import SidebarSetting from './SidebarSetting.svelte';
	import NoParticipant from './NoParticipant.svelte';

	import { getContext } from 'svelte';
	import { newToast } from '$lib/components/toast/Toast.svelte';

	import { CloseX, DownArrow, Link, ListMode, GridMode } from '$lib/components/icon';

	import { isLessThanLg } from '$lib/stores/screen-size.store';
	import { authUserData } from '$lib/components/auth/auth.store';
	import { currentSidebar } from '$lib/stores/sidebar.store';
	import { getSupabase } from '$lib/supabase';

	import { getControlRoomCtx } from '$lib/context/control-room';
	import type { Tables } from '$lib/schema/database.types';

	interface Props {
		type: 'backstage' | 'stage';
		showSetting: boolean;
		title: string;
	}

	const supabase = getSupabase(getContext);

	let { type, showSetting = $bindable(false), title }: Props = $props();

	let participants = getControlRoomCtx(getContext, 'ctx_table$live_debate_participants');
	let live_debate = getControlRoomCtx(getContext, 'ctx_table$live_debate');
	let teamMapColor = getControlRoomCtx(getContext, 'ctx_map$teamColor');

	let filteredParticipants: Tables<'live_debate_participants'>[] = $derived(
		$participants?.filter((participant) => participant.location === type) || []
	);

	let isStageFull: boolean = $state(false);

	$effect(() => {
		if (!$participants || !$live_debate) return;
		const currentStageCount = $participants.filter((e) => e.location === 'stage').length;

		isStageFull = currentStageCount >= $live_debate.max_stage;
	});

	let viewMode: 'list' | 'grid' = $state('list');
	let showBulkDropdown = $state(false);

	function toggleBulkAction() {
		showBulkDropdown = !showBulkDropdown;
	}

	function toggleSetting() {
		showSetting = !showSetting;
	}

	let deviceEnable: Partial<Tables<'live_debate_participants'>> = $derived({
		cam_enable: !filteredParticipants.some((item) => !item.cam_enable),
		mic_enable: !filteredParticipants.some((item) => !item.mic_enable),
		screenshare_enable: !filteredParticipants.some((item) => !item.screenshare_enable),
		profile_image_enable: !filteredParticipants.some((item) => !item.profile_image_enable)
	});

	async function toggleDevice(device: keyof Tables<'live_debate_participants'>) {
		const toUpdate = {
			[device]: !deviceEnable[device]
		};

		// INFO: keep the `await`, on remove if removed it doesn't update
		const { data, error } = await supabase
			.from('live_debate_participants')
			.update(toUpdate)
			.eq('live_debate', $live_debate?.id as string);
	}

	async function handleCopyLink() {
		const url = `${window.location.origin}/u/${$authUserData?.username}`;
		navigator.clipboard.writeText(url);
		newToast({
			type: 'info',
			message: 'Link copied to clipboard'
		});
	}
</script>

<div class="heading">
	<Heading2 content={title} />
	<div class="right-content">
		<button class="icon-container" onclick={toggleSetting}>
			{#if showSetting}
				<CloseX />
			{:else}
				<SettingIcon />
			{/if}
		</button>
	</div>
</div>

<!-- svelte-ignore slot_element_deprecated -->
{#if showSetting}
	<SidebarSetting {type} onclose={() => (showSetting = false)} />
{:else}
	<div class="header-center">
		<Button
			color="primary"
			fillType="outline-solid"
			label={$isLessThanLg ? `Copy ${title} link` : ''}
			onclick={handleCopyLink}
		>
			<Link slot="icon-left" />
		</Button>

		<button class="dropdown-container" onclick={toggleBulkAction}>
			<div class="dropdown-label">Bulk Action</div>
			<DownArrow />
		</button>
	</div>

	{#if showBulkDropdown}
		<div class="bulkaction">
			<button class="header" onclick={toggleBulkAction}>
				<div class="title">Bulk Action</div>
				<DownArrow />
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

	<div class="stage-full-view-mode">
		{#if type === 'backstage' && filteredParticipants.length > 0 && isStageFull}
			<button onclick={() => ($currentSidebar = 'participants')} class="text-stage-full"
				>The stage is full! (Remove some user)</button
			>
		{:else}
			<div></div>
		{/if}

		<div class="view-mode-container">
			<button
				class="view-mode grid"
				class:active={viewMode === 'grid'}
				onclick={() => (viewMode = 'grid')}
			>
				<GridMode />
			</button>
			<button
				class="view-mode list"
				class:active={viewMode === 'list'}
				onclick={() => (viewMode = 'list')}
			>
				<ListMode />
			</button>
		</div>
	</div>
	<div class="participant-card-container">
		{#if viewMode === 'grid' && $live_debate}
			{#each filteredParticipants as participant (participant.participant_id)}
				<ParticipantCard
					{participant}
					{isStageFull}
					live_debate={$live_debate}
					teamMapColor={$teamMapColor}
					{type}
				/>
			{:else}
				<NoParticipant {type} />
			{/each}
		{:else if viewMode === 'list' && $live_debate}
			{#each filteredParticipants as participant (participant.participant_id)}
				<ParticipantCardList
					{isStageFull}
					{participant}
					live_debate={$live_debate}
					teamMapColor={$teamMapColor}
					{type}
				/>
			{:else}
				<NoParticipant {type} />
			{/each}
		{/if}
	</div>
	<div class="px-28 mt-12 mb-6">
		<hr class="mx-4 border-light-gray" />
	</div>
	<div class="flex items-center justify-center">
		<Button
			onclick={() => {
				$currentSidebar = type === 'backstage' ? 'participants' : 'backstage';
			}}
			label={type === 'stage' ? 'Goto Backstage panel' : 'Show current stage member?'}
			fillType="dark"
			fontType="normal"
		/>
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
		@apply p-2 pl-4 pr-6;
		@apply my-2;
		margin-top: -52px;
		z-index: 4;
		@apply relative;
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
		@apply bg-primary/50;
		@apply p-2;
		@apply my-2;
		width: 140px;
		@apply flex items-center justify-end;
		@apply rounded;
	}

	.dropdown-container:hover {
		@apply bg-primary;
	}

	.dropdown-label {
		width: 150px;
		@apply text-sm;
	}
	.stage-full-view-mode {
		@apply flex justify-between;
		@apply mt-2;
	}

	.text-stage-full {
		@appply text-center flex items-center justify-start;
		@apply text-accent-red;
		@apply font-bold;
		@apply pl-4;
	}
	.view-mode-container {
		@apply flex justify-end;
		@apply pr-4;
	}
	.view-mode {
		color: rgba(255, 255, 255, 0.6);
		background-color: white;
		@apply cursor-pointer;
		@apply px-2 py-1;
		@apply bg-secondary-dark/0;
		@apply border border-light-gray;
	}
	.grid {
		@apply rounded-l;
		@apply border-r-0;
	}
	.list {
		@apply rounded-r;
	}
	.view-mode.active {
		color: rgba(255, 255, 255, 1);
		@apply bg-secondary-dark/60;
	}
	.participant-card-container {
		@apply my-6 mt-4;
		@apply flex flex-wrap justify-between gap-2 px-4;
	}
</style>
