<script lang="ts">
	import RootLayout from './../lib/components/slots/RootLayout.svelte';
	import { page } from '$app/stores';
	import '../app.css';
	import { isLessThanLg, screenWindowSize, screenWindowSizePx } from '$lib/stores/screen-size.store';
	import { onMount } from "svelte"
	
	onMount(()=>{
		handleScreenResize()
	});

	function handleScreenResize() {
		const width = window.innerWidth;
		screenWindowSizePx.set(width);
	}
</script>

<svelte:window onresize={handleScreenResize} />
{#if $page.url.pathname.includes('/record-view')}
	<slot />
{:else}
	<RootLayout>
		<slot></slot>
	</RootLayout>
{/if}

<style lang="postcss">
</style>
