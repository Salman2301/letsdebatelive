<script lang="ts">
	interface Props {
		content?: string;
		textAlign?: 'left' | 'right' | 'center';
	}

	let { content = '', textAlign }: Props = $props();
</script>

<h3
	class:txt-left={textAlign === 'left'}
	class:txt-center={textAlign === 'center'}
	class:txt-right={textAlign === 'right'}
>
	{content}
</h3>

<style lang="postcss">
	h3 {
		font-size: 16px;
		letter-spacing: 1px;
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
