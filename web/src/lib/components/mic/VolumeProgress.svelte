<script lang="ts">
	const plates = [
		'rgba(189, 255, 0, 1)',
		'rgba(195, 252, 0, 1)',
		'rgba(201, 249, 0, 1)',
		'rgba(207, 246, 0, 1)',
		'rgba(213, 243, 0, 1)',
		'rgba(220, 240, 0, 1)',
		'rgba(226, 237, 0, 1)',
		'rgba(232, 234, 0, 1)',
		'rgba(238, 231, 0, 1)',
		'rgba(244, 228, 0, 1)',
		'rgba(250, 225, 0, 1)',
		'rgba(255, 222, 0, 1)',
		'rgba(255, 216, 0, 1)',
		'rgba(255, 210, 0, 1)',
		'rgba(255, 204, 0, 1)',
		'rgba(255, 198, 0, 1)',
		'rgba(255, 192, 0, 1)',
		'rgba(255, 186, 0, 1)',
		'rgba(255, 180, 0, 1)',
		'rgba(255, 174, 0, 1)',
		'rgba(255, 168, 0, 1)',
		'rgba(255, 162, 0, 1)',
		'rgba(255, 156, 0, 1)',
		'rgba(255, 150, 0, 1)',
		'rgba(255, 144, 0, 1)',
		'rgba(255, 138, 0, 1)',
		'rgba(255, 132, 0, 1)',
		'rgba(255, 126, 0, 1)',
		'rgba(255, 120, 0, 1)',
		'rgba(255, 114, 0, 1)',
		'rgba(255, 108, 0, 1)',
		'rgba(255, 102, 0, 1)',
		'rgba(255, 96, 0, 1)',
		'rgba(255, 90, 0, 1)',
		'rgba(255, 84, 0, 1)'
	];

	let { percent = 0.1 } = $props();
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
