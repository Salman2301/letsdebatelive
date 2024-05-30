<script lang="ts">
	import CloseX from "../icon/CloseX.svelte";
	import { closeSidePanel, sidePanelHeader, sidePanelKey } from "./side-panel.store";
	import { fly } from "svelte/transition";
	import { quintOut } from "svelte/easing";


  function handleCLickContainer(event: MouseEvent) {
    event.stopPropagation()
  }

  function handleCheckEsc(event: KeyboardEvent) {
    if( event.code === "Escape") closeSidePanel();
  }

</script>

<!-- svelte-ignore a11y_click_events_have_key_events -->
<!-- svelte-ignore a11y_no_static_element_interactions -->
{#if $sidePanelKey !== "none" }
  <div class="overlay" onclick={closeSidePanel}>
    <div class="side-panel" onclick={handleCLickContainer}  transition:fly={{ duration: 350, x: 200,  easing: quintOut  }} >
      <div class="header">
        <span>{$sidePanelHeader}</span>
        <button onclick={closeSidePanel}>
          <CloseX />
        </button>
      </div>
      <!-- svelte-ignore slot_element_deprecated -->
      <div class="side-panel-content">
        <slot></slot>
      </div>
    </div>
  </div>
{/if}

<svelte:window onkeyup={handleCheckEsc} />

<style lang="postcss">
  .overlay {
		position: fixed;
		width: 100vw;
		height: 100vh;
		background-color: rgba(0, 0, 0, 0.25);
		z-index: 999;

		display: flex;
		justify-content: center;
		align-items: center;
  }
  .side-panel {
    @apply bg-black;
    width: 50%;
    max-width: 480px;
    height: 100%;
    @apply fixed;
    bottom: 0;
    right: 0;
    z-index: 2;
    @apply border-l border-l-light-gray;
    z-index: 1000;
  }


  .header {
    @apply flex items-center justify-between;
    @apply px-2 py-2;

    font-size: 28px;
    font-weight: normal;
  }
</style>