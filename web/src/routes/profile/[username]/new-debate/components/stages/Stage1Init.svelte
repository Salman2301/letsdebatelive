<script lang="ts">
	import Input from "$lib/components/form/input/Input.svelte";
	import TeamSetting from '$lib/components/team-setting/TeamSetting.svelte';
	import { PageCtx } from "$src/lib/context";

	const page = new PageCtx("new-debate");
	const liveDebate = page.get("liveDebate");
	const teams = page.get("teams");

	export function beforeOnNext() {
		// Add all stage to teams and participants table
	}
</script>

<div class="in-title">
	<Input
		rounded="sm"
		title="Debate title"
		width="480px"
		placeholder="Enter title for your live debate"
	/>
</div>

<div class="flex justify-center">
	<div class="container">
		<TeamSetting
			live_debate={liveDebate}
			teams={teams}
		/>
	</div>
</div>

<style lang="postcss">
	.container {
		width: 480px;
	}

	.in-title {
		@apply flex items-center justify-center;
		@apply w-full;
		@apply my-4;
	}
</style>
