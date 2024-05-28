<script lang="ts">
	interface Props {
		name?: string;
		title?: string;
		value?: string;
		placeholder?: string;
		disabled?: boolean;
		type?: string;
		autofocus?: boolean;
		hasError?: boolean;
		width?: string;
		rounded?: "sm" | "full";
		ariaLabel?: string;
	}
	let {
		value = $bindable(''),
		title,
		placeholder,
		disabled,
		type,
		autofocus,
		name,
		hasError,
		rounded,
		ariaLabel,
		width
	}: Props = $props();
</script>

<div>
	<label
		for=""
		style="left:{rounded==="sm" ? "10px": "20px"}"
	>
		{title || name}
	</label>
	<input
		bind:value
		{placeholder}
		{disabled}
		{name}
		{type}
		class:has-error={hasError}
		style="width:{width ? width : "280px"};border-radius:{rounded === "sm"? "4px" : "40px" }"
		aria-label={ariaLabel}
		oninput={() => {
			hasError = false;
		}}
	/>
</div>

<!-- svelte-ignore a11y_autofocus -->

<style lang="postcss">
	input {
		min-width: 40px;
		border: 1px solid var(--color-light-gray);
		@apply bg-primary-dark;
		padding: 10px 20px;
		outline: none;
	}
	input:hover {
		@apply border-white;
	}
	input:focus {
		outline: none;
		border: 1px solid;
		@apply: border-secondary;
		@apply bg-secondary-dark/80;
	}

	input:disabled {
		@apply bg-light-gray;
		@apply cursor-not-allowed;
	}

	input.has-error {
		border: 1px solid;
		@apply border-accent-red;
	}
	div {
		position: relative;
		margin: 10px 0px;
	}
	label {
		/* margin-bottom: -18px; */
		@apply bg-primary-dark;
		@apply font-bold;
		font-size: 10px;
		z-index: 2;
		padding: 0px 10px;
		position: absolute;
		top: -8px;
		text-transform: capitalize;
		border-radius: 10px;
	}
</style>
