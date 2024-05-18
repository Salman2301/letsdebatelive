<script lang="ts">
	import VideoFeed from './components/videoFeed/VideoFeed.svelte';
	import SmallSidePanel from "./components/mini-panel/MiniPanel.svelte";
	import supabase from '$lib/supabase';
	import LayoutHeader from './components/layout-action/LayoutHeader.svelte';
	import { onMount } from 'svelte';

  let hostId = "123-456-789";
  let latestScenePayload: any;
  onMount(async ()=>{
    supabase.channel(`scene_${hostId}`, { config: {broadcast: {self: true}} }).send({
      type: "broadcast",
      event: "scene_change",
      payload: {
        sceneType: "scene_start",
        layerId: "layer_text",
        metadata: {
          text: "Starting soon..."
        }
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
    await supabase.channel(`broadcast_${hostId}`).send({
      type: "broadcast",
      event: "broadcast_start",// broadcast_suspended broadcast_ended
      payload: {
        // host id,
        // start time,
        // title
        //
      }
    });
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