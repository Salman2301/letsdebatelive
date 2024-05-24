<script lang="ts">
	import { getContext } from "svelte";
	import { currentSidebar } from "../../../Sidebar.svelte";
  
	import type { Tables } from "$lib/schema/database.types";
	import type { Readable, Writable } from "svelte/store";

  interface Props {
    type: "backstage" | "stage";
  }

  let { type }: Props = $props();

  let participants: Writable<Tables<'live_debate_participants'>[]> = getContext(
		'ctx_table$participants'
	);

</script>

{#if $participants && $participants.length > 0 }
  {#if type === "backstage"}
    <p>No user(s) in backstage</p>
  {:else}
    <p>
      <button onclick={()=>$currentSidebar="backstageSetting"}>Add user from backstage.</button>
    </p>
  {/if}
{:else}
  {#if type === "backstage"}
    <p>No user(s) in backstage</p>
  {:else}
    <p>
      <button onclick={()=>$currentSidebar="backstageSetting"}>Add user from backstage.</button>
    </p>
  {/if}
{/if}

<style lang="postcss">
  p {
    @apply w-full flex justify-center;
  }
  p button {
    @apply border-b border-white;
    @apply text-center ;
  }
  button:hover {
    @apply text-secondary border-secondary;
  }
</style>

