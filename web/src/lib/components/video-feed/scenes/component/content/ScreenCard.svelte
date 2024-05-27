<script lang="ts">
	import type { Tables } from '$lib/schema/database.types';

	interface Props {
		screen: Tables<'live_debate_participants'> | null;
	}
	let { screen }: Props = $props();
</script>

<div class="screen-layout">screen</div>

<style lang="postcss">
	.screen-layout {
		width: 100%;
		height: 100%;
		border: 4px solid white;

		@apply rounded;
	}
</style>
