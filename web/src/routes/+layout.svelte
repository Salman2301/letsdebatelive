<script lang="ts">
	import RootLayout from '$lib/components/slots/RootLayout.svelte';
	import { page } from '$app/stores';
	import '../app.css';
	import { screenWindowSizePx } from '$lib/stores/screen-size.store';
	import { onMount, setContext } from 'svelte';
	import { authUserData } from '$lib/stores/auth.store';
	import type { PageData } from './$types';

	interface Props {
		data: PageData;
	}

	const { data }: Props = $props();

	setContext('lib_supabase', data.supabase);

	onMount(async () => {
		await data.supabase.auth.getSession();

		$authUserData = data.userData;

		handleScreenResize();
	});

	function handleScreenResize() {
		const width = window.innerWidth;
		screenWindowSizePx.set(width);
	}
</script>

<svelte:window onresize={handleScreenResize} />

{#if $page.url.pathname.includes('/video-feed')}
	<slot />
{:else}
	<RootLayout>
		<slot></slot>
	</RootLayout>
{/if}

<style lang="postcss">
</style>
