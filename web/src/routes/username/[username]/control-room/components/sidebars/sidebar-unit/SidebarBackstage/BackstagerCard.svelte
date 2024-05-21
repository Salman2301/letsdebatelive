<script lang="ts">
	import RaiseHand from '$lib/components/icon/RaiseHand.svelte';
	import UserRemove from '$lib/components/icon/UserRemove.svelte';
	import DeviceCamera from "$lib/components/icon/DeviceCamera.svelte";
	import DeviceCameraDisabled from "$lib/components/icon/DeviceCameraDisabled.svelte";
	import DeviceMic from "$lib/components/icon/DeviceMic.svelte";
	import DeviceMicDisabled from "$lib/components/icon/DeviceMicDisabled.svelte";
	import DeviceScreen from "$lib/components/icon/DeviceScreen.svelte";
	import DeviceScreenDisabled from "$lib/components/icon/DeviceScreenDisabled.svelte";
	import DeviceUserProfile from "$lib/components/icon/DeviceUserProfile.svelte";
	import DeviceUserProfileDisabled from "$lib/components/icon/DeviceUserProfileDisabled.svelte";
	import UserBan from "$lib/components/icon/UserBan.svelte";
	
	import supabase from '$lib/supabase';

	import type { Tables } from '$lib/schema/database.types';
	import type { FormEventHandler } from 'svelte/elements';
	import { tick } from 'svelte';
	import { newToast } from '$lib/components/toast/Toast.svelte';

  interface Props {
    backstager: Tables<"live_debate_participants">;
		live_debate: Tables<"live_debate">;
		teamMapColor: Record<string, string>;
  }

  let { backstager, live_debate, teamMapColor }: Props = $props();

	let displayName = $state(backstager.display_name);
	let showNameSubmitBtn = $state(false);
	
	async function toggleDevice(device: keyof typeof backstager) {
		const toUpdate = {
			[device]: !backstager[device]
		}
		// INFO: keep the `await`, on remove if removed it doesn't update
		await supabase.from("live_debate_participants").update(toUpdate)
		.eq( "live_debate", live_debate.id)
		.eq( "participant_id", backstager.participant_id);
	}

	async function onKeydownChange(event: KeyboardEvent ) {
		await tick();
		if( event.key === "Escape") {
			showNameSubmitBtn = false;
			displayName = backstager.display_name;
			return;
		}
		if( event.key === "Enter") {
			updateName(displayName);
			return;
		}

		showNameSubmitBtn = displayName !== backstager.display_name;
	}

	async	function updateName(name: string) {
		if(name === "") {
			newToast({
				message: "Name can't be empty",
				type: "error"
			});
			return;
		}
		await updateLiveDebateParticipant({ display_name: name });
		showNameSubmitBtn = false;
	}

	async function updateLiveDebateParticipant(row: Partial<Tables<"live_debate_participants">>) {
		try {
			await supabase.from("live_debate_participants").update(row)
			.eq( "live_debate", live_debate.id)
			.eq( "participant_id", backstager.participant_id);
		}
		catch(e) {
			console.error(e);
			newToast({
				type: "error",
				message: "Failed to update the databse"
			})
		}
	}

	async function moveToStage() {
		await updateLiveDebateParticipant({ location: "stage" });
	}

	async function deleteParticipant() {
		try {
			const { error } = await supabase.from("live_debate_participants").delete()
			.eq( "live_debate", live_debate.id)
			.eq( "participant_id", backstager.participant_id).throwOnError();

			console.log({ error });
		}
		catch(e) {
			console.error(e);
			newToast({
				type: "error",
				message: "Failed to remove the user"
			})
		}
	}

</script>


<div class="card-container">
  <div class="username-img-default">
    <div class="header-float">
      {#if backstager.hand_raised}
        <RaiseHand />
      {:else}
        <div></div>
      {/if}
			<button onclick={deleteParticipant}>
				<UserRemove />
			</button>
    </div>
    <div class="circle-icon">
      {backstager.display_name?.[0].toUpperCase() || 'A'}
    </div>
  </div>
  <div class="username-text">
    <div class="team-circle" style="background-color:{teamMapColor[backstager.team]}">
    </div>
		<div class="input-container">
			<input class="username-input" bind:value={displayName} onkeyup={onKeydownChange} />
			{#if showNameSubmitBtn}
				<button onclick={()=>updateName(displayName)}>
					<svg width="21" height="20" viewBox="0 0 21 20" fill="none" xmlns="http://www.w3.org/2000/svg">
						<path fill-rule="evenodd" clip-rule="evenodd" d="M0.914551 10C0.914551 7.34783 1.96812 4.8043 3.84348 2.92893C5.71885 1.05357 8.26239 0 10.9146 0C13.5667 0 16.1103 1.05357 17.9856 2.92893C19.861 4.8043 20.9146 7.34783 20.9146 10C20.9146 12.6522 19.861 15.1957 17.9856 17.0711C16.1103 18.9464 13.5667 20 10.9146 20C8.26239 20 5.71885 18.9464 3.84348 17.0711C1.96812 15.1957 0.914551 12.6522 0.914551 10ZM15.9746 6.662C16.1421 6.38108 16.1928 6.04569 16.1159 5.72777C16.039 5.40986 15.8405 5.13476 15.5631 4.9615C15.2857 4.78824 14.9514 4.73062 14.632 4.80101C14.3126 4.8714 14.0335 5.06418 13.8546 5.338L9.68655 12.006L7.79855 10.116C7.5641 9.88155 7.24611 9.74984 6.91455 9.74984C6.58299 9.74984 6.265 9.88155 6.03055 10.116C5.7961 10.3505 5.66439 10.6684 5.66439 11C5.66439 11.1642 5.69672 11.3267 5.75955 11.4784C5.82238 11.6301 5.91446 11.7679 6.03055 11.884L9.03055 14.884C9.16342 15.0171 9.3246 15.1184 9.50208 15.1805C9.67955 15.2427 9.86876 15.2639 10.0556 15.2428C10.2424 15.2216 10.4221 15.1586 10.5812 15.0584C10.7403 14.9582 10.8748 14.8234 10.9746 14.664L15.9746 6.664V6.662Z" fill="white"/>
					</svg>
				</button>
			{/if}
		</div>
  </div>
  <div class="toggle-devices">
    <button
			class="toggle-device"
			onclick={()=>toggleDevice("cam_enable")}
		>
		{#if backstager.cam_enable}
			<DeviceCamera />
		{:else}
			<DeviceCameraDisabled />
		{/if}
    </button>
    <button
			class="toggle-device"
			onclick={()=>toggleDevice("mic_enable")}
		>
			{#if backstager.mic_enable}
      	<DeviceMic />
			{:else}
				<DeviceMicDisabled />
			{/if}
    </button>
    <button
			class="toggle-device"
			onclick={()=>toggleDevice("screenshare_enable")}
		>
			{#if backstager.screenshare_enable}
				<DeviceScreen />
			{:else}
				<DeviceScreenDisabled />
			{/if}
    </button>
    <button
			class="toggle-device"
			onclick={()=>toggleDevice("profile_image_enable")}
		>
			{#if backstager.profile_image_enable}
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
				onclick={()=>moveToStage()}
			>
			Add to stage
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

	.active {
		color: #ccc;
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
		@apply bg-primary;
		width: 120px;
		@apply rounded;
		font-size: 12px;
		@apply font-semibold;
		height: 28px;
	}
	.btn-stage:hover {
		@apply bg-primary-dark;
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