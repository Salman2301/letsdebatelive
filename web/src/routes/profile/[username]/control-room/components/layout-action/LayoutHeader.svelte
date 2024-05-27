<script lang="ts">
	import TakeABreak from '../TakeABreak.svelte';
	import LayoutProfileMain from './layout-setting-icon/LayoutProfileMain.svelte';
	import LayoutScreenProfile from './layout-setting-icon/LayoutScreenProfile.svelte';
	import LayoutScreen from './layout-setting-icon/LayoutScreen.svelte';
	import LayoutProfileTwo from './layout-setting-icon/LayoutProfileTwo.svelte';
	import LayoutProfileChat from './layout-setting-icon/LayoutProfileChat.svelte';
	import { getContext, onMount } from 'svelte';
	import { emitBroadcastEvent, emitSceneChange } from '../../channel';

	import { lastScreenPayloadContent } from '$lib/components/video-feed/scenes/store/scene';
	import { getSupabase } from '$lib/supabase';
	import { getControlRoomCtx } from '$lib/context/control-room';

	import type { LayerIdContent } from '$lib/components/video-feed/video-feed.types';

	let layerIdContent: LayerIdContent;
	const live_debate = getControlRoomCtx(getContext, 'ctx_table$live_debate');
	const supabase = getSupabase(getContext);

	// layer id of the content screen is same as 'layout', Instead of using LayerContentHeader
	// made sense to use LayoutHeader for short

	function handleStopBroadcast() {
		if (!$live_debate?.id) return;
		emitBroadcastEvent(supabase, 'broadcast_end', $live_debate.id, {
			liveDebateId: $live_debate.id
		});

		emitSceneChange(supabase, $live_debate.id, {
			sceneType: 'scene_end',
			layerId: 'layer_text',
			metadata: {
				text: 'Broadcast has ended!'
			}
		});
	}

	onMount(() => {
		layerIdContent = $lastScreenPayloadContent.layerId;
	});

	function setScreenLayout(newLayerIdContent?: LayerIdContent) {
		if (!$live_debate?.id) return;
		if (newLayerIdContent) {
			layerIdContent = newLayerIdContent;
		}

		emitSceneChange(supabase, $live_debate.id, {
			sceneType: 'scene_content',
			layerId: layerIdContent
		});
	}
</script>

<div class="layout-setting-container">
	{#if $lastScreenPayloadContent.sceneType === 'scene_content'}
		<div class="layout-icons">
			<button
				class="layout-icon"
				class:active={$lastScreenPayloadContent.layerId === 'profile_multiple'}
				onclick={() => setScreenLayout('profile_multiple')}
			>
				<LayoutProfileTwo />
			</button>
			<button
				class="layout-icon"
				class:active={$lastScreenPayloadContent.layerId === 'screen'}
				onclick={() => setScreenLayout('screen')}
			>
				<LayoutScreen />
			</button>
			<button
				class="layout-icon"
				class:active={$lastScreenPayloadContent.layerId === 'screen_profile'}
				onclick={() => setScreenLayout('screen_profile')}
			>
				<LayoutScreenProfile />
			</button>
			<button
				class="layout-icon"
				class:active={$lastScreenPayloadContent.layerId === 'profile_main'}
				onclick={() => setScreenLayout('profile_main')}
			>
				<LayoutProfileMain />
			</button>
			<button
				class="layout-icon"
				class:active={$lastScreenPayloadContent.layerId === 'profile_chat'}
				onclick={() => setScreenLayout('profile_chat')}
			>
				<LayoutProfileChat />
			</button>
		</div>
	{:else}
		<button onclick={() => setScreenLayout()}>Resume</button>
	{/if}
	<div class="layout-break-end">
		<TakeABreak />
		<button class="btn-stop" onclick={handleStopBroadcast}> Stop Broadcast </button>
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
