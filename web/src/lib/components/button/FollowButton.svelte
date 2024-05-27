<script lang="ts">
	import Button from './Button.svelte';

	interface Props {
		followed?: boolean;
	}

	let { followed = false }: Props = $props();
</script>

<Button label="" onclick={() => (followed = !followed)}>
	<span slot="icon-left" class="follow-icon">
		<svg width="17" height="15" viewBox="0 0 17 15" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path
				d="M9.5146 1.8277L9.51483 1.82747C11.0236 0.257668 13.4293 0.0347129 15.0238 1.40461C16.888 3.00914 16.9884 5.89837 15.3148 7.64001L15.3147 7.64012L8.89009 14.3296C8.89007 14.3296 8.89005 14.3297 8.89004 14.3297C8.67178 14.5568 8.32544 14.5568 8.10717 14.3297C8.10714 14.3297 8.10711 14.3297 8.10708 14.3296L1.6827 7.64033C0.0120529 5.89869 0.112425 3.00932 1.9766 1.40473C3.57123 0.0345311 5.98017 0.257915 7.48531 1.82711L7.48589 1.8277L8.13997 2.50738L8.50024 2.88174L8.86051 2.50738L9.5146 1.8277Z"
				stroke="white"
				fill={followed ? '#F7F0FF' : 'rgba(0,0,0,0)'}
			/>
		</svg>
	</span>
</Button>

<style lang="postcss">
	.follow-icon {
		padding: 4px;
	}
</style>
