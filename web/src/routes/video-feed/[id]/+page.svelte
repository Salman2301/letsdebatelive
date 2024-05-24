<script lang="ts">
	import VideoFeed from "$lib/components/video-feed/VideoFeed.svelte";
	import type { Tables } from "$lib/schema/database.types.js";
	

	interface Props {
		data: {
			live_debate_id: string;
		}
	}

	let { data }: Props = $props();

</script>

<VideoFeed live_debate_id={data.live_debate_id}/>

<style lang="postcss">

</style>