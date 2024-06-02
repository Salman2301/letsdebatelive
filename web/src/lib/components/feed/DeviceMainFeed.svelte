<script lang="ts">
	import { micEnabled, screenShareEnable, speakerEnabled, toggleMedia, webcamEnable } from "$src/lib/stores/media.store";
	import { DeviceCamera, DeviceCameraDisabled, DeviceMic, DeviceMicDisabled, DeviceScreen, DeviceScreenDisabled, DeviceSpeaker, DeviceSpeakerDisabled } from "../icon";

 
</script>

<div class="main-buttons">
  <button onclick={()=>toggleMedia("speaker")} class="btn-main-icon">
    {#if $speakerEnabled}
      <DeviceSpeaker />
    {:else}
      <DeviceSpeakerDisabled />
    {/if}
  </button>

  <button onclick={()=>toggleMedia("mic")} class="btn-main-icon">
    {#if $micEnabled}
      <DeviceMic />
    {:else}
      <DeviceMicDisabled />
    {/if}
  </button>
  <button onclick={()=>toggleMedia("webcam")} class="btn-main-icon">
    {#if $webcamEnable}
      <DeviceCamera />
    {:else}
      <DeviceCameraDisabled />
    {/if}
  </button>
  <button onclick={()=>toggleMedia("screenShare")} class="btn-main-icon">
    {#if $screenShareEnable}
      <DeviceScreen />
    {:else}
      <DeviceScreenDisabled />
    {/if}
  </button>
</div>

<style lang="postcss">
	.main-buttons {
		@apply flex items-center gap-4 my-2 mb-4;
	}

	.btn-main-icon {
		@apply bg-secondary-dark;
		@apply rounded;
		@apply text-transparent;
		@apply p-2;
	}

	:global(.btn-main-icon > svg) {
		scale: 1.2;
	}

</style>