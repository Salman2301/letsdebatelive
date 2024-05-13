<script lang="ts">
	interface Props {
		label: string;
		color?: 'primary' | 'secondary' | 'accent-red';
		width?: number;
		fillType?: 'solid' | 'outline' | 'hover';
	}
	let { label = 'Button', color = 'primary', fillType = 'solid', width }: Props = $props();
</script>

<button
	class:fill-type-solid={fillType === 'solid'}
	class:fill-type-outline={fillType === 'outline'}
	class:fill-type-hover={fillType === 'hover'}
	style="--theme-color:var(--color-{color});--theme-color-dark:var(--color-{color}-dark);width: {width
		? `${width}px`
		: 'fit-content'}"
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
	}
</style>
