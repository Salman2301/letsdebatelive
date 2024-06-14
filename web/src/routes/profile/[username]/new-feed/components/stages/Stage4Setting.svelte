<script lang="ts">
	import LiveFeedSetting, {
		type InstanceType
	} from '$lib/components/group/live-feed-setting/LiveFeedSetting.svelte';
	import { PageCtx } from '$src/lib/context';

	const pageCtx = new PageCtx('new-feed');

	const live_feed = pageCtx.get('liveFeed');
	const teams = pageCtx.get('teams');
	let showSubmit: boolean = false;
	let liveFeedSetting: InstanceType;

	export async function beforeOnNext() {
		$live_feed = await liveFeedSetting?.submit?.();
	}
</script>

<div class="flex justify-center">
	<div class="container">
		<LiveFeedSetting {live_feed} {teams} {showSubmit} bind:this={liveFeedSetting} />
	</div>
</div>

<style lang="postcss">
	.container {
		width: 700px;
	}
</style>
