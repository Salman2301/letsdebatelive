<script lang="ts">
	import {
		RaiseHand,
		UserRemove,
		DeviceCamera,
		DeviceCameraDisabled,
		DeviceMic,
		DeviceMicDisabled,
		DeviceScreen,
		DeviceScreenDisabled,
		DeviceUserProfile,
		DeviceUserProfileDisabled,
		UserBan
	} from '$lib/components/icon';
	import UserImage from '$src/lib/components/user-image/UserImage.svelte';
	import CheckMark from '$lib/components/icon/CheckMark.svelte';

	import { tick } from 'svelte';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	import { getSupabase } from '$lib/supabase';

	import type { Tables } from '$lib/schema/database.types';
	import type { ParticipantsWithUserData } from '$src/lib/types';

	interface Props {
		participant: ParticipantsWithUserData;
		live_feed: Tables<'live_feed'>;
		teamMapColor: Record<string, string>;
		isStageFull: boolean;
		type: 'stage' | 'backstage';
	}

	let { participant, live_feed, teamMapColor, isStageFull, type }: Props = $props();

	let displayName = $state(participant.display_name);
	let showNameSubmitBtn = $state(false);

	const supabase = getSupabase();

	async function toggleDevice(device: keyof typeof participant) {
		const toUpdate = {
			[device]: !participant[device]
		};
		// INFO: keep the `await`, on remove if removed it doesn't update
		const { data, error } = await supabase
			.from('live_feed_participants')
			.update(toUpdate)
			.eq('live_feed', live_feed.id)
			.eq('participant_id', participant.participant_id.id);
	}

	async function onKeydownChange(event: KeyboardEvent) {
		await tick();
		if (event.key === 'Escape') {
			showNameSubmitBtn = false;
			displayName = participant.display_name;
			(event.target as HTMLInputElement).blur?.();
			return;
		}
		if (event.key === 'Enter') {
			updateName(displayName);
			(event.target as HTMLInputElement).blur?.();
			return;
		}

		showNameSubmitBtn = displayName !== participant.display_name;
	}

	async function updateName(name: string) {
		if (name === '') {
			newToast({
				message: "Name can't be empty",
				type: 'error'
			});
			return;
		}
		await updateLiveFeedParticipant({ display_name: name });
		showNameSubmitBtn = false;
	}

	async function updateLiveFeedParticipant(row: Partial<Tables<'live_feed_participants'>>) {
		try {
			await supabase
				.from('live_feed_participants')
				.update(row)
				.eq('live_feed', live_feed.id)
				.eq('participant_id', participant.participant_id.id);
		} catch (e) {
			console.error(e);
			newToast({
				type: 'error',
				message: 'Failed to update the database'
			});
		}
	}

	async function toggleLocation() {
		await updateLiveFeedParticipant({
			location: participant.location === 'stage' ? 'backstage' : 'stage'
		});
	}

	async function deleteParticipant() {
		try {
			const { error } = await supabase
				.from('live_feed_participants')
				.delete()
				.eq('live_feed', live_feed.id)
				.eq('participant_id', participant.participant_id.id)
				.throwOnError();
		} catch (e) {
			console.error(e);
			newToast({
				type: 'error',
				message: 'Failed to remove the user'
			});
		}
	}
</script>

<div class="card-container">
	<div class="left">
		<button onclick={deleteParticipant} class="btn-remove">
			<UserRemove />
		</button>

		<div class="username-img-default">
			<UserImage user={participant.participant_id} />
		</div>
		<div>
			<div class="username-text">
				<div
					class="team-circle"
					style="background-color:{participant.team ? teamMapColor[participant.team.id as string] : "white"}"
				></div>
				<div class="input-container">
					<input class="username-input" bind:value={displayName} onkeyup={onKeydownChange} />
					{#if showNameSubmitBtn}
						<button onclick={() => updateName(displayName)}>
							<CheckMark />
						</button>
					{/if}
				</div>
			</div>
			<div class="toggle-devices">
				<button class="toggle-device" onclick={() => toggleDevice('cam_enable')}>
					{#if participant.cam_enable}
						<DeviceCamera />
					{:else}
						<DeviceCameraDisabled />
					{/if}
				</button>
				<button class="toggle-device" onclick={() => toggleDevice('mic_enable')}>
					{#if participant.mic_enable}
						<DeviceMic />
					{:else}
						<DeviceMicDisabled />
					{/if}
				</button>
				<button class="toggle-device" onclick={() => toggleDevice('screenshare_enable')}>
					{#if participant.screenshare_enable}
						<DeviceScreen />
					{:else}
						<DeviceScreenDisabled />
					{/if}
				</button>
				<button class="toggle-device" onclick={() => toggleDevice('profile_image_enable')}>
					{#if participant.profile_image_enable}
						<DeviceUserProfile />
					{:else}
						<DeviceUserProfileDisabled />
					{/if}
				</button>
				<button class="toggle-device">
					<UserBan />
				</button>
			</div>
		</div>
	</div>
	<div class="footer">
		{#if participant.hand_raised}
			<RaiseHand />
		{/if}
		<div class="btn-action">
			<button
				class="btn-stage"
				onclick={() => toggleLocation()}
				disabled={type === 'backstage' && isStageFull}
			>
				{participant?.location === 'stage' ? 'Move to Backstage' : 'Add to Stage'}
			</button>
		</div>
	</div>
</div>

<style lang="postcss">
	.card-container {
		@apply bg-secondary-dark;
		@apply rounded border border-light-gray;
		@apply flex justify-between;
		@apply justify-self-center;
		width: 100%;
		height: 82px;
		@apply px-1;
		@apply mt-1;
	}

	.left {
		@apply flex items-center;
		@apply w-full;
		width: 360px;
		gap: 10px;
		padding-left: 10px;
	}

	.btn-remove {
		color: rgba(255, 255, 255, 0.6);
	}
	.btn-remove:hover {
		color: rgba(255, 255, 255, 1);
	}
	.username-img-default {
		aspect-ratio: 1;
		@apply rounded overflow-clip;
		@apply flex items-center justify-center;
		width: 48px;
		@apply relative;
	}
	.username-img-default {
		aspect-ratio: 1 / 1;
		@apply rounded overflow-clip;
		@apply flex items-center justify-center;
		width: 48px;
		height: 48px;
		@apply relative;
	}

	.username-text {
		@apply text-left;
		@apply flex items-center justify-center gap-1;
		@apply px-1;
	}

	.username-input {
		@apply bg-transparent;
		@apply outline-none;
		@apply border border-transparent;
		font-size: 18px;
		width: calc(100% - 12px);
	}
	.username-input:hover {
		@apply border-light-gray;
	}

	.toggle-devices {
		@apply flex justify-between;
		@apply text-secondary-dark;
	}
	.toggle-device {
		@apply border border-transparent;
		@apply rounded;
	}

	.toggle-device:hover {
		@apply text-secondary-dark;
		@apply border border-light-gray;
	}

	.footer {
		@apply flex justify-between items-center px-1;
	}

	.team-circle {
		min-width: 14px;
		min-height: 14px;
		width: 14px;
		height: 14px;
		border-radius: 100%;
		@apply bg-team-a;
	}

	.btn-stage {
		@apply bg-secondary;
		width: 140px;
		@apply rounded;
		font-size: 12px;
		height: 38px;
		@apply align-middle leading-none;
		@apply border border-light-gray;
	}
	.btn-stage:hover {
		@apply bg-primary-dark;
	}

	.btn-stage:disabled {
		background: darkgray;
		@apply cursor-not-allowed;
	}

	.btn-action {
		@apply w-full flex justify-end;
	}

	.input-container {
		@apply relative;
	}

	.input-container button {
		@apply absolute;
		top: 5px;
		right: -12px;
	}
</style>
