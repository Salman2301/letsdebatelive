<script lang="ts">
	import StartingScene from './components/scenes/StartingScene.svelte';
  import BreakScene from './components/scenes/BreakScene.svelte';
	import Loader from '$lib/components/icon/Loader.svelte';
	import SmallSidePanel from "./components/small-sidepanel/SmallSidePanel.svelte";
	import supabase from '$lib/supabase';
	import { onMount } from 'svelte';
	import LayoutHeader from './components/LayoutHeader.svelte';

  let hostId = "123-1234-123";

  let next10Mins = new Date();
  next10Mins.setMinutes( next10Mins.getMinutes() + 10 );
  
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

  let sceneType: any, payloadData: any= { metadata: { text: "loading"}};

  onMount(()=>{
    supabase.channel(`scene_${hostId}`).on("broadcast", { event: "scene_change"}, ( { payload } )=> {
      if( !payload || !payload.sceneType ) {
        console.error("Empty payload received?", payload);
        return;
      }
      sceneType = payload.sceneType;
      payloadData = payload;
      console.log({ sceneType, payload })
    }).subscribe();
  })

</script>

<!-- Check for admin -->
<!-- Sidebar -->

<div class="control-room-container">
  <div class="video-container">
    {#if sceneType === "scene_start"}
      <StartingScene payload={payloadData}/>
    {:else if sceneType === "scene_break"}
      <BreakScene payload={payloadData}/>
    {:else}
      <div class="loader-container">       
        <Loader />
      </div>
    {/if}
  </div>
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
  .video-container {
    aspect-ratio: 16 / 9;
    @apply border border-light-gray;
    overflow: hidden;
  }
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
  .small-panel-2 {
    /* @apply border-r border-light-gray; */
  }

  .loader-container {
    @apply flex justify-center items-center;
    @apply w-full h-full;
  }
</style>