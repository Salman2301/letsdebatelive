<script lang="ts">
	import { initCtx } from "$src/lib/stores/media.store";
	import { onMount } from "svelte";

	onMount(async () => {
		document.addEventListener('click', initCtx, { once: true });
	});	
</script>

<h1>Live stream your next video-conferance right away</h1>

<style lang="postcss">
	h1 {
		@apply mt-12 text-center w-full;
		font-size: 48px;
	}
</style>
