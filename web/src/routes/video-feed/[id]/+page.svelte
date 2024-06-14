<script lang="ts">
	import VideoFeed from '$lib/components/video-feed/VideoFeed.svelte';
	import type { Tables } from '$lib/schema/database.types.js';

	interface Props {
		data: {
			live_feed_id: string;
		};
	}

	let { data }: Props = $props();
</script>

<VideoFeed live_feed_id={data.live_feed_id} />

<style lang="postcss">
</style>
