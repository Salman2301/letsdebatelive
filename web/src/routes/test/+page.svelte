<script lang="ts">
	import Button from "$src/lib/components/button/Button.svelte";
	import { openSidePanel } from "$src/lib/components/side-panel/side-panel.store";
	import { webcamStream } from "$src/lib/stores/media.store";
	import { getSupabase } from "$src/lib/supabase";
	import { WebRTCRoom } from "$src/lib/utils/webRTC.utils";
  import { page } from "$app/stores";
	import { newToast } from "$src/lib/components/toast/Toast.svelte";

  let videoEl: HTMLVideoElement;

  const supabase = getSupabase();

  async function handleClick(join?: boolean) {
    console.log("live feed?")
    console.log('init webrtc');
    console.log({ supabase })
    const id = $page.url.searchParams.get("id");
    if(!id) {
      return newToast({ type: 'error', message: 'No id provided' });
    }
    const rtc = new WebRTCRoom(id, videoEl, supabase);
    console.log(rtc);
    await rtc.init();
    if(join) await rtc.makeCall();
  }
</script>

<Button label="Open panel" onclick={()=>openSidePanel("equip")}></Button>
<Button label="MakeCall" onclick={()=>handleClick(true)}></Button>
<Button label="Listen and join" onclick={()=>handleClick()}></Button>
<video src="" bind:this={videoEl} playsinline autoplay controls={true}>
  <track kind="captions" />
</video>

<style lang="postcss">
  video {
    border: 1px solid white;
  }
</style>