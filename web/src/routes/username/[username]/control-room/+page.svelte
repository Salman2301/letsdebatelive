<script lang="ts">
	import VideoFeed from './components/videoFeed/VideoFeed.svelte';
	import SmallSidePanel from "./components/mini-panel/MiniPanel.svelte";
	import supabase from '$lib/supabase';
	import LayoutHeader from './components/layout-action/LayoutHeader.svelte';
	import { getContext, onMount } from 'svelte';
	import { emitBroadcastEvent, emitSceneChange } from './channel';

  let hostId: string = getContext("HOST_ID");
  let latestScenePayload: any;
  onMount(async ()=>{
    emitSceneChange(hostId, {
      sceneType: "scene_start",
      layerId: "layer_text",
      metadata: {
        text: "Starting soon..."
      }
    });

    console.log("sent broadcast")
    handleLive();

    supabase.channel(`scene_${hostId}`).on('broadcast', { event: 'scene_change' }, ({ payload }) => {
      latestScenePayload = payload;
      console.log('Latest scene payload:', latestScenePayload);
    });

  });

  async function handleLive() {
    // Create a live_debate
    emitBroadcastEvent("broadcast_start", hostId);
    console.log("clicked!")
  }
</script>

<div class="control-room-container">
  <VideoFeed />
  <LayoutHeader currentLayoutStyle="profileTwo" currentSceneType={latestScenePayload?.sceneType} />
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