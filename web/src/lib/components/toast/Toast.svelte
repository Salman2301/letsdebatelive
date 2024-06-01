<script context="module" lang="ts">
	import { get, writable, type Writable } from 'svelte/store';

	export interface ToastItemI {
		message: string;
		type: 'success' | 'error' | 'warn' | 'info';
		onclose?: () => void;
		id?: string;
	}

	const toast: Writable<ToastItemI[]> = writable([]);

	export function newToast(toastNewMessage: ToastItemI) {
		let id = toastNewMessage.id || genId();
		setTimeout(() => {
			clear(id);
		}, 14_000);
		toast.set([...get(toast), { ...toastNewMessage, id }]);
	}

	export function clear(id: string) {
		toast.set(get(toast).filter((e) => e.id !== id));
	}
</script>

<script lang="ts">
	import ToastItem from './ToastItem.svelte';
	import { genId } from '$lib/utils/gen.utils';
</script>

<div class="toast-container">
	{#each $toast as currToast (currToast.id)}
		<ToastItem data={currToast} />
	{/each}
</div>

<style lang="postcss">
	.toast-container {
		position: fixed;
		/* border: 1px solid white; */
		width: 300px;

		top: 80px;
		right: 0px;
		/* height: 400px; */
		/* right: 50%; */
		/* transform: translate(-50%, -50%); */
		z-index: 1000;
	}
</style>
