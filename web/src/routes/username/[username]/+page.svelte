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
    DeviceMic
    }
  from '$lib/components/icon';


	let sidebar: 'chat' | 'agenda' | 'qa' | 'backstage-chat' = $state('chat');

  let audienceSetting = $state({
    mic: true,
    cam: true,
    screenshare: true,
    raise_hand: true,
    speaker: true
  });

  function toggleDevice(device: keyof typeof audienceSetting) {
    audienceSetting[device] = !audienceSetting[device];
  }
</script>

<div class="page-container">
	<div class="live-video-content">
		<div class="video-container"></div>
		<div class="backstage-section">
			<div class="audience-container">
				{#each new Array(20).fill('') as item}
					<div class="audience">{item}</div>
				{/each}
			</div>
			<div class="audience-setting-section">
        <button
          class="raise-hands-btn"
          class:active={audienceSetting.raise_hand}
          onclick={()=>toggleDevice("raise_hand")}
        >
          <RaiseHand />
        </button>
        <div class="audience-setting-equip">
          <button
            class="btn-audience"
            onclick={()=>toggleDevice("speaker")}
          >
            {#if audienceSetting.speaker}
              <DeviceSpeaker />
            {:else}
              <DeviceSpeakerDisabled />
            {/if}
          </button>
          <button
            class="btn-audience"
            onclick={()=>toggleDevice("mic")}
          >
            {#if audienceSetting.mic}
              <DeviceMic />
            {:else}
              <DeviceMicDisabled />
            {/if}
          </button>
          <button
            class="btn-audience"
            onclick={()=>toggleDevice("screenshare")}
          >
            {#if audienceSetting.screenshare}
              <DeviceScreen />
            {:else}
              <DeviceScreenDisabled />
            {/if}
          </button>
          <button
            class="btn-audience"
            onclick={()=>toggleDevice("cam")}
          >
            {#if audienceSetting.cam}
              <DeviceCamera />
            {:else}
              <DeviceCameraDisabled />
            {/if}
          </button>
        </div>
      </div>
		</div>
		<div class="video-banner">Video banner</div>
		<div class="title">Title</div>
		<div class="title">Title</div>
		<div class="title">Title</div>
		<div class="title">Title</div>
		<div class="title">Title</div>
		<div class="title">Title</div>
		<div class="title">Title</div>
		<div class="title">Title</div>
		<div class="host-detail">Host detail</div>
		<div class="description">Host description</div>
		<div class="comment-section">After fact comment section</div>
	</div>
	<div class="chat-sticky-container">
		<div class="chat-content">
			<div class="chat-header">
				<button
					class="btn-switch"
					class:active={sidebar === 'chat'}
					onclick={() => (sidebar = 'chat')}
				>
					Chat
				</button>
				<button
					class="btn-switch"
					class:active={sidebar === 'agenda'}
					onclick={() => (sidebar = 'agenda')}
				>
					Agenda
				</button>
				<button class="btn-switch" class:active={sidebar === 'qa'} onclick={() => (sidebar = 'qa')}>
					QA
				</button>
				<button
					class="btn-switch"
					class:active={sidebar === 'backstage-chat'}
					onclick={() => (sidebar = 'backstage-chat')}
				>
					Backstage Chat
				</button>
			</div>
			<div class="chat-container">
				<div class="chat-items">
					<div class="chat-item">
						<span class="chat-item-username">username</span><span class="chat-item-content"
							>This is a content of the chat user</span
						>
					</div>
					<div class="chat-input-container">
						<textarea class="chat-text"></textarea>
						<button class="btn-submit">Submit</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="postcss">
	.page-container {
		@apply w-full;
		@apply flex gap-2;
    @apply mx-2;
	}

	.live-video-content {
		/* width: calc( 100% - 520px); */
		@apply h-full;
	}
  .video-container {
		aspect-ratio: 16 / 9;
		@apply rounded border border-light-gray;
    @apply bg-black;
  }
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
  .audience-setting-section {
    @apply bg-light-gray p-2;
    @apply flex flex-col items-center justify-center;
    @apply gap-2;
  }
  .audience-setting-equip {
    width: 100px;
    @apply grid grid-cols-2 grid-rows-2 gap-y-2 place-items-center;
    @apply px-2;
    @apply pb-2;
  }
  .btn-audience {
    @apply flex items-center justify-center;
    @apply text-secondary;
    width: 30px;
  }

  .raise-hands-btn.active {
    @apply text-yellow-400;
  }
  .audience {
    width: 40px;
    height: 40px;
    border-radius: 100%;
    @apply bg-transparent;
    @apply border border-white;

  }
  .chat-sticky-container {
    /* @apply h-full; */
    /* @apply border border-white; */
    @apply flex-grow;
  }
	.chat-content {
		width: 420px;
		height: calc(100vh - 76px);
		@apply flex flex-col;
		@apply sticky;
		right: 0px;
		top: 0px;
	}

	.chat-header {
		@apply flex items-center justify-evenly;
		@apply px-2 my-1;
	}

	.btn-switch {
		width: 100%;
		height: 40px;
		@apply rounded;
    @apply text-xs;
	}

	.btn-switch.active {
		@apply bg-white;
		@apply text-secondary;
	}

	.chat-container {
		@apply flex-grow;
		@apply overflow-auto;
		/* @apply border border-red-900; */
    @apply flex flex-col justify-between;
	}

  .chat-items {
    @apply w-full;
    @apply px-2;
  }

  .chat-input-container {
    @apply flex flex-col justify-end;
    height: calc(100vh - 76px - 70px);
  }
  .chat-text {
    @apply rounded;
    @apply border border-light-gray;
    @apply bg-transparent text-white;
    /* height: 120px; */
  }
  .btn-submit {
    @apply self-end;
    @apply text-xs;
    @apply bg-primary;
    @apply px-2 py-1;
    @apply my-1;
    @apply rounded;
    @apply border border-primary;
  }
  .btn-submit:hover {
    @apply bg-primary-dark;
  }

  .chat-item {
    @apply py-1;
    @apply text-xs;
  }
  .chat-item-username {
    @apply text-team-a;
    @apply pr-2;
  }
</style>
