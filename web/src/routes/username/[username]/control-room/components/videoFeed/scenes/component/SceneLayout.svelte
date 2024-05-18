<script lang="ts">
 import BackgroundLayer from "../BackgroundLayer.svelte";

</script>


<div class="scene-start-container">
  <div class="layer">  
    <slot></slot>
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

</style>