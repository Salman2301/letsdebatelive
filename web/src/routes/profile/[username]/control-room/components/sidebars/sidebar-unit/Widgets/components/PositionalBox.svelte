<script lang="ts">
	import { onMount } from 'svelte';

	const resetBox = () => [
		[false, false, false],
		[false, false, false],
		[false, false, false]
	];

	let boxes = $state([
		[false, false, false],
		[false, false, false],
		[false, false, false]
	]);

	let boxesLabel = [
		[ "Top Left", "Top", "Top Right"],
		[ "Middle Left", "Middle", "Middle Right"],
		[ "Bottom Left", "Bottom", "Bottom Right"]
	]

	type CB = ({ colIndex, rowIndex }: { colIndex: number; rowIndex: number }) => void;
	type Props = {
		onBoxChange?: CB;
		rowIndex?: number;
		colIndex?: number;
		setInitBox?: { colIndex: number; rowIndex: number };
	};
	let {
		onBoxChange,
		setInitBox,
		rowIndex=$bindable(setInitBox?.rowIndex || 0),
		colIndex=$bindable(setInitBox?.colIndex || 0)
	}: Props = $props();

	onMount(() => {
		boxes = [...resetBox()];
		console.log({ rowIndex, colIndex })
		boxes[rowIndex][colIndex] = true;
	});
</script>

<div class="pos-box-container">
	<p>Select a position of the logo</p>
	<div class="box-container">
		{#each boxes as rowBox, rowIndex1}
			<div class="row-box">
				{#each rowBox as box, colIndex1}
					<button
						class="box"
						class:active={box}
						onclick={() => {
							if (box) return;
							boxes = [...resetBox()];
							colIndex = colIndex1;
							rowIndex = rowIndex1;
							onBoxChange?.({ colIndex, rowIndex });
							boxes[rowIndex][colIndex] = !box;
						}}
					>
						<div class="box-label">
							{boxesLabel[rowIndex1][colIndex1]}
						</div>
					</button>
				{/each}
			</div>
		{/each}
	</div>
</div>

<style lang="postcss">
	.pos-box-container {
		@apply flex justify-between;
		@apply py-4;
		p {
			@apply mt-2;
		}
	}
	.box-container {
		@apply flex flex-col gap-4;
		@apply p-4;
	}
	.row-box {
		@apply flex gap-4;
	}

	button.box {
		width: 18px;
		height: 18px;
		@apply border border-light-gray;
		@apply relative;
    &:hover {
      @apply bg-secondary/40;
			.box-label {
				@apply block;
			}
    }
		&.active {
			@apply bg-secondary;
		}
	}
	.box-label {
		@apply absolute -top-5 right-2  w-full h-full;
		@apply bg-white;
		@apply text-black;
		@apply font-semibold text-xs;
		@apply hidden;
		z-index: 1000;
		min-width: 80px;
	}
</style>
