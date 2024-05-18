<script lang="ts">
	import { onDestroy, onMount } from "svelte";
	import BackgroundLayer from "./BackgroundLayer.svelte";

  interface PayloadBreaking {
    metadata : {
      timeout: string;
      breakEndAt: string;
    }
  }

  let { payload={ metadata: { timeout: "5min", breakEndAt: new Date().toISOString() }} }: { payload: PayloadBreaking} = $props();

  let timerStr = $state("00:00:00");
  let timeoutInterval: NodeJS.Timeout;

  $effect(()=>{
    if( timeoutInterval ) clearInterval(timeoutInterval);

    const endTime = new Date(payload.metadata.breakEndAt);

    timeoutInterval = setInterval(() => {
      let now = Date.now();
      let diff = endTime.getTime() - now;
      if( diff<=0) {
        timerStr = "00:00:00";
        clearInterval(timeoutInterval);
        return;
      }
      let hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      let minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
      let seconds = Math.floor((diff % (1000 * 60)) / 1000);
     
      const padZero = (num: number)=> num <=9 ? `0${num}`: num;
      timerStr = padZero(hours) + ":" + padZero(minutes) + ":" + padZero(seconds);
      console.log("timer");
    }, 100);

  })

  onDestroy(()=>{
    clearInterval(timeoutInterval);
  })


</script>

<div class="scene-start-container">
  <div class="layer">  
    <p class="text-center">Taking a break</p>
    <p class="text-center timer">{timerStr}</p>
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
    @apply flex items-center justify-center flex-col;
    @apply w-full h-full;
  }

  .text-center {
    font-size: 24px;
  }

  .timer {
    @apply px-4;
    border-radius: 24px;
    font-size: 32px;
    border: 1px solid white;
    @apply bg-white text-black;
    @apply mt-2;
  }
</style>