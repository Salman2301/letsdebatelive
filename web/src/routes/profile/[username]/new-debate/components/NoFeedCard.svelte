<script lang="ts">
	import NoFeed from '../icon/NoFeed.svelte';

	interface Props {
		label: string;
		feedType?: "profile" | "screen"
	}
	let { label = 'No Feed', feedType="profile" }: Props = $props();
</script>

<button class="no-feed-container" on:click>
	<div class="content">
		<p>{label}</p>
	</div>
	
	<img src="{feedType === "profile"? "/images/thumbnail/NO_VIDEO_PROFILE.png" : "/images/thumbnail/NO_VIDEO_SCREEN.png"}" class="no-feed-thumbnail" alt="web cam feed" />
</button>

<style lang="postcss">
	.no-feed-container {
		position: absolute;
		z-index: 1;
	}
	.content {
		position: absolute;
		display: flex;
		justify-content: end;
		flex-direction: column;
		align-items: center;
		width: 100%;
		height: 100%;
	}
	p {
		font-size: 18px;
    color: orange;
	}
</style>
