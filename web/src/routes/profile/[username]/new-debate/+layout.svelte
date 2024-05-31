<script lang="ts">
	import Loader from '$lib/components/icon/Loader.svelte';

	import { getSupabase } from '$lib/supabase';
	import { writable } from 'svelte/store';
	import { browser } from '$app/environment';
	import { onMount, getContext } from 'svelte';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { goto } from '$app/navigation';
	import { PageCtx } from '$src/lib/context';
	import { newToast } from '$src/lib/components/toast/Toast.svelte';
	import type { Tables } from '$src/lib/schema/database.types';

	let isLoading: boolean = true;

	const supabase = getSupabase();
	const pageCtx = new PageCtx('new-debate');

	pageCtx.set({
		liveDebate: writable(null),
		hostParticipant: writable(null),
		title: writable(''),
		teams: writable([])
	});

	// set session of the live debate and host info and get the latest info on page reload

	const liveDebate = pageCtx.get('liveDebate');
	pageCtx.get('liveDebate').subscribe(($liveDebate) => {
		if ($liveDebate && $liveDebate.id && browser)
			sessionStorage.setItem('store$liveDebateId', $liveDebate.id);
	});

	onMount(async () => {
		if (!$authUserData?.id) {
			goto('/?error=FAILED_LIVE_DEBATE_NO_USER');
			return;
		}
		const { data, error } = await supabase
			.from('live_debate')
			.select('*')
			.eq('ended', false)
			.eq('host', $authUserData?.id!);

		if (error) {
			console.error(error);
			goto('/?error=FAILED_LIVE_DEBATE_DB_ERROR');
			return;
		}

		const storedLiveDebateId = sessionStorage.getItem('store$liveDebateId');

		if (typeof storedLiveDebateId === 'string' && storedLiveDebateId.includes('-')) {
			const { data, error } = await supabase
				.from('live_debate')
				.select()
				.eq('id', storedLiveDebateId)
				.single();
			$liveDebate = data;
			if (error) {
				sessionStorage.removeItem('store$liveDebateId');
				$liveDebate = await createLiveDebate();
				return newToast({
					type: 'error',
					message: 'Failed to fetch the live debate, try again'
				});
			}
		} else {
			$liveDebate = await createLiveDebate();
		}

		if ($liveDebate === null) {
			goto('/error=FAILED_TO_CREATE_OR_FETCH_LIVE_DEBATE');
		}

		isLoading = false;
	});

	async function createLiveDebate(): Promise<Tables<'live_debate'> | null> {
		if (!$authUserData?.id) return null;

		const { data: newLiveDebate, error: newLiveDebateError } = await supabase
			.from('live_debate')
			.insert({
				host: $authUserData.id
			})
			.select();
		if (!newLiveDebate?.[0]?.id) {
			console.error(newLiveDebateError);
			newToast({
				type: 'error',
				message: 'Failed to craete a new live debate'
			});
			return null;
		}
		const { data: liveDebateRole, error: liveDebateError } = await supabase
			.from('live_debate_roles')
			.insert({
				role: 'host',
				live_debate: newLiveDebate[0].id,
				user_id: $authUserData.id
			})
			.select();

		if (!newLiveDebate || newLiveDebateError) {
			newToast({
				type: 'error',
				message: 'Failed to create a new live debate'
			});

			return null;
		}

		return newLiveDebate[0];
	}
</script>

{#if isLoading}
	<div class="w-full flex justify-center pt-10">
		<Loader />
	</div>
{:else}
	<slot></slot>
{/if}
