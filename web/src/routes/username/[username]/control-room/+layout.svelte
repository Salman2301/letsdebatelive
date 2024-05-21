<script lang="ts">
	import Sidebar from "./components/Sidebar.svelte";
	import { setContext } from "svelte";
  import { onMount } from "svelte";
	import { writable, type Writable } from "svelte/store";
  
  import type { Tables } from "$lib/schema/database.types";
	import supabase from "$lib/supabase";
  
  const liveDebateId: Writable<string> = writable();
  const participants: Writable<Tables<"live_debate_participants">[]> = writable([]);
  setContext("HOST_ID", "123-456-789");

  onMount(async ()=>{

    // const { data: liveDebate } = await supabase.from("live_debate").select();
    // const liveDebateIdStr = liveDebate?.[0]?.id;

    // if(!liveDebateIdStr) throw new Error("Did you seed the database?");


    // const { data, error } = await supabase.from("live_debate_participants").select();

    // if(!data || !data[0] ) throw new Error("No new participants")
    // // get live debate based on the username
    // // set the liveDebateId and liveDebateParticipants
    // liveDebateId.set(liveDebateIdStr); // test seed live debate
    // participants.set(data)
    
    // Setup all the necessary stores
    // Sync tables with the host ID  using supabase
    // On Destroy unsubs to all the subscriptions
    // postgresql://postgres:postgres@127.0.0.1:54322/postgres
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