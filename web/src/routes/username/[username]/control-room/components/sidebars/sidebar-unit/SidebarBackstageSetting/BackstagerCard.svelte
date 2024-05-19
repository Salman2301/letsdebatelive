<script lang="ts">
	import RaiseHand from '$lib/components/icon/RaiseHand.svelte';
	import UserRemove from '$lib/components/icon/UserRemove.svelte';
	import DeviceCamera from "$lib/components/icon/DeviceCamera.svelte";
	import DeviceMic from "$lib/components/icon/DeviceMic.svelte";
	import DeviceScreen from "$lib/components/icon/DeviceScreen.svelte";
	import DeviceUserProfile from "$lib/components/icon/DeviceUserProfile.svelte";
	import UserBan from "$lib/components/icon/UserBan.svelte";
	import type { Tables } from '$lib/schema/database.types';

  interface Props {
    backstager: Tables<"live_debate_participants">;
  }

  let { backstager }: Props = $props();
</script>


<div class="card-container">
  <div class="username-img-default">
    <div class="header-float">
      {#if true}
        <RaiseHand />
      {:else}
        <div></div>
      {/if}
			<button>
				<UserRemove />
			</button>
    </div>
    <div class="circle-icon">
      {backstager.display_name?.[0].toUpperCase() || 'A'}
    </div>
  </div>
  <div class="username-text">
    <div class="team-circle">
    </div>
    <input class="username-input" value={backstager.display_name} />
  </div>
  <div class="toggle-devices">
    <div class="toggle-device">
      <DeviceCamera />
    </div>
    <div class="toggle-device">
      <DeviceMic />
    </div>
    <div class="toggle-device">
      <DeviceScreen />
    </div>
    <div class="toggle-device">
      <DeviceUserProfile />
    </div>
    <div class="toggle-device">
      <UserBan />
    </div>
  </div>
  <div class="footer">
    <div class="btn-action">
      <button class="btn-stage">Add to stage</button>
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
		@apply text-secondary;
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

</style>