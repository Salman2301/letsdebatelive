<script lang="ts">
	import VideoFeed from '$lib/components/video-feed/VideoFeed.svelte';
	import SmallSidePanel from "./components/mini-panel/MiniPanel.svelte";
	import LayoutHeader from './components/layout-action/LayoutHeader.svelte';

	import { CTX_KEY_LIVE_DEBATE } from './constant';
	import { getContext, onMount } from 'svelte';
	import { getSupabase } from '$lib/supabase';
	import { emitBroadcastEvent, emitSceneChange } from './channel';

	import type { Tables } from '$lib/schema/database.types';
	import type { Writable } from 'svelte/store';

  const supabase = getSupabase(getContext);
  const live_debate: Writable<Tables<"live_debate">> = getContext(CTX_KEY_LIVE_DEBATE);

  onMount(async ()=>{
    emitSceneChange(supabase, $live_debate?.id, {
      sceneType: "scene_content",
      layerId: "profile_multiple"
    });

    handleLive();

  });

  async function handleLive() {
    // Create a live_debate
    emitBroadcastEvent(supabase, "broadcast_start", $live_debate?.id);
  }
</script>

<div class="control-room-container hidden">
  <VideoFeed live_debate_id={$live_debate?.id}/>
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