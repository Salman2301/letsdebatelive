<script lang="ts">
	import EndingScene from './scenes/EndingScene.svelte';
	import StartingScene from './scenes/StartingScene.svelte';
  import BreakScene from './scenes/BreakScene.svelte';
	import Loader from '$lib/components/icon/Loader.svelte';
	import { onMount } from 'svelte';
	import supabase from '$lib/supabase';
 
  let sceneType: any, payloadData: any= { metadata: { text: "loading"}};
  
  let hostId = "123-1234-123";
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

<div class="video-container">
  {#if !!sceneType}
    <!-- Need to communicate with puppetter page ready -->
    <div class="loaded-video-el"></div> 
  {/if}
  {#if sceneType === "scene_start"}
    <StartingScene payload={payloadData}/>
  {:else if sceneType === "scene_break"}
    <BreakScene payload={payloadData}/>
  {:else if sceneType === "scene_end"}
    <EndingScene payload={payloadData}/>
  {:else}
    <div class="loader-container">       
      <Loader />
    </div>
  {/if}
</div>

<style lang="postcss">
  .video-container {
    aspect-ratio: 16 / 9;
    @apply border border-light-gray;
    overflow: hidden;
    width: 100%;
  }

  .loader-container {
    @apply flex justify-center items-center;
    @apply w-full h-full;
  }
</style>