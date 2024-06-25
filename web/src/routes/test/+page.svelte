<script lang="ts">
	import Button from "$src/lib/components/button/Button.svelte";
  import VideoFeed from "$src/lib/components/video-feed/VideoFeed.svelte";
	import { openSidePanel } from "$src/lib/components/side-panel/side-panel.store";
	import { webcamStream } from "$src/lib/stores/media.store";
	import { getSupabase } from "$src/lib/supabase";
	import { WebRTCRoom } from "$src/lib/utils/webRTC.utils";
  import { page } from "$app/stores";
	import { newToast } from "$src/lib/components/toast/Toast.svelte";
	import { onMount } from "svelte";

  let videoEl: HTMLVideoElement;

  const supabase = getSupabase();
  let live_feed_id = $state("");
  async function handleClick(join?: boolean) {
    if(!live_feed_id) {
      return newToast({ type: 'error', message: 'No id provided' });
    }
    // const rtc.init();
    // if(join) await rtc.makeCall();
  }

  onMount(()=>{
    live_feed_id = $page.url.searchParams.get("id") || "";

    setTimeout(()=>{
      
      supabase.channel(`scene_${live_feed_id}`).send({
        type: "broadcast",
        event: "scene_change",
        payload: {
          sceneType: "scene_content"
        } 
      }).catch(console.error).then(console.log)

    }, 1000);

  });
</script>

<Button label="Open panel" onclick={()=>openSidePanel("equip")}></Button>
<Button label="MakeCall" onclick={()=>handleClick(true)}></Button>
<Button label="Listen and join" onclick={()=>handleClick()}></Button>

{#if live_feed_id}
  <VideoFeed live_feed_id={live_feed_id} />
{/if}

<!-- <video src="" bind:this={videoEl} playsinline autoplay controls={true}>
  <track kind="captions" />
</video> -->

<style lang="postcss">
  /* video {
    border: 1px solid white;
  } */
</style>