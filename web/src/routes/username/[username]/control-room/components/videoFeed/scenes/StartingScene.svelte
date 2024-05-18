<script lang="ts">
	import BackgroundLayer from "./BackgroundLayer.svelte";

  interface PayloadStarting {
    metadata : {
      text: string;
    }
  }
  let { payload={ metadata: { text: "empty" }} }: { payload: PayloadStarting} = $props();
</script>

<div class="scene-start-container">
  <div class="layer">  
    <div class="text-center">{payload.metadata.text}</div>
  </div>
  <BackgroundLayer />
</div>

<style lang="postcss">
  .scene-start-container {
    position: relative;
    width: 100%;
    height: 100%;
  }

  .layer {
    @apply absolute;
    z-index: 1;
    @apply flex items-center justify-center;
    @apply w-full h-full;
  }

  .text-center {
    font-size: 24px;
  }
</style>