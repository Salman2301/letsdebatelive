<script lang="ts">
	import type { Tables } from "$lib/schema/database.types";
	import { setContext } from "svelte";
	import { writable, type Writable } from "svelte/store";

  let newDebate: Writable<Partial<Tables<"live_debate">>> | null = writable({});
	
	setContext("NEW_DEBATE", newDebate);
</script>

<slot></slot>

<style lang="postcss">

</style>