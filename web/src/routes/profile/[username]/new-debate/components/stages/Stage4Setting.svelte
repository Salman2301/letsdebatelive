<script lang="ts">
	import LiveDebateSetting from "$lib/components/group/live-debate-setting/LiveDebateSetting.svelte";
	import { PageCtx } from "$src/lib/context";
	import type { Tables } from "$src/lib/schema/database.types";

	const pageCtx = new PageCtx("new-debate");

	const live_debate = pageCtx.get("liveDebate");
	const teams = pageCtx.get("teams");
	let showSubmit: boolean = false;
	let liveDebateSetting: { submit: () => Promise<Tables<"live_debate">>};

	export async function beforeOnNext() {
		$live_debate = await liveDebateSetting?.submit?.();
	}
</script>


<div class="flex justify-center">
	<div class="container">
		<LiveDebateSetting
			live_debate={live_debate}
			teams={teams}
			showSubmit={showSubmit}
			bind:this={liveDebateSetting}
		/>
	</div>
</div>

<style lang="postcss">
	.container {
		width: 700px;
	}
</style>
