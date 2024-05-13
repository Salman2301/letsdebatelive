<script lang="ts">
	import { setContext } from "svelte";
	import { writable, type Writable } from "svelte/store";
	import { CTX_KEY_NEW_DEBATE, CTX_KEY_HOST_PARTICIPANT, type CTX_KEY_NEW_DEBATE_TYPE, type CTX_KEY_HOST_PARTICIPANT_TYPE, CTX_KEY_TITLE, type CTX_KEY_TITLE_TYPE } from "./new-debate.constant";
	import { browser } from "$app/environment";
	import supabase from "$lib/supbase";
	import { onMount } from "svelte"
	import Loader from "$lib/components/icon/Loader.svelte";
	 

	let isLoading: boolean = true;

  let newDebate: CTX_KEY_NEW_DEBATE_TYPE= writable({});
  let hostParticipant: CTX_KEY_HOST_PARTICIPANT_TYPE = writable({});
  let title: CTX_KEY_TITLE_TYPE = writable("New debate");
	
	setContext(CTX_KEY_NEW_DEBATE, newDebate);
	setContext(CTX_KEY_HOST_PARTICIPANT, hostParticipant);
	setContext(CTX_KEY_TITLE, title);


	// set session of the live debate and host info and get the latest info on page reload

	newDebate.subscribe($newDebate=>{
		if($newDebate && $newDebate.id && browser) sessionStorage.setItem("store$newDebateId", $newDebate.id);
	});

	
	onMount(async ()=>{
		
		console.log({ isLoading })
		const stored$newDebateId = sessionStorage.getItem("store$newDebateId");

		if(stored$newDebateId && typeof stored$newDebateId === "string") {
			const { data, error } = await supabase.from("live_debate").select("*").eq("id", stored$newDebateId);

			if( error ) {
				isLoading = false;
				return;
			}

			if( data && data.length > 0 ) {
				// Get the host details
				// Team details
				// Update the


				isLoading = false;
			}
		} else {
			isLoading = false;
		}
	});

</script>

{#if isLoading}
	<div class="w-full flex justify-center pt-10">	
		<Loader />
	</div>
{:else}
	<slot></slot>
{/if}
<style lang="postcss">

</style>