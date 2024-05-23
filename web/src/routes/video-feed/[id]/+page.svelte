<script lang="ts">
	import VideoFeed from "$lib/components/video-feed/VideoFeed.svelte";
	
	export let data;

</script>

<VideoFeed live_debate_id={data.live_debate_id}/>

<style lang="postcss">

</style>