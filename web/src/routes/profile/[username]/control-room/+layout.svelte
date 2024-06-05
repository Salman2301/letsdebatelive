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

	const liveDebate: Writable<Tables<'live_debate'> | null> = writable(data.live_debate);

	const teams: Writable<Tables<'live_debate_team'>[]> = writable(data.teamData);

	const participants: Writable<ParticipantsWithUserData[]> = writable(
		data.participantsData
	);
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
		ctx_table$live_debate: liveDebate,
		ctx_table$live_debate_participants: participants,
		ctx_table$live_debate_participants_stage: participantsOnStage,
		ctx_table$live_debate_participants_backstage: participantsBackStage,
		ctx_table$live_debate_team: teams,
		ctx_map$teamColor: teamMapColor
	});

	const liveDebateChannel = supabase.channel('custom-all-channel');

	onMount(async () => {
		if(!$authUserData?.id) {
			$authUserData = data.userData;
			// throw new Error('You must be logged in to see the control room');
		}

		liveDebate.set(data.live_debate);
		const liveDebateIdStr = data.live_debate?.id;

		if (!liveDebateIdStr) throw new Error('Did you seed the database?');

		const [{ data: participantsData, error: participantsError }, { data: teamsData, error: teamsError }] = await Promise.all([
			supabase.from('live_debate_participants').select(participantsWithUserDataSelect).eq('live_debate', liveDebateIdStr).returns<ParticipantsWithUserData[]>(),
			supabase.from('live_debate_team').select().eq('live_debate', liveDebateIdStr)
		]);
		
		if (!participantsData || !participantsData[0] || participantsError) throw new Error('No new participants');
		if (teamsError) throw new Error('No team');

		participants.set(participantsData);
		teams.set(teamsData || []);

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
					syncLiveDebateParticipants();
				}
			)
			.subscribe();

		async function syncLiveDebateParticipants() {
			const {data: participantsWithUserData, error} = await supabase.from('live_debate_participants')
				.select(participantsWithUserDataSelect)
				.eq('live_debate', liveDebateIdStr)
				.order("created_at", { ascending: true })
				.returns<ParticipantsWithUserData[]>();

			$participants = participantsWithUserData || [];
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
