<script lang="ts">
	import Loader from "../icon/Loader.svelte";

	interface Props {
		label?: string;
		color?: "primary" | "secondary";
		isLoading?: boolean;
		disabled?: boolean;
	}
	
	let { label = "Button", color="primary", isLoading = false, disabled=false }: Props = $props();
	
</script>

<button
	class:primary={color === "primary"}
	class:secondary={color === "secondary"}
	class:loading={isLoading}
	disabled={isLoading || disabled}
  on:click
>
	{#if isLoading}
		<Loader />
	{:else}
		<slot name="icon-left" />
		{label}
	{/if}
</button>

<style lang="postcss">
	button {
		@apply bg-primary;
		@apply flex justify-center items-center;
		height: 40px;
		@apply px-2;
		gap: 4px;
		border-radius: 4px;
		font-size: 18px;
    width: 280px;
    @apply text-center;
    @apply border border-light-gray;
	}
	button.loading {
		@apply opacity-50 cursor-not-allowed;
		@apply bg-primary;
	}
	button.primary {
		@apply bg-primary;
	}

	button:hover.primary:not(:disabled) {
		@apply bg-primary-dark;
	}

	button.secondary {
		@apply bg-secondary;
	}

	button:hover.secondary:not(:disabled) {
		@apply bg-secondary-dark;
	}
</style>
