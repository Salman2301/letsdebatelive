<script lang="ts">
	import VideoFeed from './components/VideoFeed.svelte';
	import SmallSidePanel from "./components/small-sidepanel/SmallSidePanel.svelte";
	import supabase from '$lib/supabase';
	import LayoutHeader from './components/LayoutHeader.svelte';
	import { onMount } from 'svelte';

  let hostId = "123-1234-123";
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
  <button on:click={handleLive}>Go Live!!!!</button>
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
  .small-panel-container {
    display: flex;
    width: 100%;
    height: calc( 100vh - 420px - 48px - 76px );  /* 100vh - video height -layout-panel - navbar height */
    @apply border border-light-gray;
  }

  .small-panel {
    width: 50%;
    height: 100%;
  }
  .small-panel-1 {
    @apply border-r border-light-gray;
  }

</style>