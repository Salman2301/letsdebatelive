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

	type CB = ({ colIndex, rowIndex }: { colIndex: number; rowIndex: number }) => void;
	type Props = {
		onBoxChange?: CB;
		setInitBox?: { colIndex: number; rowIndex: number };
	};
	const { onBoxChange, setInitBox }: Props = $props();

	onMount(() => {
		if (!setInitBox) return;
		boxes = [...resetBox()];
		boxes[setInitBox.colIndex][setInitBox.rowIndex] = true;
	});
</script>

<div class="pos-box-container">
	<p>Select a position of the logo</p>
	<div class="box-container">
		{#each boxes as rowBox, colIndex}
			<div class="row-box">
				{#each rowBox as box, rowIndex}
					<button
						class="box"
						class:active={box}
						onclick={() => {
							if (box) return;
							boxes = [...resetBox()];
							onBoxChange?.({ colIndex, rowIndex });
							boxes[colIndex][rowIndex] = !box;
						}}
					>
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
		width: 16px;
		height: 16px;
		@apply border border-light-gray;
    &:hover {
      @apply bg-secondary/40;
    }
		&.active {
			@apply bg-secondary;
		}
	}
</style>
