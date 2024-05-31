<script lang="ts">
	import Sidebar from './components/Sidebar.svelte';
	import { getContext, onDestroy, setContext } from 'svelte';
	import { onMount } from 'svelte';
	import { getSupabase } from '$lib/supabase';
	import { derived, writable, type Readable, type Writable } from 'svelte/store';
	import type { PageData } from './$types';

	import type { Tables } from '$lib/schema/database.types';
	import type { SubscriptionCB } from '$lib/schema/subscription.types';
	import { PageCtx } from '$src/lib/context';

	const supabase = getSupabase(getContext);
	const pageCtx = new PageCtx("control-room");

	interface Props {
		data: PageData;
	}
	let { data }: Props = $props();

	const liveDebate: Writable<Tables<'live_debate'> | null> = writable(data.live_debate);

	const teams: Writable<Tables<'live_debate_team'>[]> = writable(data.teamData);

	const participants: Writable<Tables<'live_debate_participants'>[]> = writable(
		data.participantsData
	);
	const participantsOnStage: Readable<Tables<'live_debate_participants'>[]> = derived(
		participants,
		($participants) => $participants.filter((e) => e.location === 'stage')
	);
	const participantsBackStage: Readable<Tables<'live_debate_participants'>[]> = derived(
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
		ctx_table$live_debate: liveDebate,
		ctx_table$live_debate_participants: participants,
		ctx_table$live_debate_participants_stage: participantsOnStage,
		ctx_table$live_debate_participants_backstage: participantsBackStage,
		ctx_table$live_debate_team: teams,
		ctx_map$teamColor: teamMapColor
	});

	const liveDebateChannel = supabase.channel('custom-all-channel');

	onMount(async () => {
		const { data: liveDebateData, error: liveDebateError } = await supabase
			.from('live_debate')
			.select()
			.eq('id', '4167bf11-dc10-46d3-9d32-e5b7ad9d3e67')
			.single();

		liveDebate.set(liveDebateData);
		const liveDebateIdStr = liveDebateData?.id;

		if (!liveDebateIdStr) throw new Error('Did you seed the database?');

		const [{ data: participantsData }, { data: teamsData }] = await Promise.all([
			supabase.from('live_debate_participants').select().eq('live_debate', liveDebateIdStr),
			supabase.from('live_debate_team').select().eq('live_debate', liveDebateIdStr)
		]);

		if (!participantsData || !participantsData[0]) throw new Error('No new participants');
		if (!teamsData || !teamsData[0]) throw new Error('No team');

		participants.set(participantsData);
		teams.set(teamsData);

		liveDebateChannel
			.on(
				'postgres_changes',
				{
					event: '*',
					schema: 'public',
					table: 'live_debate_participants',
					filter: `live_debate=eq.${liveDebateIdStr}`
				},
				(payload) => {
					syncLiveDebateParticipants(payload as any);
				}
			)
			.subscribe();

		function syncLiveDebateParticipants({
			new: data,
			old,
			eventType
		}: SubscriptionCB<'live_debate_participants'>) {
			switch (eventType) {
				case 'UPDATE': {
					$participants = $participants.map((item) =>
						item.participant_id === data.participant_id ? data : item
					);
					return;
				}
				case 'INSERT': {
					$participants = [...$participants, data];
					return;
				}
				case 'DELETE': {
					$participants = $participants.filter(
						(item) => item.participant_id !== old.participant_id
					);
					return;
				}
			}
		}

		// On Destroy unsubs to all the subscriptions
		// get the live debate setting list
	});

	onDestroy(() => {
		liveDebateChannel.unsubscribe();
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
