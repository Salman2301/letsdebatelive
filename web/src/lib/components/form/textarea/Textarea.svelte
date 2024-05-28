<script lang="ts">
	interface Props {
		placeholder?: string;
		name?: string;
		title?: string;
		rounded?: 'sm' | 'full';
		disabled?: boolean;
		ariaLabel?: string;
		hasError?: boolean;
		value?: string;
	}

	let {
		placeholder,
		name,
		title,
		rounded,
		disabled,
		hasError,
		ariaLabel,
		value = $bindable('')
	}: Props = $props();
</script>

<div>
	<label for="" style="left:{rounded === 'sm' ? '10px' : '20px'}">
		{title || name}
	</label>
	<textarea
		{placeholder}
		{name}
		{disabled}
		class:has-error={hasError}
		aria-label={ariaLabel}
		bind:value
		oninput={() => {
			hasError = false;
		}}
	></textarea>
</div>

<style lang="postcss">
	div {
		position: relative;
		margin: 10px 0px;
		@apply w-full;
	}
	label {
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

	textarea {
		@apply bg-primary-dark;
		@apply border border-light-gray focus:border-white;
		@apply rounded;
		width: 100%;
		@apply px-4 py-2;
		@apply outline-none focus:outline-none;
		font-size: 16px;
		height: 150px;
	}
	textarea:hover {
		@apply border-white;
	}
	textarea:focus {
		@apply bg-secondary-dark/80;
	}
</style>
