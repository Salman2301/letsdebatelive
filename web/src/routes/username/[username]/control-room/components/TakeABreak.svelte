<script lang="ts">
	import supabase from '$lib/supabase';

  let hostId = '123-1234-123';
  
  let timeout = $state("5min");
  function handleLayoutShift() {

    const breakEnd = new Date();
    breakEnd.setMinutes(breakEnd.getMinutes() + parseInt(timeout.replace("mins", "")));

		supabase.channel(`scene_${hostId}`, { config: { broadcast: { self: true } } }).send({
			type: 'broadcast',
			event: 'scene_change',
			payload: {
				sceneType: 'scene_break',
				layerId: 'layer_break',
				metadata: {
          timeout: timeout,
          breakEndAt: breakEnd.toISOString()
				}
			}
		});

  }
</script>

<div class="container">
	<button on:click={handleLayoutShift}> Take a break </button>
	<select bind:value={timeout} >
		<option value="5min" selected>5 mins</option>
		<option value="10min">10 mins</option>
		<option value="15min">15 mins</option>
		<option value="20min">20 mins</option>
	</select>
</div>

<style lang="postcss">
	.container {
		@apply rounded overflow-hidden;
		@apply flex justify-center;
		height: 40px;
		width: fit-content;
	}
	button {
		@apply bg-secondary;
		@apply border-r border-light-gray;
		font-size: 12px;
		@apply h-full;
		width: 120px;
		@apply rounded-tl rounded-bl;
	}

	button:focus {
		outline: none;
	}
	select {
		@apply bg-secondary;
		@apply h-full;
		font-size: 12px;
		@apply rounded-tr rounded-br;
	}

	button:hover {
		@apply bg-secondary-dark;
	}
	select:hover {
		@apply bg-secondary-dark;
	}
</style>
