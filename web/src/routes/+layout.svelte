<script lang="ts">
	import RootLayout from '$lib/components/slots/RootLayout.svelte';

	import { page } from '$app/stores';
	import { onMount, setContext } from 'svelte';
	import { initCtx } from '$src/lib/stores/media.store';
	import { authUserData } from '$lib/stores/auth.store';
	import { screenWindowSizePx } from '$lib/stores/screen-size.store';
	import { openSidePanel } from '$src/lib/components/side-panel/side-panel.store';

	import '../app.css';
	
	import type { PageData } from './$types';

	interface Props {
		data: PageData;
		children: any; 
	}

	const { data, children }: Props = $props();

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

	function handleKeydown(e: KeyboardEvent) {
		if (e.key.toLocaleLowerCase() === 'k' && e.metaKey) {
			openSidePanel("equip");
		}
	}
	onMount(()=>{
		document.addEventListener('click', initCtx, { once: true });
	})
</script>

<svelte:window onresize={handleScreenResize} onkeydown={handleKeydown} />

{#if $page.url.pathname.includes('/video-feed')}
	{@render children?.()}
{:else}
	<RootLayout>
		{@render children?.()}
	</RootLayout>
{/if}

<style lang="postcss">
</style>
