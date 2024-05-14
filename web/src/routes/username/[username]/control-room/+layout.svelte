<script lang="ts">
	import Sidebar from "./components/Sidebar.svelte";

 
</script>

<div class="layout-container">
  <Sidebar></Sidebar>
  <div class="control-room">  
    <slot></slot>
  </div>
</div>

<style lang="postcss">

  .layout-container {
    @apply flex;
    height: calc(100vh - 76px);
    width: 100vw;
    overflow: hidden;
  }

  .control-room {
    @apply bg-black;
    width: 100%;
  }

</style>