<script lang="ts">
	import Sidebar from "./components/Sidebar.svelte";
	import { setContext } from "svelte";
  import { onMount } from "svelte";
	import { writable, type Writable } from "svelte/store";
  
  import type { Tables } from "$lib/schema/database.types";
  
  const liveDebateId: Writable<string> = writable();
  const participants: Writable<Tables<"live_debate_participants">[]> = writable([]);
  setContext("HOST_ID", "123-456-789");

  onMount(()=>{
    liveDebateId.set("55384d86-d9ca-4b6e-a12d-4c32e966e6b9"); // test seed live debate
    
    // Setup all the necessary stores
    // Sync tables with the host ID  using supabase
    // On Destroy unsubs to all the subscriptions
    postgresql://postgres:postgres@127.0.0.1:54322/postgres
    // get the live debate host.
    // that is not ended
    // get the live debate id
    // get the participant list
    // get the live debate setting list
    // sync that list to participant store


  });
 
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
    min-height: 600px;
  }

</style>