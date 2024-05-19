<script lang="ts">
	import Sidebar from "./components/Sidebar.svelte";
  import { setContext } from "svelte";


  setContext("HOST_ID", "123-456-789");

 
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
  }

  .control-room {
    @apply bg-black;
    width: 100%;
  }

</style>