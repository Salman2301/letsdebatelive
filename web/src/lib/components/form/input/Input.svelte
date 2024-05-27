<script lang="ts">
	interface Props {
		name?: string;
		value?: string;
		placeholder?: string;
		disabled?: boolean;
		type?: string;
		autofocus?: boolean;
		hasError?: boolean;
	}
	let {
		value = $bindable(''),
		placeholder,
		disabled,
		type,
		autofocus,
		name,
		hasError
	}: Props = $props();
</script>

<div>
	<label for="">{name}</label>
	<input
		bind:value
		{placeholder}
		{disabled}
		{name}
		{type}
		class:has-error={hasError}
		{autofocus}
		oninput={() => {
			hasError = false;
		}}
	/>
</div>

<!-- svelte-ignore a11y_autofocus -->

<style lang="postcss">
	input {
		width: 280px;
		min-width: 40px;
		border: 1px solid var(--color-light-gray);
		@apply bg-primary-dark;
		border-radius: 40px;
		padding: 10px 20px;
		outline: none;
	}
	input:focus {
		outline: none;
		border: 1px solid;
		@apply: border-secondary;
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
		left: 20px;
		top: -8px;
		text-transform: capitalize;
		border-radius: 10px;
	}
</style>
