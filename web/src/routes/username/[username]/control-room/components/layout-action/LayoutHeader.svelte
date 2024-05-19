<script lang="ts">
	import TakeABreak from '../TakeABreak.svelte';
	import LayoutProfileMain from './layout-setting-icon/LayoutProfileMain.svelte';
	import LayoutScreenProfile from './layout-setting-icon/LayoutScreenProfile.svelte';
	import LayoutScreen from './layout-setting-icon/LayoutScreen.svelte';
	import LayoutProfileTwo from './layout-setting-icon/LayoutProfileTwo.svelte';
	import LayoutProfileChat from './layout-setting-icon/LayoutProfileChat.svelte';
	import { getContext } from 'svelte';
	import { emitBroadcastEvent, emitSceneChange } from '../../channel';
	
	import type { LayerIdContent, SceneType } from '../videoFeed/video-feed.types';
	
	interface Props {
		currentLayoutStyle: LayerIdContent;
		currentSceneType: SceneType;
	}

	let { currentLayoutStyle, currentSceneType }: Props = $props();

	let hostId: string = getContext("HOST_ID");
  

	function handleStopBroadcast() {

		emitBroadcastEvent("broadcast_end", hostId, { hostId });
		
		emitSceneChange(hostId, {
			sceneType: "scene_end",
			layerId: "layer_text",
			metadata: {
				text: "Broadcast has ended!"
			}
		});

		
		console.log('stop broadcast');
	}

	function handleResume() {
		emitSceneChange(hostId, {
			sceneType: "scene_content",
			layerId: currentLayoutStyle,
		});
	}
</script>

<div class="layout-setting-container">
	{#if currentSceneType === "scene_content"}
		<div class="layout-icons">
			<button
				class="layout-icon"
				class:active={currentLayoutStyle === 'profile_multiple'}
				onclick={() => (currentLayoutStyle = 'profile_multiple')}
			>
				<LayoutProfileTwo />
			</button>
			<button
				class="layout-icon"
				class:active={currentLayoutStyle === 'screen'}
				onclick={() => (currentLayoutStyle = 'screen')}
			>
				<LayoutScreen />
			</button>
			<button
				class="layout-icon"
				class:active={currentLayoutStyle === 'screen_profile'}
				onclick={() => (currentLayoutStyle = 'screen_profile')}
			>
				<LayoutScreenProfile />
			</button>
			<button
				class="layout-icon"
				class:active={currentLayoutStyle === 'profile_main'}
				onclick={() => (currentLayoutStyle = 'profile_main')}
			>
				<LayoutProfileMain />
			</button>
			<button
				class="layout-icon"
				class:active={currentLayoutStyle === 'profile_chat'}
				onclick={() => (currentLayoutStyle = 'profile_chat')}
			>
				<LayoutProfileChat />
			</button>
		</div>
	{:else}
		<button onclick={handleResume}>Resume</button>
	{/if}
	<div class="layout-break-end">
		<TakeABreak />
		<button class="btn-stop" onclick={handleStopBroadcast}>
			Stop Broadcast
		</button>
	</div>
</div>

<style lang="postcss">
	.layout-setting-container {
		height: 48px;
		width: 100%;
		@apply flex justify-between;
	}

	.layout-setting-container {
		@apply flex items-center;
	}

	.layout-icons {
		@apply flex gap-1;
		/* scale: 0.9; */
	}

	.layout-icon {
		@apply text-secondary-dark;
	}

	.layout-icon:disabled {
		@apply text-light-gray;
		@apply cursor-not-allowed;
	}

	.layout-icon.active {
		@apply text-secondary;
	}

	.layout-break-end {
		@apply flex gap-2 items-center justify-end;
	}
	.btn-stop {
		@apply h-full;
		width: 120px;
		@apply bg-accent-red rounded;
		height: 30px;
		font-size: 12px;
	}

	.btn-stop:hover {
		@apply bg-accent-red-dark;
	}
</style>
