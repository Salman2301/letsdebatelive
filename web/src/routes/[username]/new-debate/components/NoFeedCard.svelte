<script lang="ts">
	import NoFeed from '../icons/NoFeed.svelte';

	interface Props {
		label: string;
	}
	let { label = 'No Feed' }: Props = $props();
</script>

<button class="no-feed-container" on:click>
	<div class="content">
		<NoFeed />
		<p>{label}</p>
	</div>
	<img src="/images/thumbnail/NO_VIDEO.png" class="no-feed-thumbnail" alt="web cam feed" />
</button>

<style lang="postcss">
	.no-feed-container {
		position: absolute;
		z-index: 1;
	}
	.content {
		position: absolute;
		display: flex;
		justify-content: center;
		flex-direction: column;
		align-items: center;
		width: 100%;
		height: 100%;
	}
	p {
		font-size: 18px;
	}
</style>
