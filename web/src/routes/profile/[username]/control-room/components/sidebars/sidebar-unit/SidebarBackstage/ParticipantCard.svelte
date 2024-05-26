<script lang="ts">
	import { getSupabase } from '$lib/supabase';
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
		UserBan,
		CheckMark,
	} from '$lib/components/icon';
	

	import { getContext, tick } from 'svelte';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	import type { Tables } from '$lib/schema/database.types';
	
	interface Props {
		participant: Tables<'live_debate_participants'>;
		live_debate: Tables<'live_debate'>;
		teamMapColor: Record<string, string>;
		isStageFull: boolean;
		type: "backstage" | "stage";
	}

	let { participant, live_debate, teamMapColor, isStageFull, type }: Props = $props();

	let displayName = $state(participant.display_name);
	let showNameSubmitBtn = $state(false);

	const supabase = getSupabase(getContext);

	async function toggleDevice(device: keyof typeof participant) {
		const toUpdate = {
			[device]: !participant[device]
		};
		// INFO: keep the `await`, on remove if removed it doesn't update
		await supabase
			.from('live_debate_participants')
			.update(toUpdate)
			.eq('live_debate', live_debate.id)
			.eq('participant_id', participant.participant_id);
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
		await updateLiveDebateParticipant({ display_name: name });
		showNameSubmitBtn = false;
	}

	async function updateLiveDebateParticipant(row: Partial<Tables<'live_debate_participants'>>) {
		try {
			await supabase
				.from('live_debate_participants')
				.update(row)
				.eq('live_debate', live_debate.id)
				.eq('participant_id', participant.participant_id);
		} catch (e) {
			console.error(e);
			newToast({
				type: 'error',
				message: 'Failed to update the databse'
			});
		}
	}

	async function toggleLocation() {
		await updateLiveDebateParticipant({ location: participant.location === "stage" ? "backstage" : "stage" });
	}

	async function deleteParticipant() {
		try {
			const { error } = await supabase
				.from('live_debate_participants')
				.delete()
				.eq('live_debate', live_debate.id)
				.eq('participant_id', participant.participant_id)
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
	<div class="username-img-default">
		<div class="header-float">
			{#if participant.hand_raised}
				<RaiseHand />
			{:else}
				<div></div>
			{/if}
			<button onclick={deleteParticipant}>
				<UserRemove />
			</button>
		</div>
		<div class="circle-icon">
			{participant.display_name?.[0].toUpperCase() || 'A'}
		</div>
	</div>
	<div class="username-text">
		<div class="team-circle" style="background-color:{teamMapColor[participant.team]}"></div>
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
	<div class="footer">
		<div class="btn-action">
			<button
				class="btn-stage"
				onclick={() => toggleLocation()}
				disabled={type==="backstage" && isStageFull}
			>
				{participant?.location === 'stage' ? 'Move to backstage' : 'Move to stage'}
			</button>
		</div>
	</div>
</div>

<style lang="postcss">
	.card-container {
		@apply bg-secondary-dark;
		@apply rounded border border-light-gray;
		width: 192px;
		height: 260px;
	}
	.username-img-default {
		width: 100%;
		aspect-ratio: 4 / 3;
		@apply rounded overflow-clip;
		@apply flex items-center justify-center;
		@apply relative;
	}
	.header-float {
		@apply flex justify-between items-center;
		@apply w-full pr-2;
		@apply absolute top-0;
		height: 24px;
	}
	.circle-icon {
		width: 60px;
		height: 60px;
		@apply my-2;
		@apply rounded-full;
		@apply flex items-center justify-center;
		@apply text-center;
		font-size: 32px;
		background-color: white;
		@apply text-secondary-dark;
	}

	.username-img-default {
		width: calc(100% - 8px);
		aspect-ratio: 4 / 3;
		@apply m-1;
		background: linear-gradient(0deg, white, rgb(var(--color-secondary)));
	}

	.username-text {
		@apply text-left;
		height: 30px;
		@apply flex items-center justify-center gap-1;
		@apply px-1;
	}

	.username-input {
		@apply bg-transparent;
		@apply outline-none;
		@apply border border-transparent;
		@apply my-2;

		width: calc(100% - 12px);
	}
	.username-input:hover {
		@apply border-light-gray;
	}

	.toggle-devices {
		@apply flex justify-evenly;
		@apply text-secondary-dark;
		@apply my-2;
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
		width: 120px;
		@apply rounded;
		font-size: 12px;
		@apply font-semibold;
		height: 28px;
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
		top: 12px;
		right: 14px;
	}
</style>
