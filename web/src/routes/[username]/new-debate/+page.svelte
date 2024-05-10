<script lang="ts">
	import Heading3 from '$lib/components/form/Heading3.svelte';
	import Heading2 from '$lib/components/form/Heading2.svelte';
  import BubbleError from "$lib/components/bubble/BubbleError.svelte";

  let errorWebcamFeed: string = "";
  let errorScreenShareFeed: string = "";
  let webcamFeedPlaying: boolean = false;
  let screenSharePlaying: boolean = false;

  let initWebCam: boolean = false;
  let initScreenShare:boolean = false;
	let videoInstance: HTMLVideoElement;
	let videoScreenShareInstance: HTMLVideoElement;


  async function playWebCam() {
    try {
      let feedNotAvailable = !(navigator.mediaDevices && navigator.mediaDevices.getUserMedia);
      if(feedNotAvailable) errorWebcamFeed = "Unsupported browser try different browser";

      const stream = await navigator.mediaDevices.getUserMedia({ video: true });
      errorWebcamFeed = "";
      videoInstance.srcObject = stream;
      videoInstance.play();
      initWebCam = true;
      webcamFeedPlaying = true;
    }
    catch(e) {
      errorWebcamFeed = "Permission denied!";
      console.error(e);
    }
  }

  function toggleWebCam() {
    if( videoInstance.paused ) {
      if( initWebCam ) videoInstance.play();
      else playWebCam();
    }
    else {
      videoInstance.pause();
    }
  }

  
  function toggleScreenShare() {
    if( videoScreenShareInstance.paused ) {
      if( initScreenShare ) videoScreenShareInstance.play();
      else playScreenShare();
    }
    else {
      videoScreenShareInstance.pause();
    }
  }

  async function playScreenShare() {
    try {
      let feedNotAvailable = !(navigator.mediaDevices && navigator.mediaDevices.getDisplayMedia);
      if(feedNotAvailable) errorScreenShareFeed = "Unsupported browser try different browser";

      const stream = await navigator.mediaDevices.getDisplayMedia({ video: true });
      errorScreenShareFeed = "";
      videoScreenShareInstance.srcObject = stream;
      videoScreenShareInstance.play();
      screenSharePlaying = true;
      initScreenShare = true;
    }
    catch(e) {
      errorScreenShareFeed = "Permission denied!";
      console.error(e);
    }
  }

</script>

<Heading2 content="New debate" textAlign="center" />

<div class="video-feed">
	<div class="video-title-container">
    <div class="header">
      <Heading3 content="WebCAM" textAlign="center" />
      <BubbleError show={!!errorWebcamFeed}  message={errorWebcamFeed}/>
    </div>
      
		<div class="video-container">
			<!-- svelte-ignore invalid_self_closing_tag -->
			<!-- svelte-ignore a11y_media_has_caption -->
			<video bind:this={videoInstance} autoplay playsinline />
		</div>
    <button
      on:click={toggleWebCam}
    >
      {videoInstance?.paused ? "Play" : "Pause"}
    </button>
	</div>
	<div class="video-title-container">
		<Heading3 content="ScreenShare" textAlign="center" />
		<div class="video-container">
			<!-- svelte-ignore invalid_self_closing_tag -->
			<!-- svelte-ignore a11y_media_has_caption -->
			<video bind:this={videoScreenShareInstance} autoplay playsinline />
		</div>
    <button
      on:click={toggleScreenShare}
    >
      {videoScreenShareInstance?.paused ? "Play" : "Pause"}
    </button>
	</div>
</div>

<style lang="postcss">
	.video-feed {
		@apply flex justify-evenly;
	}

  .header {
    @apply flex items-center justify-center gap-1;
  }
	.video-title-container {
		@apply flex flex-col w-full;
		width: 550px;
	}
	.video-container {
		border-radius: 10px;
		border: 1px solid var(--color-light-gray);
		aspect-ratio: 16/9;
		overflow: hidden;
	}
</style>
