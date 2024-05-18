<script lang="ts">
	import TakeABreak from '../TakeABreak.svelte';
	import LayoutProfileMain from './layout-setting-icon/LayoutProfileMain.svelte';
	import LayoutScreenProfile from './layout-setting-icon/LayoutScreenProfile.svelte';
	import LayoutScreen from './layout-setting-icon/LayoutScreen.svelte';
	import LayoutProfileTwo from './layout-setting-icon/LayoutProfileTwo.svelte';
	import LayoutProfileChat from './layout-setting-icon/LayoutProfileChat.svelte';
	import supabase from '$lib/supabase';
	import type { ContentLayoutStyle, SceneType } from '../videoFeed/video-feed.types';
	import SceneLayout from '../videoFeed/scenes/component/SceneLayout.svelte';

	interface Props {
		currentLayoutStyle: ContentLayoutStyle;
		currentSceneType: SceneType;
	}

	let { currentLayoutStyle, currentSceneType }: Props = $props();

	let hostId = "123-456-789";

	function handleStopBroadcast() {

		// Create a live_debate
		supabase.channel(`broadcast_${hostId}`).send({
			type: "broadcast",
			event: "broadcast_end",// broadcast_suspended broadcast_ended
			payload: { hostId }
		});

		
		supabase.channel(`scene_${hostId}`, { config: {broadcast: {self: true}} }).send({
			type: "broadcast",
			event: "scene_change",
			payload: {
				sceneType: "scene_end",
				layerId: "layer_text",
				metadata: {
					text: "Broadcast has ended!"
				}
			}
		});

		
		console.log('stop broadcast');
	}

	function handleResume() {
		
		supabase.channel(`scene_${hostId}`, { config: {broadcast: {self: true}} }).send({
			type: "broadcast",
			event: "scene_change",
			payload: {
				sceneType: "scene_content",
				layerId: currentLayoutStyle,
				metadata: {
					text: "Broadcast has ended!"
				}
			}
		});
	}
</script>

<div class="layout-setting-container">
	{#if currentSceneType === "scene_content"}
		<div class="layout-icons">
			<button
				class="layout-icon"
				class:active={currentLayoutStyle === 'profileTwo'}
				on:click={() => (currentLayoutStyle = 'profileTwo')}
			>
				<LayoutProfileTwo />
			</button>
			<button
				class="layout-icon"
				class:active={currentLayoutStyle === 'screen'}
				on:click={() => (currentLayoutStyle = 'screen')}
			>
				<LayoutScreen />
			</button>
			<button
				class="layout-icon"
				class:active={currentLayoutStyle === 'screenProfile'}
				on:click={() => (currentLayoutStyle = 'screenProfile')}
			>
				<LayoutScreenProfile />
			</button>
			<button
				class="layout-icon"
				class:active={currentLayoutStyle === 'profileMain'}
				on:click={() => (currentLayoutStyle = 'profileMain')}
			>
				<LayoutProfileMain />
			</button>
			<button
				class="layout-icon"
				class:active={currentLayoutStyle === 'profileChat'}
				on:click={() => (currentLayoutStyle = 'profileChat')}
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
		@apply flex gap-2;
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
		width: 140px;
		@apply bg-accent-red rounded;
		height: 40px;
		font-size: 14px;
	}

	.btn-stop:hover {
		@apply bg-accent-red-dark;
	}
</style>
