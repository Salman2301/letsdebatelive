<script lang="ts">
	interface Props {
		label: string;
		color: "primary" | "secondary" | "danger";
	}
	let { label = "Button", color = "primary" }: Props = $props();

</script>

<button
	class:primary={color === "primary"}
	class:danger={color === "danger"}
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

	button.danger { 
		@apply bg-accent-red;
	}
	button:hover.danger { 
		@apply border-accent-red bg-accent-red-dark;
	}
</style>
