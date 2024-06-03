<script lang="ts">
	interface Props {
		label: string;
		color?: 'primary' | 'secondary' | 'accent-red';
		width?: number;
		testId?: string;
		fillType?:
			| 'solid'
			| 'outline'
			| 'hover'
			| 'outline-solid'
			| 'solid-outline'
			| 'dark'
			| 'solid-white';
		onclick?: () => void;
		disabled?: boolean;
		fontType?: 'bold' | 'semibold' | 'normal';
	}
	let {
		label = 'Button',
		color = 'primary',
		fillType = 'solid',
		disabled = false,
		testId,
		width,
		onclick = () => {},
		fontType = 'bold'
	}: Props = $props();
</script>

<button
	class="fill-type-{fillType}"
	style="--theme-color:rgb(var(--color-{color}));--theme-color-dark:rgba(var(--color-{color}-dark));width: {width
		? `${width}px`
		: 'fit-content'};font-weight:{fontType}"
	{disabled}
	{onclick}
	data-testid={testId}
>
	<slot name="icon-left" />
	{label}
</button>

<style lang="postcss">
	button {
		/* @apply bg-primary; */

		@apply flex justify-between items-center;
		height: 40px;
		@apply px-2;
		gap: 4px;
		border-radius: 4px;
		font-size: 12px;

		display: flex;
		justify-content: center;
	}

	button {
		&.fill-type-solid {
			background-color: var(--theme-color);
			&:hover {
				background-color: var(--theme-color-dark);
			}
		}

		&.fill-type-outline {
			@apply bg-transparent;
			@apply border;
			border-color: var(--theme-color);

			&:hover {
				border-color: var(--theme-color-dark);
			}
		}

		&.fill-type-hover {
			@apply bg-transparent;

			&:hover {
				background-color: var(--theme-color);
			}
		}

		&.fill-type-solid-outline {
			background-color: var(--theme-color);
			border-color: var(--theme-color);
			@apply border;

			&:hover {
				@apply bg-transparent;
			}
		}

		&.fill-type-solid-white {
			background-color: var(--theme-color);
			&:hover {
				@apply bg-white;
				color: var(--theme-color);
			}
		}
		&.fill-type-outline-solid {
			border-color: var(--theme-color);
			@apply border;
			@apply bg-transparent;

			&:hover {
				background-color: var(--theme-color);
			}
		}
		&.fill-type-dark {
			background-color: var(--theme-color-dark);
			&:hover {
				background-color: var(--theme-color);
			}
		}
	}

	button:disabled {
		background: lightgray;
		cursor: pointer;
	}
	button:disabled:hover {
		background: lightgray;
		cursor: pointer;
	}
</style>
