<script lang="ts">
	interface Props {
		content?: string;
		textAlign?: 'left' | 'right' | 'center';
	}

	let { content = '', textAlign }: Props = $props();
</script>

<h2
	class:txt-left={textAlign === 'left'}
	class:txt-center={textAlign === 'center'}
	class:txt-right={textAlign === 'right'}
>
	{content}
</h2>

<style lang="postcss">
	h2 {
		font-size: 24px;
	}
	.txt-left {
		@apply text-left;
	}
	.txt-center {
		@apply text-center;
	}
	.txt-right {
		@apply text-right;
	}
</style>
