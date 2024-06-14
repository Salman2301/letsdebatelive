<script lang="ts">
	import Sidebar from './components/Sidebar.svelte';
	import { onDestroy } from 'svelte';
	import { onMount } from 'svelte';
	import { getSupabase } from '$lib/supabase';
	import { PageCtx } from '$src/lib/context';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { derived, writable, type Readable, type Writable } from 'svelte/store';

	import type { PageData } from './$types';
	import type { Tables } from '$lib/schema/database.types';
	import { participantsWithUserDataSelect, type ParticipantsWithUserData } from '$src/lib/types';

	const supabase = getSupabase();
	const pageCtx = new PageCtx('control-room');

	interface Props {
		data: PageData;
	}
	let { data }: Props = $props();

	const liveFeed: Writable<Tables<'live_feed'> | null> = writable(data.live_feed);

	const teams: Writable<Tables<'live_feed_team'>[]> = writable(data.teamData);

	const participants: Writable<ParticipantsWithUserData[]> = writable(data.participantsData);
	const participantsOnStage: Readable<ParticipantsWithUserData[]> = derived(
		participants,
		($participants) => $participants.filter((e) => e.location === 'stage')
	);
	const participantsBackStage: Readable<ParticipantsWithUserData[]> = derived(
		participants,
		($participants) => $participants.filter((e) => e.location === 'backstage')
	);

	const teamMapColor: Readable<Record<string, string>> = derived(teams, ($teams) => {
		return $teams.reduce((obj: Record<string, string>, team) => {
			obj[team.id] = team.color;
			return obj;
		}, {});
	});

	pageCtx.set({
		ctx_table$live_feed: liveFeed,
		ctx_table$live_feed_participants: participants,
		ctx_table$live_feed_participants_stage: participantsOnStage,
		ctx_table$live_feed_participants_backstage: participantsBackStage,
		ctx_table$live_feed_team: teams,
		ctx_map$teamColor: teamMapColor
	});

	const liveFeedChannel = supabase.channel('custom-all-channel');

	onMount(async () => {
		if (!$authUserData?.id) {
			$authUserData = data.userData;
			// throw new Error('You must be logged in to see the control room');
		}

		liveFeed.set(data.live_feed);
		const liveFeedIdStr = data.live_feed?.id;

		if (!liveFeedIdStr) throw new Error('Did you seed the database?');

		const [
			{ data: participantsData, error: participantsError },
			{ data: teamsData, error: teamsError }
		] = await Promise.all([
			supabase
				.from('live_feed_participants')
				.select(participantsWithUserDataSelect)
				.eq('live_feed', liveFeedIdStr)
				.returns<ParticipantsWithUserData[]>(),
			supabase.from('live_feed_team').select().eq('live_feed', liveFeedIdStr)
		]);

		if (!participantsData || !participantsData[0] || participantsError)
			throw new Error('No new participants');
		if (teamsError) throw new Error('No team');

		participants.set(participantsData);
		teams.set(teamsData || []);

		liveFeedChannel
			.on(
				'postgres_changes',
				{
					event: '*',
					schema: 'public',
					table: 'live_feed_participants',
					filter: `live_feed=eq.${liveFeedIdStr}`
				},
				(payload) => {
					syncLiveFeedParticipants();
				}
			)
			.subscribe();

		async function syncLiveFeedParticipants() {
			const { data: participantsWithUserData, error } = await supabase
				.from('live_feed_participants')
				.select(participantsWithUserDataSelect)
				.eq('live_feed', liveFeedIdStr)
				.order('created_at', { ascending: true })
				.returns<ParticipantsWithUserData[]>();

			$participants = participantsWithUserData || [];
		}

		// On Destroy unsubs to all the subscriptions
		// get the live feed setting list
	});

	onDestroy(() => {
		liveFeedChannel.unsubscribe();
	});
</script>

<div class="layout-container">
	<Sidebar></Sidebar>
	<!-- svelte-ignore slot_element_deprecated -->
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
