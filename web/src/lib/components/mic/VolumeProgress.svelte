<script lang="ts">
	import { onMount } from "svelte";

	interface Props {
		bar?: number;
		percent: number
	}
	let { bar = 20, percent = 0.1 }: Props = $props();

	const startHue = 82;
	const endHue = -10;

	const ratio = (startHue - endHue) / bar;

	let plates: string[] = $state([]);

	onMount(()=>{
		for( let i = startHue; i > endHue; i-=ratio ) {
			plates.push(`hsl(${i}, 100%, 50%)`);
		}
	})

</script>
<div class="container">
	{#each plates as plate, i}
		<div
			class="plate"
			style="background:{i < Math.ceil(percent * plates.length) ? plate : '#000'};"
		></div>
	{/each}
</div>

<style lang="postcss">
	.container {
		@apply flex;
		border: 1px solid var(--color-light-gray);
		border-radius: 4px;
		max-width: 440px;
		height: 40px;
		@apply justify-evenly items-center;
		position: relative;
	}

	.plate {
		width: 6px;
		height: 22px;
		border: 1px solid var(--color-light-gray);
		border-radius: 6px;
		z-index: 3;
		/* mask-clip: calc(); */
	}

	/* .container::before {
    content:"";
    background: linear-gradient(90deg, rgba(189,255,0,1) 0%, rgba(255,0,0,1) 100%);
    width: 100%;
    height: 100%;
    position: absolute;
  } */
</style>
