<script lang="ts">
	export let label = "Button";
	export let color: "primary" | "secondary" = "primary";
</script>

<button
	class:primary={color === "primary"}
	class:secondary={color === "secondary"}
  on:click
>
	<slot name="icon-left" />
	{label}
</button>

<style lang="postcss">
	button {
		@apply bg-primary;
		@apply flex justify-between items-center;
		height: 40px;
		@apply px-2;
		gap: 4px;
		border-radius: 4px;
		font-size: 12px;
		font-weight: bold;
	}

	button.primary {
		@apply bg-primary;
	}

	button:hover.primary {
		@apply bg-primary-dark;
	}

	button.secondary {
		@apply bg-secondary;
	}

	button:hover.secondary {
		@apply bg-secondary-dark;
	}
</style>
