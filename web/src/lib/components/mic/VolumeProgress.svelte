<script lang="ts">
  const plates = [
    "rgba(189, 255, 0, 1)",
    "rgba(197, 248, 0, 1)",
    "rgba(204, 240, 0, 1)",
    "rgba(212, 233, 0, 1)",
    "rgba(220, 225, 0, 1)",
    "rgba(227, 218, 0, 1)",
    "rgba(235, 210, 0, 1)",
    "rgba(242, 203, 0, 1)",
    "rgba(250, 195, 0, 1)",
    "rgba(255, 188, 0, 1)",
    "rgba(255, 180, 0, 1)",
    "rgba(255, 173, 0, 1)",
    "rgba(255, 165, 0, 1)",
    "rgba(255, 158, 0, 1)",
    "rgba(255, 150, 0, 1)",
    "rgba(255, 143, 0, 1)",
    "rgba(255, 135, 0, 1)",
    "rgba(255, 128, 0, 1)",
    "rgba(255, 120, 0, 1)",
    "rgba(255, 113, 0, 1)",
    "rgba(255, 105, 0, 1)",
    "rgba(255, 98, 0, 1)",
    "rgba(255, 90, 0, 1)",
    "rgba(255, 83, 0, 1)",
    "rgba(255, 75, 0, 1)",
    "rgba(255, 68, 0, 1)",
    "rgba(255, 60, 0, 1)",
    "rgba(255, 53, 0, 1)",
    "rgba(255, 45, 0, 1)",
    "rgba(255, 0, 0, 1)",
  ]

  let { percent = 0.1 } = $props();
</script>

<div class="container">
  {#each plates as plate, i}
    <div class="plate" style="background:{i < Math.ceil(percent * 30) ? plate : "#000"};"></div>
  {/each}
</div>

<style lang="postcss">
  .container {
    @apply flex;
    border: 1px solid var(--color-light-gray);
    border-radius: 4px;
    max-width: 400px;
    height: 30px;
    @apply justify-evenly items-center;
    position: relative;
  }

  .plate {
    width: 6px;
    height: 18px;
    border: 1px solid var(--color-light-gray);
    border-radius: 6px;
    z-index: 3;
    /* mask-clip: calc(); */
  }

  /* .container::before {
    content:"";
    background: linear-gradient(90deg, rgba(189,255,0,1) 0%, rgba(255,0,0,1) 100%);
    width: 100%;
    height: 100%;
    position: absolute;
  } */


</style>