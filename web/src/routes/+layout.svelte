<script lang="ts">
	import RootLayout from './../lib/components/slots/RootLayout.svelte';
	import { page } from '$app/stores';
	import '../app.css';
</script>

{#if $page.url.pathname.includes('/record-view')}
	<slot />
{:else}
	<RootLayout>
		<slot></slot>
	</RootLayout>
{/if}

<style lang="postcss">
</style>
