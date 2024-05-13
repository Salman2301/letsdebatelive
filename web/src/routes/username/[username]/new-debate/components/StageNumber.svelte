<script lang="ts">
  interface Props {
    active: number;
  }
  let { active }: Props = $props();

  let stages = new Array(5).fill("").map((_,i)=>i+1);

</script>

<div class="stage-number-container">
  {#each stages as stage}
    <div
      class="stage-number"
      class:active={stage <= active}
    >
      {stage}
    </div>
    <div
      class="stage-dash"
      class:active={stage <= active}
    >
    </div>
  {/each}
</div>

<style lang="postcss">
  .stage-number-container {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 6px;
  }
  .stage-number {
    color: black;
    background-color: rgba(204, 204, 204, 0.6);
    width: 30px;
    height: 30px;
    border-radius: 4px;
    display: flex;
    justify-content: center;
    align-items: center;

    font-size: 16px;
  }
  .stage-dash {
    width: 30px;
    height: 1px;
    border-radius: 1px;
    background-color: rgba(204, 204, 204, 0.6);
  }

  .stage-dash:last-child {
    display: none;
  }

  .active {
    @apply bg-white;
  }
</style>
