<script lang="ts">
	import DownArrow from '$src/lib/components/icon/DownArrow.svelte';
	import { slide } from 'svelte/transition';

	interface Props {
		title: string;
		desc: string;
		children: any;
		expand?: boolean;
	}
	let { title, desc, children, expand = $bindable(false) }: Props = $props();
</script>

<div class="widget-container" class:expand>
	<button class="widget-heading" onclick={() => (expand = !expand)}>
		<div class="title-content">
			{title}
		</div>
		<div class="icon" style="rotate:{expand ? '180' : '0'}deg">
			<DownArrow />
		</div>
	</button>
	{#if expand}
		<div transition:slide>
			<div class="widget-desc">
				{desc}
			</div>
			<div class="content">
				{@render children?.()}
			</div>
		</div>
	{/if}
</div>

<style lang="postcss">
	.widget-container {
		border: 1px solid var(--color-light-gray);
		@apply mx-2;
		@apply rounded;
		&.expand, &:hover {
			@apply bg-white/5;
		}
	}

	.widget-heading {
		@apply flex items-center justify-between;
		@apply w-full px-2 py-2;
		font-size: 18px;
	}
	.icon {
		transition: rotate 0.3s;
		scale: 0.7;
		color: #ccc
	}
	.widget-desc {
		@apply text-white/60 text-xs font-bold;
		@apply px-2 my-1;
	}
	button {
		outline: none;
	}
	.content {
		@apply mx-2;
		@apply mb-2;
	}
</style>
