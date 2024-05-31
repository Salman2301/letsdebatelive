<script lang="ts">
	import { CheckMark, CloseX } from '$lib/components/icon';
	import { getSupabase } from '$lib/supabase';
	import { getContext, tick } from 'svelte';
	import { selectAll } from '$lib/action/selectAll';
	import { newToast } from '$lib/components/toast/Toast.svelte';

	import type { Tables } from '$lib/schema/database.types';
	import type { Writable } from 'svelte/store';

	interface Props {
		onsubmit: () => void;
		team: Tables<'live_debate_team'>;
		live_debate: Writable<Tables<'live_debate'> | null>;
	}

	let { team, live_debate, onsubmit }: Props = $props();

	const supabase = getSupabase();

	let showSubmitBtn = $state(false);
	let newTeamValue = $state(team.title);

	async function onKeydownChange(event: KeyboardEvent) {
		await tick();
		if (event.key === 'Escape') {
			showSubmitBtn = false;
			newTeamValue = team.title;
			(event.target as HTMLInputElement).blur?.();
			return;
		}
		if (event.key === 'Enter') {
			updateTeamTitle();
			(event.target as HTMLInputElement).blur?.();
			return;
		}

		showSubmitBtn = newTeamValue !== team.title;
	}

	async function updateTeamTitle() {
		await supabase.from('live_debate_team').update({ title: newTeamValue }).eq('id', team.id);
		onsubmit?.();
		showSubmitBtn = false;
	}

	async function updateDefault() {
		if (!$live_debate) return;

		await supabase
			.from('live_debate_team')
			.update({ is_default: false })
			.eq('live_debate', $live_debate.id);

		await supabase.from('live_debate_team').update({ is_default: true }).eq('id', team.id);

		onsubmit?.();
		showSubmitBtn = false;
	}

	async function remove() {
		if (!$live_debate) return;
		const { data, error } = await supabase.from('live_debate_team').delete().eq('id', team.id);
		if (error) {
			console.error({ error });
			newToast({
				type: 'error',
				message: 'Failed to delete the team'
			});
		}
		onsubmit?.();
	}
</script>

<div class="team-item-container">
	<div class="circle-box">
		<div class="circle-icon" style="background-color:{team.color}"></div>
	</div>
	<div class="team-input-container">
		<input
			class="team-name-input"
			bind:value={newTeamValue}
			onkeydown={onKeydownChange}
			use:selectAll
		/>
		<button class="in-submit" class:hidden={!showSubmitBtn}>
			<CheckMark />
		</button>
		<button class="btn-team-default" class:active={team.is_default} onclick={updateDefault}>
			Default
		</button>
	</div>
	<button class="delete-icon" class:hidden={team.is_default} onclick={remove}>
		<CloseX />
	</button>
</div>

<style lang="postcss">
	.team-item-container {
		@apply flex justify-between items-center;
		@apply border-b border-light-gray;
	}
	.team-item-container:last-child {
		@apply border-none;
	}
	.circle-box {
		min-width: 30px;
		height: 30px;
		@apply flex items-center justify-center;
	}
	.circle-icon {
		width: 18px;
		height: 18px;
		@apply rounded-full;
	}
	.team-input-container {
		@apply border border-light-gray border-y-transparent;
		@apply flex-grow;
		@apply flex items-center justify-between;
		@apply w-full;

		@apply focus-within:outline-secondary focus-within:outline;

		&:hover {
			@apply outline-white outline;
		}

		&:hover .btn-team-default {
			opacity: 1;
		}
	}
	.team-name-input {
		height: 40px;
		width: 100%;
		@apply px-4;
		@apply text-left bg-transparent border-none outline-none;
	}
	.delete-icon {
		width: 30px;
		@apply flex items-center justify-center;
	}

	.btn-team-default {
		@apply rounded-full;
		@apply text-xs;
		@apply border border-light-gray;
		@apply bg-light-gray;
		@apply px-2 py-1 mx-1;
		opacity: 0;
		&:hover {
			opacity: 1;
		}
		&.active {
			opacity: 1;
			@apply bg-white text-black;
		}
	}

	.delete-icon {
		width: 30px;
		height: 40px;
	}
	.delete-icon.hidden {
		visibility: hidden;
	}
	.delete-icon:hover {
		@apply text-accent-red;
	}
</style>
