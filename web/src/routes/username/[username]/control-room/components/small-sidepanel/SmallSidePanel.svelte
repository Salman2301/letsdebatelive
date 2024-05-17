<script lang="ts">
  import { panelOptions } from "./panelOptions";

  let currentSidebar = "live-setting";
</script>

<div class="panel-container">
  <div class="panel-header">
    <div class="header">
      <select bind:value={currentSidebar}>
        {#each panelOptions as item}
          <option value="{item.value}">{item.label}</option>
        {/each}
      </select>
    </div>
    <div class="panel-body">
      # Container
    </div>
  </div>
</div>

<style lang="postcss">
  select {
    @apply bg-black;
    @apply w-full;
    padding: 4px 0px;
  }
  .header {
    @apply border-b border-light-gray;
    padding: 0px 10px;
  }
  .panel-body {
    padding: 10px;
  }
</style>