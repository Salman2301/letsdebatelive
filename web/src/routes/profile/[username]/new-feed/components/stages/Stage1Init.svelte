<script lang="ts">
	import Input from '$lib/components/form/input/Input.svelte';
	import TeamSetting from '$src/lib/components/group/team-setting/TeamSetting.svelte';
	import { PageCtx } from '$src/lib/context';
	import { getSupabase } from '$src/lib/supabase';
	import { onMount } from 'svelte';

	const page = new PageCtx('new-feed');
	const liveFeed = page.get('liveFeed');
	const teams = page.get('teams');

	const supabase = getSupabase();

	let title = $state('');
	export async function beforeOnNext() {
		// Add all stage to teams and participants table
		if (!$liveFeed) return;

		const { data, error } = await supabase
			.from('live_feed')
			.update({
				title
			})
			.eq('id', $liveFeed.id)
			.select();

		if (data?.[0]) $liveFeed = data[0];
	}

	onMount(() => {
		if ($liveFeed?.title) title = $liveFeed?.title;
	});
</script>

<div class="in-title">
	<Input
		rounded="sm"
		title="Feed title"
		width="480px"
		placeholder="Enter title for your live feed"
		bind:value={title}
	/>
</div>

<div class="flex justify-center">
	<div class="container">
		<TeamSetting live_feed={liveFeed} {teams} />
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
