<script lang="ts">
	import { writable } from 'svelte/store';
	import { PageCtx } from '$src/lib/context';
	import type { LayoutServerData } from './$types';

	const pageCtx = new PageCtx('new-feed');
	let { data, children }: { data: LayoutServerData; children: any } = $props();

	pageCtx.set({
		liveFeed: writable(data.liveFeed),
		hostParticipant: writable(data.hostParticipant),
		title: writable(''),
		teams: writable([]),
		inviteCohost: writable([])
	});
</script>

{@render children()}
