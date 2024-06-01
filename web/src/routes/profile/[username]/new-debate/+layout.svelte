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
		teams: writable([]),
		inviteCohost: writable([])
	});

	// set session of the live debate and host info and get the latest info on page reload

	const liveDebate = pageCtx.get('liveDebate');
	const hostParticipant = pageCtx.get('hostParticipant');
	
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
			
			const [
				{ data: liveDebateData, error },
				{ data: hostParticipantData, error: hostParticipantError }
			] = await Promise.all([
					supabase
					.from('live_debate')
					.select()
					.eq('id', storedLiveDebateId)
					.single(),
					supabase
						.from('live_debate_participants')
						.select()
						.eq('live_debate', storedLiveDebateId)
						.eq('role', "host")
						.single()
			]);

			if ( error || !liveDebateData || !hostParticipantData || hostParticipantError  ) {
				sessionStorage.removeItem('store$liveDebateId');
				const res = await createLiveDebate();
				$liveDebate = res.liveDebate;
				$hostParticipant = res.hostParticipant;
				// return newToast({
				// 	type: 'error',
				// 	message: 'Failed to fetch the live debate, try again'
				// });
			} else {
				console.info("Fetched from session storage");
				$liveDebate = liveDebateData;
				$hostParticipant = hostParticipantData;
			}

		} else {
			const res = await createLiveDebate();
			$liveDebate = res.liveDebate;
			$hostParticipant = res.hostParticipant;
		}

		if ($liveDebate === null) {
			goto('/error=FAILED_TO_CREATE_OR_FETCH_LIVE_DEBATE');
		}

		isLoading = false;
	});

	type ReturnCreateLiveDebate = {
		liveDebate: Tables<'live_debate'> | null;
		hostParticipant: Tables<'live_debate_participants'> | null;
	}
	async function createLiveDebate(): Promise<ReturnCreateLiveDebate> {
		if (!$authUserData?.id) throw new Error('User not logged in');

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
			return { liveDebate: null, hostParticipant: null };
		}


		const { data: hostData, error: hostDataError} = await supabase
			.from('live_debate_participants')
			.insert({
				participant_id: $authUserData.id!,
				role: 'host',
				live_debate: newLiveDebate[0].id,
				display_name: $authUserData.displayName || "",
				is_host: true,
				location: "stage",
			})
			.select();

		if (!hostData?.[0]?.participant_id) {
			console.error(newLiveDebateError);
			newToast({
				type: 'error',
				message: 'Failed to craete a new live debate'
			});
			return { liveDebate: null, hostParticipant: null };
		}
		
		if (!newLiveDebate || newLiveDebateError || !hostData || hostDataError) {
			newToast({
				type: 'error',
				message: 'Failed to create a new live debate'
			});

			return { liveDebate: null, hostParticipant: null };

		}

		return { liveDebate: newLiveDebate[0], hostParticipant: hostData[0] };
	}
</script>

{#if isLoading}
	<div class="w-full flex justify-center pt-10">
		<Loader />
	</div>
{:else}
	<slot></slot>
{/if}
