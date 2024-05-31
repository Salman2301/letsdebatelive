<script lang="ts">
	import Loader from '$lib/components/icon/Loader.svelte';

	import { getSupabase } from '$lib/supabase';
	import { writable } from 'svelte/store';
	import { browser } from '$app/environment';
	import { onMount, getContext } from 'svelte';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { goto } from '$app/navigation';
	import { PageCtx } from '$src/lib/context';

	let isLoading: boolean = true;

	const supabase = getSupabase(getContext);
	const pageCtx = new PageCtx("new-debate");

	pageCtx.set({
		liveDebate: writable(null),
		hostParticipant: writable(null),
		title: writable("")
	});

	// set session of the live debate and host info and get the latest info on page reload

	pageCtx.get("liveDebate").subscribe(($liveDebate) => {
		if ($liveDebate && $liveDebate.id && browser)
			sessionStorage.setItem('store$newDebateId', $liveDebate.id);
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
