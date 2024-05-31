<script lang="ts">
	import Input from "$lib/components/form/input/Input.svelte";
	import TeamSetting from '$src/lib/components/group/team-setting/TeamSetting.svelte';
	import { PageCtx } from "$src/lib/context";
	import { getSupabase } from "$src/lib/supabase";
	import { getContext, onMount } from "svelte";

	const page = new PageCtx("new-debate");
	const liveDebate = page.get("liveDebate");
	const teams = page.get("teams");

	const supabase = getSupabase(getContext);

	let title = $state("");
	export async function beforeOnNext() {
		// Add all stage to teams and participants table
		if(!$liveDebate) return;

		await supabase.from("live_debate").update({
			title,
		}).eq("id", $liveDebate.id);
	}

	onMount(()=>{
		if($liveDebate?.title) title = $liveDebate?.title;
	})

</script>

<div class="in-title">
	<Input
		rounded="sm"
		title="Debate title"
		width="480px"
		placeholder="Enter title for your live debate"
		bind:value={title}
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
