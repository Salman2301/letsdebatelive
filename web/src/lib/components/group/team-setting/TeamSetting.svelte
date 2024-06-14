<script lang="ts">
	import slugify from 'slugify';
	import TeamSettingItem from './TeamSettingItem.svelte';
	import Heading3 from '$lib/components/form/Heading3.svelte';

	import { getSupabase } from '$lib/supabase';
	import { CheckMark } from '$lib/components/icon';
	import { onMount, tick } from 'svelte';
	import { newToast } from '$lib/components/toast/Toast.svelte';

	import type { Writable } from 'svelte/store';
	import type { Tables } from '$src/lib/schema/database.types';

	const supabase = getSupabase();

	let inputRef: HTMLInputElement;

	interface Props {
		live_feed: Writable<Tables<'live_feed'> | null>;
		teams: Writable<Tables<'live_feed_team'>[]>;
	}

	let { live_feed, teams }: Props = $props();

	let newTeamValue = $state('');
	let showSubmitBtn = $derived(!!newTeamValue);

	async function onKeydownChange(event: KeyboardEvent) {
		await tick();
		if (event.key === 'Escape') {
			newTeamValue = '';
			(event.target as HTMLInputElement).blur?.();
			return;
		}
		if (event.key === 'Enter') {
			newTeam();
			(event.target as HTMLInputElement).blur?.();
			return;
		}
	}

	onMount(refreshTeamData);

	async function newTeam() {
		if (!$live_feed?.id) return;

		const { data, error } = await supabase
			.from('live_feed_team')
			.insert({
				color: getAvailableColor(),
				live_feed: $live_feed?.id,
				slug: slugify(newTeamValue),
				title: newTeamValue,
				is_default: false
			})
			.select();

		if (error) {
			console.error(error);
			newToast({
				type: 'error',
				message: 'Failed to add team'
			});
		}
		newTeamValue = '';
		refreshTeamData();
		inputRef?.focus?.();
	}

	function getAvailableColor(): string {
		const availableColors = ['#32DE8A', '#EF7674', '#F2AF29', '#31DDC1', '#EFA076', '#F2F226'];

		const currentColorsUsed = $teams.map((item) => item.color);

		for (let color of availableColors) {
			const isUsed = currentColorsUsed.includes(color);
			if (!isUsed) return color;
		}

		return '#000000';
	}

	async function refreshTeamData() {
		if (!$live_feed?.id) return;

		const { data: newTeamsData } = await supabase
			.from('live_feed_team')
			.select()
			.eq('live_feed', $live_feed.id)
			.order('title');

		if (newTeamsData) teams.set(newTeamsData);
	}
</script>

<Heading3 content="Team" textAlign="center" />
<p class="team-desc">Split your audience into different teams</p>
<div class="teams-container" class:empty={!$teams.length}>
	{#each $teams as team (team.id)}
		<TeamSettingItem {team} {live_feed} onsubmit={refreshTeamData} />
	{/each}
</div>
<div class="new-team-container">
	<input
		class="in-new-team"
		placeholder="+ Create new team"
		data-testid="new-team-input"
		bind:value={newTeamValue}
		onkeydown={onKeydownChange}
		bind:this={inputRef}
	/>

	<button
		class="btn-new-team"
		data-testid="team-submit-btn"
		onclick={newTeam}
		class:hidden={!showSubmitBtn}
	>
		<CheckMark />
	</button>
</div>

<style lang="postcss">
	.team-desc {
		@apply text-xs font-bold mb-2;
		color: #ccc;
	}
	.teams-container {
		@apply border border-light-gray;
		@apply rounded;
	}
	.teams-container.empty {
		@apply border-transparent;
	}
	.new-team-container {
		@apply relative;
	}

	.in-new-team {
		height: 40px;
		@apply w-full;
		@apply px-2 mt-2;
		@apply outline-none border-0 bg-transparent;
		@apply border-b border-b-light-gray focus:border-white hover:border-white;
		@apply mb-12;
	}

	.btn-new-team {
		@apply absolute;
		right: 10px;
		top: 20px;
	}

	.btn-new-team.hidden {
		visibility: hidden;
	}
</style>
