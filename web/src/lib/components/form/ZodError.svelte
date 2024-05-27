<script lang="ts">
	interface Props {
		parsed: any;
	}

	const { parsed }: Props = $props();

	const hasError = $derived(Array.isArray(parsed?.error?.issues));
</script>

<div class="container-error">
	{#if hasError}
		<p class="error">
			<span>{parsed.error.issues[0].path[0]}:</span>{parsed.error.issues[0].message}
		</p>
		<div class="more-error">
			{#each parsed.error.issues.slice(1) as issue}
				<p class="error"><span>{issue.path[0]}:</span> {issue.message}</p>
			{/each}
		</div>
	{/if}
</div>

<style lang="postcss">
	.error,
	span {
		@apply text-accent-red font-bold;
	}
	.more-error {
		display: none;
	}
	.container-error:hover .more-error {
		display: block;
	}
	span {
		text-transform: capitalize;
		@apply pr-1;
	}
</style>
