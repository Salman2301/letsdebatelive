<script lang="ts">
	import { EyeClose, EyeOpen } from '$lib/components/icon';
	import Input from './Input.svelte';

	let inPasswordType = $state('password');
	interface Props {
		name?: string;
		width?: string;
		value: string;
		hasError?: boolean;
		rounded?: 'sm' | 'full';
	}
	let { value = $bindable(''), hasError, name = 'password', rounded, width }: Props = $props();
</script>

<div class="password-field">
	<Input bind:value type={inPasswordType} {name} hasError={!!hasError} {rounded} {width} />
	<button
		class="icon-eye"
		onclick={() => (inPasswordType = inPasswordType === 'password' ? 'text' : 'password')}
		type="button"
	>
		{#if inPasswordType === 'password'}
			<EyeOpen />
		{:else}
			<EyeClose />
		{/if}
	</button>
</div>

<style lang="postcss">
	.password-field {
		position: relative;
		user-select: none;
	}
	.icon-eye {
		outline: none;
		position: absolute;
		right: 10px;
		top: 50%;
		transform: translateY(-50%);
	}
</style>
