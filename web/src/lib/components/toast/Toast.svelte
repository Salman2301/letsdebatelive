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
    setTimeout(()=>{
      clear(id);
    }, 14_000 )
		toast.set([...get(toast), { ...toastNewMessage, id }]);
	}

	export function clear(id: string) {
		toast.set(get(toast).filter((e) => e.id !== id));
	}
</script>

<script lang="ts">
	import ToastItem from './ToastItem.svelte';
	import { genId } from '$lib/utils/gen';
</script>

<div class="toast-container">
	{#each $toast as currToast (currToast.id)}
		<ToastItem data={currToast} />
	{/each}
</div>

<style lang="postcss">
	.toast-container {
		position: absolute;
		/* border: 1px solid white; */
		width: 380px;

		bottom: 0px;
		right: 0px;
		z-index: 1000;
	}
</style>
