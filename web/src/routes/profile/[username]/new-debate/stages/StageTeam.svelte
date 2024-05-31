<script lang="ts">
	import TeamCard from '../components/TeamCard.svelte';
	import Input from "$lib/components/form/input/Input.svelte";

	import { browser } from '$app/environment';
	import type { Tables } from '$lib/schema/database.types';

	let teamInfos: Partial<Tables<'live_debate_team'>>[] = [];

	if (browser) {
		if (teamInfos.length === 0) createNeutralTeam();
	}

	async function createNeutralTeam() {
		teamInfos = [
			{
				color: '#ccc',
				title: 'Neutral',
				// user_id: '123'
			}
		];
	}

	export function beforeOnNext() {
		// Add all stage to teams and participants table
	}
</script>

<div class="in-title">
	<Input
		rounded="sm"
		title="Debate title"
		width="480px"
		placeholder="Enter title for your live debate"
	/>
</div>

<div class="flex justify-center gap-4">
	{#each teamInfos as team}
		<TeamCard {team} />
	{/each}
</div>

<style lang="postcss">

	.in-title {
		@apply flex items-center justify-center;
		@apply w-full;
		@apply my-4;
	}
</style>
