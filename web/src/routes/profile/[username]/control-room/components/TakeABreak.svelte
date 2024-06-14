<script lang="ts">
	import { getContext } from 'svelte';
	import { emitSceneChange } from '../channel';
	import { getSupabase } from '$lib/supabase';
	import { PageCtx } from '$src/lib/context';

	const supabase = getSupabase();
	const pageCtx = new PageCtx('control-room');

	let live_feed = pageCtx.get('ctx_table$live_feed');

	let timeout = $state('5min');
	function handleLayoutShift() {
		if (!$live_feed?.id) return;
		const breakEnd = new Date();
		breakEnd.setMinutes(breakEnd.getMinutes() + parseInt(timeout.replace('mins', '')));
		breakEnd.setSeconds(breakEnd.getSeconds() + 1);

		emitSceneChange(supabase, $live_feed.id, {
			sceneType: 'scene_break',
			layerId: 'layer_break',
			metadata: {
				timeout: timeout,
				breakEndAt: breakEnd.toISOString()
			}
		});
	}
</script>

<div class="container">
	<button onclick={handleLayoutShift}> Take a break </button>
	<select bind:value={timeout}>
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
		height: 30px;
		width: 150px;
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
