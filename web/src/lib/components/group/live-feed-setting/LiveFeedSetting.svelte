<script context="module" lang="ts">
	export type InstanceType = { submit: () => Promise<Tables<'live_feed'>> };
</script>

<script lang="ts">
	import Switch from '$lib/components/form/Switch.svelte';
	import Heading3 from '$lib/components/form/Heading3.svelte';

	import { getContext } from 'svelte';
	import { getSupabase } from '$lib/supabase';
	import { newToast } from '$lib/components/toast/Toast.svelte';

	import type { Database, Tables } from '$lib/schema/database.types';
	import type { Writable } from 'svelte/store';

	interface Props {
		live_feed: Writable<Tables<'live_feed'> | null>;
		teams: Writable<Tables<'live_feed_team'>[]>;
		showSubmit: boolean;
	}

	type audience_service = Database['public']['Enums']['audience_service'];
	type audience_type = Database['public']['Enums']['audience_type'];

	const supabase = getSupabase();

	let { live_feed, teams, showSubmit = $bindable() }: Props = $props();

	let settingForm = $state({
		maxParticipant: $live_feed?.max_participants,
		maxStage: $live_feed?.max_stage,
		autoMoveToStage: !!$live_feed?.auto_move_to_stage,
		backstageAudienceType: $live_feed?.backstage_audience?.[0] as string,
		chatAudienceType: $live_feed?.chat_audience?.[0] as string,
		viewerAudienceType: $live_feed?.viewer_audience?.[0] as string
	});

	$effect(() => {
		showSubmit = isChanged();
	});

	live_feed.subscribe(() => {
		getLatestSetting();
	});

	function getLatestSetting() {
		syncSettingForm();
	}

	function isChanged() {
		return (
			settingForm.maxParticipant !== $live_feed?.max_participants ||
			settingForm.maxStage !== $live_feed?.max_stage ||
			settingForm.autoMoveToStage !== !!$live_feed?.auto_move_to_stage ||
			settingForm.backstageAudienceType !== $live_feed?.backstage_audience?.[0] ||
			settingForm.chatAudienceType !== $live_feed?.chat_audience?.[0] ||
			settingForm.viewerAudienceType !== $live_feed?.viewer_audience?.[0]
		);
	}

	export async function submit(): Promise<Tables<'live_feed'>> {
		if (!$live_feed || !settingForm) return $live_feed!;

		// Check if the max stage is less than max participant
		const toUpdate: Partial<Tables<'live_feed'>> = {};

		if (Number(settingForm.maxParticipant) <= Number(settingForm.maxStage)) {
			newToast({
				type: 'error',
				message: "Max participants can't be less than max. stage member"
			});
			return $live_feed!;
		}

		if (
			typeof settingForm.maxParticipant === 'number' &&
			settingForm.maxParticipant !== $live_feed.max_participants
		) {
			toUpdate.max_participants = settingForm.maxParticipant;
		}

		if (settingForm.maxStage !== $live_feed.max_stage) {
			toUpdate.max_stage = settingForm.maxStage;
		}

		// Check if maxStage is less than maxParticipant

		if (settingForm.autoMoveToStage !== $live_feed.auto_move_to_stage) {
			toUpdate.auto_move_to_stage = settingForm.autoMoveToStage;
		}

		if (
			settingForm.backstageAudienceType &&
			settingForm.backstageAudienceType !== $live_feed.backstage_audience?.[0]
		) {
			if (settingForm.backstageAudienceType.startsWith('team-only-')) {
				const { error: teamError } = await setTeamOnly(
					'backstage',
					settingForm.backstageAudienceType
				);
				if (teamError) return $live_feed!;
				toUpdate.backstage_audience = ['team-only'];
			} else {
				toUpdate.backstage_audience = [settingForm.backstageAudienceType as audience_type];
			}
		}

		if (
			settingForm.chatAudienceType &&
			settingForm.chatAudienceType !== $live_feed.chat_audience?.[0]
		) {
			if (settingForm.chatAudienceType.startsWith('team-only-')) {
				const { error: teamError } = await setTeamOnly('chat', settingForm.chatAudienceType);
				if (teamError) return $live_feed!;
				toUpdate.chat_audience = ['team-only'];
			} else {
				toUpdate.chat_audience = [settingForm.chatAudienceType as audience_type];
			}
		}

		if (
			settingForm.viewerAudienceType &&
			settingForm.viewerAudienceType !== $live_feed.viewer_audience?.[0]
		) {
			if (settingForm.viewerAudienceType.startsWith('team-only-')) {
				const { error: teamError } = await setTeamOnly('viewer', settingForm.viewerAudienceType);
				if (teamError) return $live_feed!;
				toUpdate.viewer_audience = ['team-only'];
			} else {
				toUpdate.viewer_audience = [settingForm.viewerAudienceType as audience_type];
			}
		}

		const { data, error } = await supabase
			.from('live_feed')
			.update(toUpdate)
			.eq('id', $live_feed.id)
			.select();

		if (error) {
			console.error(error);
			newToast({
				type: 'error',
				message: 'Failed to update'
			});
		} else {
			newToast({
				type: 'success',
				message: 'Updated successfully!'
			});
		}

		if (data?.[0]) $live_feed = data[0];
		return $live_feed;
	}
	type TeamService = Record<audience_service, string | undefined>;

	let cacheLiveFeedTeamOnlyServiceMap: TeamService = {
		backstage: undefined,
		chat: undefined,
		viewer: undefined
	};

	async function getLiveFeedTeamOnlyServiceMap(liveFeedId: string) {
		const { data, error } = await supabase
			.from('live_feed_audience_team_only')
			.select()
			.eq('live_feed', liveFeedId);

		data?.forEach((item) => {
			cacheLiveFeedTeamOnlyServiceMap[item.service] = item.team;
		});
		return cacheLiveFeedTeamOnlyServiceMap;
	}

	async function setTeamOnly(
		service: audience_service,
		value: string
	): Promise<{ data: any; error: any }> {
		if (!$live_feed) return { data: null, error: 'Invalid live feed id' };
		if (!value.startsWith('team-only-')) {
			console.error("Value must be in this format:'team-only-{teamId}'");
		}
		const { data, error } = await supabase
			.from('live_feed_audience_team_only')
			.upsert({
				live_feed: $live_feed.id,
				service: service,
				team: value.replace('team-only-', '')
			})
			.select()
			.single();

		if (error) {
			console.error(error);
			newToast({
				type: 'error',
				message: 'Failed to add/update teams'
			});
		}
		return { data, error };
	}

	async function syncSettingForm() {
		settingForm = {
			maxParticipant: $live_feed?.max_participants,
			maxStage: $live_feed?.max_stage,
			autoMoveToStage: !!$live_feed?.auto_move_to_stage,
			backstageAudienceType: $live_feed?.backstage_audience?.[0] as string,
			chatAudienceType: $live_feed?.chat_audience?.[0] as string,
			viewerAudienceType: $live_feed?.viewer_audience?.[0] as string
		};

		let teamServiceMap: TeamService;
		if (
			$live_feed?.backstage_audience?.[0] === 'team-only' ||
			$live_feed?.chat_audience?.[0] === 'team-only' ||
			$live_feed?.viewer_audience?.[0] === 'team-only'
		) {
			teamServiceMap = await getLiveFeedTeamOnlyServiceMap($live_feed.id);

			if ($live_feed?.backstage_audience?.[0] === 'team-only') {
				const teamId = teamServiceMap?.backstage;
				settingForm.backstageAudienceType = `team-only-${teamId}`;
			}
			if ($live_feed?.chat_audience?.[0] === 'team-only') {
				const teamId = teamServiceMap?.chat;
				settingForm.chatAudienceType = `team-only-${teamId}`;
			}
			if ($live_feed?.viewer_audience?.[0] === 'team-only') {
				const teamId = teamServiceMap?.viewer;
				settingForm.viewerAudienceType = `team-only-${teamId}`;
			}
		}
	}
</script>

<div class="setting-item">
	<label class="label" for="in-max-participant"> Max. number of participant </label>
	<input
		class="in-max-number"
		type="number"
		id="in-max-participant"
		bind:value={settingForm.maxParticipant}
		min="1"
		max="100"
	/>
</div>

<div class="setting-item">
	<label class="label" for="in-max-stage"> Max. number of stage member </label>
	<input
		class="in-max-number"
		type="number"
		id="in-max-stage"
		bind:value={settingForm.maxStage}
		min="1"
		max="100"
	/>
</div>

<div class="setting-item">
	<label for="in-auto-stage">Auto move everyone to stage when joined backstage</label>
	<Switch bind:checked={settingForm.autoMoveToStage} />
</div>

<div class="mt-12">
	<Heading3 content="Audience type" textAlign="center" />
</div>

<div class="setting-item">
	<label class="label" for="drop-backstage-audience-type">Backstage open only for</label>
	<select id="drop-backstage-audience-type" bind:value={settingForm.backstageAudienceType}>
		<option value="anonymous">Anyone</option>
		<option value="registered">Logged In</option>
		<option value="follower">Follower</option>
		<option value="supporter">Supporter</option>
		<option value="" disabled>----</option>
		{#each $teams as team}
			<option value="team-only-{team.id}">Team - {team.title}</option>
		{/each}
		<option value="" disabled>----</option>
		<option value="none">Disable</option>
	</select>
</div>

<div class="setting-item">
	<label class="label" for="drop-chat-audience">Chat open only for</label>
	<select id="drop-chat-audience" bind:value={settingForm.chatAudienceType}>
		<option value="anonymous">Anyone</option>
		<option value="registered">Logged In</option>
		<option value="follower">Follower</option>
		<option value="supporter">Supporter</option>
		<option value="" disabled>----</option>
		{#each $teams as team}
			<option value="team-only-{team.id}">Team - {team.title}</option>
		{/each}
		<option value="" disabled>----</option>
		<option value="none">Disable</option>
	</select>
</div>

<div class="setting-item">
	<label class="label" for="drop-view-audience">Stream to viewer</label>
	<select id="drop-view-audience" bind:value={settingForm.viewerAudienceType}>
		<option value="anonymous">Anyone</option>
		<option value="registered">Logged In</option>
		<option value="follower">Follower</option>
		<option value="supporter">Supporter</option>
		<option value="" disabled>----</option>
		{#each $teams as team}
			<option value="team-only-{team.id}">Team - {team.title}</option>
		{/each}
		<option value="" disabled>----</option>
		<option value="none">Disable</option>
	</select>
</div>

<!-- Show list of teams below and the user can change the color -->
<!-- Show filter chat AUTO MODERATOR? -->
<!-- Call for backroom? -->

<style lang="postcss">
	.setting-item {
		@apply w-full flex justify-between items-center;
		@apply my-2;
	}

	.in-max-number {
		@apply py-2;
		width: 60px;
		text-align: center;
		@apply rounded;
		@apply my-2;
	}

	select {
		@apply py-2;
		@apply my-2;
		@apply bg-primary;
		@apply rounded;
	}
</style>
