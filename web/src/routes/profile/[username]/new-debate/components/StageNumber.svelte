<script lang="ts">
	import { getContext } from 'svelte';
	import type { CTX_KEY_TITLE_TYPE } from '../new-debate.constant';

	interface Props {
		active: number;
	}
	let { active }: Props = $props();

	const title = getContext<CTX_KEY_TITLE_TYPE>('CTX_KEY_TITLE');

	let stages = [
		{
			label: 1,
			info: 'Local Setup'
		},
		{
			label: 2,
			info: 'Team'
		},
		{
			label: 3,
			info: 'Debate Agenda'
		},
		{
			label: 4,
			info: 'Studio mode'
		},
		{
			label: 5,
			info: 'Broadcast'
		}
	];

	$effect(() => {
		$title = stages[active - 1].info;
	});
</script>

<div class="stage-number-container">
	{#each stages as stage}
		<div class="stage-number" class:active={stage.label <= active}>
			{stage.label}

			<div class="bubble-info">{stage.info}</div>
		</div>
		<div class="stage-dash" class:active={stage.label <= active}></div>
	{/each}
</div>

<style lang="postcss">
	.stage-number-container {
		display: flex;
		justify-content: center;
		align-items: center;
		gap: 6px;
	}
	.stage-number {
		color: black;
		background-color: rgba(204, 204, 204, 0.6);
		width: 30px;
		height: 30px;
		border-radius: 4px;
		display: flex;
		justify-content: center;
		align-items: center;

		position: relative;
		font-size: 16px;
	}
	.stage-dash {
		width: 30px;
		height: 1px;
		border-radius: 1px;
		background-color: rgba(204, 204, 204, 0.6);
	}

	.stage-dash:last-child {
		display: none;
	}

	.active {
		@apply bg-white;
	}

	.bubble-info {
		@apply absolute;
		@apply mt-1;
		@apply border border-light-gray;
		padding: 10px 20px;
		@apply bg-white;
		color: black;
		min-width: 140px;
		font-size: 12px;
		top: 40px;

		display: none;
		z-index: 2;
		text-align: center;
		border-radius: 4px;
	}

	.stage-number:hover .bubble-info {
		display: inline;
	}
</style>
