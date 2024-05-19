<script lang="ts">
	import EndingScene from './scenes/EndingScene.svelte';
	import StartingScene from './scenes/StartingScene.svelte';
	import BreakScene from './scenes/BreakScene.svelte';
	import ContentScene from './scenes/ContentScene.svelte';
	import Loader from '$lib/components/icon/Loader.svelte';
	import { getContext, onMount } from 'svelte';
	import supabase from '$lib/supabase';
	import type { ScenePayload, SceneType } from './video-feed.types';

	// let sceneType: SceneType;
	let payloadData: ScenePayload = {
		sceneType: 'scene_loading',
		layerId: 'layer_text',
		metadata: { text: 'loading' }
	};

	let hostId = getContext('HOST_ID');

	onMount(() => {
		supabase
			.channel(`scene_${hostId}`)
			.on('broadcast', { event: 'scene_change' }, onSceneChange)
			.subscribe();
	});

	function onSceneChange({ payload }: { payload: ScenePayload }) {
		if (!payload || !payload.sceneType) {
			console.error('Empty payload received?', payload);
			return;
		}
		payloadData = payload;
		console.log({ payload });
	}
</script>

<div class="video-container">
	{#if !!payloadData.sceneType}
		<!-- Need to communicate with puppetter page ready -->
		<div class="loaded-video-el"></div>
	{/if}
	{#if payloadData.sceneType === 'scene_start'}
		<StartingScene payload={payloadData} />
	{:else if payloadData.sceneType === 'scene_break'}
		<BreakScene payload={payloadData} />
	{:else if payloadData.sceneType === 'scene_end'}
		<EndingScene payload={payloadData} />
	{:else if payloadData.sceneType === 'scene_content'}
		<ContentScene payload={payloadData} />
	{:else}
		<div class="loader-container">
			<Loader />
		</div>
	{/if}
</div>

<style lang="postcss">
	.video-container {
		aspect-ratio: 16 / 9;
		@apply border border-light-gray;
		overflow: hidden;
		width: 100%;
	}

	.loader-container {
		@apply flex justify-center items-center;
		@apply w-full h-full;
	}
</style>
