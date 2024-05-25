<script lang="ts">
	import { getContext } from "svelte";  
	import { currentSidebar } from "$lib/stores/sidebar.store";

	import type { Tables } from "$lib/schema/database.types";
	import type { Writable } from "svelte/store";

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
      <button onclick={()=>$currentSidebar="backstage"}>Stage is empty!</button>
    </p>
  {/if}
{:else}
  {#if type === "backstage"}
    <p>No user(s) in backstage</p>
  {:else}
    <p>
      <button onclick={()=>$currentSidebar="backstage"}>Stage is empty!</button>
    </p>
  {/if}
{/if}

<style lang="postcss">
  p {
    @apply w-full flex justify-center;
  }
  p button {
    @apply text-center ;
  }
  button:hover {
    @apply text-white;
  }
</style>

