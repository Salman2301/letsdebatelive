<script lang="ts">
	import Heading2 from "$src/lib/components/form/Heading2.svelte";
	import Loader from "$src/lib/components/icon/Loader.svelte";
	import { PageCtx } from "$src/lib/context";
	
	const pageCtx = new PageCtx("control-room");
	const partcipants = pageCtx.get("ctx_table$live_feed_participants_stage");
</script>

<div class="p-4">
	<Heading2 content="Screen" />
	<p class="font-semibold text-white/60 text-sm mb-4">Choose one of the following screenshared by you and your audience</p>
	<div class="screen-items">
		{#each ($partcipants || []) as partcipant}
			<div class="screen-item" class:selected={true}>
				<div class="screen">
					<Loader />
				</div>
				<p class="display-name">{partcipant.display_name}</p>
			</div>
		{/each}
	</div>
</div>

<style lang="postcss">
	.screen-item {
		@apply w-min;
	}
	.screen {
		aspect-ratio: 16/9;
		width: 200px;
		@apply rounded border border-light-gray;
		@apply flex items-center justify-center;
	}
	.screen-items {
		@apply grid grid-cols-2 gap-4;
	}
	.selected {
		.screen {
			@apply border-primary;
		}
		.display-name {
			@apply text-white;
		}
	}
	.display-name {
		&::before {
			content: "@";
			@apply pr-1 text-white/60;
		}
		@apply py-1 font-semibold text-white/80 text-sm;
	}
</style>