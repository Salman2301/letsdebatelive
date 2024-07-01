<script lang="ts">
	import DownArrow from "$src/lib/components/icon/DownArrow.svelte";

  
  interface Props {
    title: string;
    desc: string;
    children: any;
  }
  const { title, desc, children }: Props = $props();
  
  let expand: boolean = $state(true);

</script>

<div class="widget-container">
  <button
    class="widget-heading"
    onclick={()=>expand=!expand}
  >
    <div class="title-content">
      {title}
    </div>
    <div class="icon">
      {#if expand}
        <DownArrow />
      {:else}
        <div style="rotate:180deg">
          <DownArrow />
        </div>
      {/if}
    </div>
  </button>
  {#if expand}
    <div class="widget-desc">
      {desc}
    </div>
    <div class="content">
      {@render children?.()}
    </div>
  {/if}
</div>

<style lang="postcss">
  .widget-container {
    border: 1px solid var(--color-light-gray);
    @apply mx-2;
    @apply rounded;
  }

  .widget-heading {
    @apply flex items-center justify-between;
    @apply w-full px-2 py-2;
    font-size: 18px;
  }

  .widget-desc {
    @apply text-white/60 text-xs font-bold;
    @apply px-2 my-1;
  }
  button {
    outline: none;
  }

  .content {
    @apply mx-2;
    @apply mb-2;
  }
</style>