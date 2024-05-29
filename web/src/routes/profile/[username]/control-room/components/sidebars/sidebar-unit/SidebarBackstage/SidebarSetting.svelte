<script lang="ts">
	import Button from '$lib/components/button/Button.svelte';
	import Switch from '$lib/components/form/Switch.svelte';
	import Heading3 from '$lib/components/form/Heading3.svelte';
	import TeamSetting from './TeamSetting.svelte';

	import { GoBack } from '$lib/components/icon';
	import { getControlRoomCtx } from '$lib/context/control-room';
	import { getContext } from 'svelte';
	import { getSupabase } from '$lib/supabase';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	import type { Database, Tables } from '$lib/schema/database.types';

	interface Props {
		type: 'backstage' | 'stage';
		onclose?: () => void;
	}

	type audience_service = Database['public']['Enums']['audience_service'];
	type audience_type = Database['public']['Enums']['audience_type'];

	const supabase = getSupabase(getContext);
	const live_debate = getControlRoomCtx('ctx_table$live_debate');
	const teams = getControlRoomCtx('ctx_table$live_debate_team');
	
	const { onclose, type }: Props = $props();

	let settingForm = $state({
		maxParticipant: $live_debate?.max_participants,
		maxStage: $live_debate?.max_stage,
		autoMoveToStage: !!$live_debate?.auto_move_to_stage,
		backstageAudienceType: $live_debate?.backstage_audience?.[0] as string,
		chatAudienceType: $live_debate?.chat_audience?.[0] as string,
		viewerAudienceType: $live_debate?.viewer_audience?.[0] as string
	});

	let showSubmit: boolean = $derived(isChanged());

	live_debate.subscribe(() => {
		getLatestSetting();
	});

	function getLatestSetting() {
		syncSettingForm();
	}

	function isChanged() {
		return (
			settingForm.maxParticipant !== $live_debate?.max_participants ||
			settingForm.maxStage !== $live_debate?.max_stage ||
			settingForm.autoMoveToStage !== !!$live_debate?.auto_move_to_stage ||
			settingForm.backstageAudienceType !== $live_debate?.backstage_audience?.[0] ||
			settingForm.chatAudienceType !== $live_debate?.chat_audience?.[0] ||
			settingForm.viewerAudienceType !== $live_debate?.viewer_audience?.[0]
		);
	}

	async function handleSubmit() {
		if (!$live_debate || !settingForm) return;

		// Check if the max stage is less than max participant
		const toUpdate: Partial<Tables<'live_debate'>> = {};

		if (Number(settingForm.maxParticipant) <= Number(settingForm.maxStage)) {
			newToast({
				type: 'error',
				message: "Max participants can't be less than max. stage member"
			});
			return;
		}

		if (
			typeof settingForm.maxParticipant === 'number' &&
			settingForm.maxParticipant !== $live_debate.max_participants
		) {
			toUpdate.max_participants = settingForm.maxParticipant;
		}

		if (settingForm.maxStage !== $live_debate.max_stage) {
			toUpdate.max_stage = settingForm.maxStage;
		}

		// Check if maxStage is less than maxParticipant

		if (settingForm.autoMoveToStage !== $live_debate.auto_move_to_stage) {
			toUpdate.auto_move_to_stage = settingForm.autoMoveToStage;
		}

		if (
			settingForm.backstageAudienceType &&
			settingForm.backstageAudienceType !== $live_debate.backstage_audience?.[0]
		) {
			if (settingForm.backstageAudienceType.startsWith('team-only-')) {
				const { error: teamError } = await setTeamOnly(
					'backstage',
					settingForm.backstageAudienceType
				);
				if (teamError) return;
				toUpdate.backstage_audience = ['team-only'];
			} else {
				toUpdate.backstage_audience = [settingForm.backstageAudienceType as audience_type];
			}
		}

		if (
			settingForm.chatAudienceType &&
			settingForm.chatAudienceType !== $live_debate.chat_audience?.[0]
		) {
			if (settingForm.chatAudienceType.startsWith('team-only-')) {
				const { error: teamError } = await setTeamOnly('chat', settingForm.chatAudienceType);
				if (teamError) return;
				toUpdate.chat_audience = ['team-only'];
			} else {
				toUpdate.chat_audience = [settingForm.chatAudienceType as audience_type];
			}
		}

		if (
			settingForm.viewerAudienceType &&
			settingForm.viewerAudienceType !== $live_debate.viewer_audience?.[0]
		) {
			if (settingForm.viewerAudienceType.startsWith('team-only-')) {
				const { error: teamError } = await setTeamOnly('viewer', settingForm.viewerAudienceType);
				if (teamError) return;
				toUpdate.viewer_audience = ['team-only'];
			} else {
				toUpdate.viewer_audience = [settingForm.viewerAudienceType as audience_type];
			}
		}

		const { data, error } = await supabase
			.from('live_debate')
			.update(toUpdate)
			.eq('id', $live_debate.id)
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

		if (data?.[0]) $live_debate = data[0];
	}
	type TeamService = Record<audience_service, string | undefined>;

	let cacheLiveDebateTeamOnlyServiceMap: TeamService = {
		backstage: undefined,
		chat: undefined,
		viewer: undefined
	};

	async function getLiveDebateTeamOnlyServiceMap(liveDebateId: string) {
		const { data, error } = await supabase
			.from('live_debate_audience_team_only')
			.select()
			.eq('live_debate', liveDebateId);

		data?.forEach((item) => {
			cacheLiveDebateTeamOnlyServiceMap[item.service] = item.team;
		});
		return cacheLiveDebateTeamOnlyServiceMap;
	}

	async function setTeamOnly(
		service: audience_service,
		value: string
	): Promise<{ data: any; error: any }> {
		if (!$live_debate) return { data: null, error: 'Invalid live debate id' };
		if (!value.startsWith('team-only-')) {
			console.error("Value must be in this format:'team-only-{teamId}'");
		}
		const { data, error } = await supabase
			.from('live_debate_audience_team_only')
			.upsert({
				live_debate: $live_debate.id,
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
			maxParticipant: $live_debate?.max_participants,
			maxStage: $live_debate?.max_stage,
			autoMoveToStage: !!$live_debate?.auto_move_to_stage,
			backstageAudienceType: $live_debate?.backstage_audience?.[0] as string,
			chatAudienceType: $live_debate?.chat_audience?.[0] as string,
			viewerAudienceType: $live_debate?.viewer_audience?.[0] as string
		};

		let teamServiceMap: TeamService;
		if (
			$live_debate?.backstage_audience?.[0] === 'team-only' ||
			$live_debate?.chat_audience?.[0] === 'team-only' ||
			$live_debate?.viewer_audience?.[0] === 'team-only'
		) {
			teamServiceMap = await getLiveDebateTeamOnlyServiceMap($live_debate.id);

			if ($live_debate?.backstage_audience?.[0] === 'team-only') {
				const teamId = teamServiceMap?.backstage;
				settingForm.backstageAudienceType = `team-only-${teamId}`;
			}
			if ($live_debate?.chat_audience?.[0] === 'team-only') {
				const teamId = teamServiceMap?.chat;
				settingForm.chatAudienceType = `team-only-${teamId}`;
			}
			if ($live_debate?.viewer_audience?.[0] === 'team-only') {
				const teamId = teamServiceMap?.viewer;
				settingForm.viewerAudienceType = `team-only-${teamId}`;
			}
		}
	}
</script>

<div class="px-4">
	<div class="flex justify-between mb-8">
		<Button
			label="Back to {type === 'stage' ? 'Stage' : 'Backstage'}"
			fillType="hover"
			onclick={onclose}
		>
			<GoBack slot="icon-left" />
		</Button>
		{#if showSubmit}
			<Button color="secondary" label="Save" width={120} onclick={handleSubmit} />
		{:else}
			<div></div>
		{/if}
	</div>

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

	<div class="mt-12">
		<TeamSetting />
	</div>

	<!-- Show list of teams below and the user can change the color -->
	<!-- Show filter chat AUTO MODERATOR? -->
	<!-- Call for backroom? -->
</div>

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
