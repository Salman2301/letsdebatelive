<script lang="ts">
	import { writable } from 'svelte/store';
	import { PageCtx } from '$src/lib/context';
	import type { LayoutServerData, } from './$types';

	const pageCtx = new PageCtx('new-debate');
	let { data }: { data: LayoutServerData } = $props();


	pageCtx.set({
		liveDebate: writable(data.liveDebate),
		hostParticipant: writable(data.hostParticipant),
		title: writable(''),
		teams: writable([]),
		inviteCohost: writable([])
	});

</script>

<slot></slot>
