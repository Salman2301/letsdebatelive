<script lang="ts">
	import VideoFeed from '$lib/components/video-feed/VideoFeed.svelte';
	import SmallSidePanel from './components/mini-panel/MiniPanel.svelte';
	import LayoutHeader from './components/layout-action/LayoutHeader.svelte';

	import { getContext, onMount } from 'svelte';

	import { getSupabase } from '$lib/supabase';
	import { emitBroadcastEvent, emitSceneChange } from './channel';
	import { PageCtx } from '$src/lib/context';

	const supabase = getSupabase();
	const pageCtx = new PageCtx('control-room');

	const live_feed = pageCtx.get('ctx_table$live_feed');

	onMount(async () => {
		if (!$live_feed?.id) return;
		emitSceneChange(supabase, $live_feed.id, {
			sceneType: 'scene_content',
			layerId: 'profile_multiple'
		});


		handleLive();
	});

	async function handleLive() {
		if (!$live_feed?.id) return;
		// Create a live_feed
		emitBroadcastEvent(supabase, 'broadcast_start', $live_feed?.id);
	}
</script>

<div class="control-room-container hidden">
	{#if $live_feed?.id}
		<VideoFeed live_feed_id={$live_feed?.id} makeCall={true} />
	{/if}
	<LayoutHeader />
	<div class="small-panel-container">
		<div class="small-panel small-panel-1">
			<SmallSidePanel />
		</div>
		<div class="small-panel small panel-2">
			<SmallSidePanel />
		</div>
	</div>
</div>

<style lang="postcss">
	.control-room-container {
		display: flex;
		flex-direction: column;
		height: 100%;
	}
	.small-panel-container {
		display: flex;
		width: 100%;
		@apply border border-light-gray;
		@apply flex-auto;
	}

	.small-panel {
		width: 50%;
		height: 100%;
	}
	.small-panel-1 {
		@apply border-r border-light-gray;
	}
</style>
