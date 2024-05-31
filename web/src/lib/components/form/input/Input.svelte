<script context="module" lang="ts">
	export type KBEvent = Event & { currentTarget: EventTarget & HTMLInputElement; };
</script>

<script lang="ts">
	import Label from "./Label.svelte";

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
		rounded?: 'sm' | 'full';
		oninput?: (e: KBEvent) => void;
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
		oninput,
		width
	}: Props = $props();
</script>

<Label
	label={title || name}
	left={rounded === 'sm' ? '10px' : '20px'}
>
	<input
		bind:value
		{placeholder}
		{disabled}
		{name}
		{type}
		class:has-error={hasError}
		style="width:{width ? width : '280px'};border-radius:{rounded === 'sm' ? '4px' : '40px'}"
		aria-label={ariaLabel}
		oninput={(e) => {
			hasError = false;
			oninput?.(e);
		}}
	/>
</Label>
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
</style>
