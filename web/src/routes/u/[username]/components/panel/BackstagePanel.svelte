<script context="module">
	export type DevicesEnable = {
		cam_enable: boolean;
		screenshare_enable: boolean;
		mic_enable: boolean;
		speaker_enable: boolean;
	};
</script>

<script lang="ts">
	import {
		DeviceSpeaker,
		DeviceSpeakerDisabled,
		DeviceScreen,
		DeviceScreenDisabled,
		RaiseHand,
		DeviceCameraDisabled,
		DeviceCamera,
		DeviceMicDisabled,
		DeviceMic,
		Phone,
		SettingGear
	} from '$lib/components/icon';
	import { getSupabase } from '$lib/supabase';
	import { getContext } from 'svelte';

	import type { PageData, ParticipantsWithUserData } from '../../page.types';
	import type { Tables } from '$lib/schema/database.types';
	import UserImage from '$src/lib/components/user-image/UserImage.svelte';

	interface Props {
		pageData: PageData | null;
		participants: ParticipantsWithUserData[];
		myBackstageInfo: ParticipantsWithUserData | null;
		devicesEnable: DevicesEnable;
	}

	let {
		participants = $bindable([]),
		myBackstageInfo = null,
		pageData,
		devicesEnable
	}: Props = $props();

	let audienceSetting = $state({
		hand_raised: myBackstageInfo?.hand_raised,
		mic_available: myBackstageInfo?.mic_available,
		cam_available: pageData?.myBackstageInfo?.cam_available,
		speaker_available: myBackstageInfo?.speaker_available,
		screenshare_available: myBackstageInfo?.screenshare_available
	});

	const supabase = getSupabase(getContext);

	async function toggleDevice(device: keyof typeof audienceSetting) {
		if (!(pageData?.live_debate?.id && pageData?.user?.id)) return;

		await supabase
			.from('live_debate_participants')
			.update({
				[device]: !audienceSetting[device]
			})
			.eq('live_debate', pageData.live_debate.id)
			.eq('participant_id', pageData.user.id)
			.throwOnError();

		audienceSetting[device] = !audienceSetting[device];
	}
</script>

<div class="backstage-section">
	<div class="audience-container">
		{#each participants as participant}
			<div class="audience-item">
				<div
					class="audience-item-image"
					style="border-color:{pageData?.teamMapColor?.[participant?.team?.id]}"
				>
					<UserImage user={participant.participant_id}/>
				</div>
				{#if participant.hand_raised}
					<div class="audience-hand">
						<RaiseHand />
					</div>
				{/if}
			</div>
		{/each}
	</div>
	<div class="audience-setting-section">
		<div class="toggle-action">
			<button
				class="raise-hands-btn"
				class:active={audienceSetting.hand_raised}
				onclick={() => toggleDevice('hand_raised')}
			>
				<RaiseHand />
			</button>
			<div class="toggle-device">
				<button
					class="btn-device"
					onclick={() => toggleDevice('speaker_available')}
					class:disabled={!devicesEnable.speaker_enable}
				>
					{#if audienceSetting.speaker_available}
						<DeviceSpeaker />
					{:else}
						<DeviceSpeakerDisabled />
					{/if}
				</button>
				<button
					class="btn-device"
					onclick={() => toggleDevice('mic_available')}
					class:disabled={!devicesEnable?.mic_enable}
				>
					{#if audienceSetting.mic_available}
						<DeviceMic />
					{:else}
						<DeviceMicDisabled />
					{/if}
				</button>
				<button
					class="btn-device"
					onclick={() => toggleDevice('screenshare_available')}
					class:disabled={!devicesEnable?.screenshare_enable}
				>
					{#if audienceSetting.screenshare_available}
						<DeviceScreen />
					{:else}
						<DeviceScreenDisabled />
					{/if}
				</button>
				<button
					class="btn-device"
					onclick={() => toggleDevice('cam_available')}
					class:disabled={!devicesEnable?.cam_enable}
				>
					{#if audienceSetting.cam_available}
						<DeviceCamera />
					{:else}
						<DeviceCameraDisabled />
					{/if}
				</button>
			</div>
		</div>
		<div class="action-exit-setting">
			<form method="POST" class="action-exit-form" action="?/leave_backstage">
				<button class="btn-exit">
					<Phone />
				</button>
			</form>
			<button class="btn-setting">
				<SettingGear />
			</button>
		</div>
	</div>
</div>

<style lang="postcss">
	.backstage-section {
		@apply flex;
		@apply bg-secondary-dark;
		@apply my-4;
		@apply rounded;
	}
	.audience-container {
		/* height: 100px; */
		width: 100%;
		@apply flex justify-start flex-wrap gap-2;
		@apply py-2 px-2;
	}
	.audience-item {
		width: 40px;
		height: 40px;
	}
	.audience-item-image {
		width: 40px;
		height: 40px;
		@apply flex items-center justify-center;
		@apply rounded-full overflow-hidden;
		@apply border-2;
	}
	.audience-hand {
		margin-top: -48px;
		margin-left: 20px;
		color: yellow;
	}

	.audience-setting-section {
		@apply flex items-center;
		@apply bg-light-gray;
		@apply rounded-r;
		width: min-content;
	}

	.toggle-action {
		@apply flex flex-col items-center;
		@apply gap-2;
	}

	.toggle-device {
		width: 100px;
		@apply grid grid-cols-2 grid-rows-2 gap-y-2 place-items-center;
		@apply px-2;
		@apply pb-2;
		@apply text-secondary-dark;

		button:hover {
			@apply text-secondary;
		}

		button.disabled {
			@apply text-light-gray;
		}
	}
	.action-exit-setting {
		@apply w-8 h-full;
		@apply flex flex-col w-full items-center justify-evenly;
	}
	.btn-exit {
		height: 100%;
		@apply bg-accent-red;
		width: 42px;
		@apply px-2;
		@apply rounded-tr;

		&:hover {
			@apply bg-accent-red-dark;
		}
	}
	.action-exit-form {
		height: 70%;
		width: 100%;
	}
	.btn-setting {
		height: 30%;
		@apply w-full;
		@apply flex items-center justify-center;
		@apply bg-secondary-dark/50;

		&:hover {
			@apply bg-secondary-dark/80;
		}
	}
	.raise-hands-btn {
		@apply text-white/40;
	}
	.raise-hands-btn.active {
		@apply text-yellow-400;
	}
</style>
