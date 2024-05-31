<script lang="ts">
	import { getSupabase } from '$lib/supabase';
	import { setContext } from 'svelte';
	import { writable, type Writable } from 'svelte/store';
	import {
		CTX_KEY_NEW_DEBATE,
		CTX_KEY_HOST_PARTICIPANT,
		CTX_KEY_TITLE,
		type CTX_KEY_NEW_DEBATE_TYPE,
		type CTX_KEY_HOST_PARTICIPANT_TYPE,
		type CTX_KEY_TITLE_TYPE
	} from './new-debate.constant';
	import { browser } from '$app/environment';
	import { onMount, getContext } from 'svelte';
	import Loader from '$lib/components/icon/Loader.svelte';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { goto } from '$app/navigation';

	let isLoading: boolean = true;

	let newDebate: CTX_KEY_NEW_DEBATE_TYPE = writable({});
	let hostParticipant: CTX_KEY_HOST_PARTICIPANT_TYPE = writable({});
	let title: CTX_KEY_TITLE_TYPE = writable('New debate');

	const supabase = getSupabase(getContext);

	setContext(CTX_KEY_NEW_DEBATE, newDebate);
	setContext(CTX_KEY_HOST_PARTICIPANT, hostParticipant);
	setContext(CTX_KEY_TITLE, title);

	// set session of the live debate and host info and get the latest info on page reload

	newDebate.subscribe(($newDebate) => {
		if ($newDebate && $newDebate.id && browser)
			sessionStorage.setItem('store$newDebateId', $newDebate.id);
	});

	onMount(async () => {
		if(!$authUserData?.id) {
			goto("/?error=FAILED_LIVE_DEBATE_NO_USER")
			return;
		}
		const { data, error } = await supabase.from('live_debate')
			.select('*')
			.eq('ended', false)
			.eq("host", $authUserData?.id!);

		if (error) {
			console.error(error);
			goto("/?error=FAILED_LIVE_DEBATE_DB_ERROR")
			return;
		}

		isLoading = false;
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
