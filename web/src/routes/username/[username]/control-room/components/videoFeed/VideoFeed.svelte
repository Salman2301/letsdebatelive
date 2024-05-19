<script lang="ts">
	import EndingScene from './scenes/EndingScene.svelte';
	import StartingScene from './scenes/StartingScene.svelte';
	import BreakScene from './scenes/BreakScene.svelte';
	import ContentScene from './scenes/ContentScene.svelte';
	import Loader from '$lib/components/icon/Loader.svelte';
	import { getContext, onMount } from 'svelte';
	import supabase from '$lib/supabase';

	import type { ScenePayload, SceneType } from './video-feed.types';
	import { lastScreenPayloadContent } from './scenes/store/scente.store';
	import type { Tables } from '$lib/schema/database.types';

	// let sceneType: SceneType;
	let payloadData: ScenePayload = {
		sceneType: 'scene_loading',
		layerId: 'layer_text',
		metadata: { text: 'loading' }
	};

	let hostId = getContext('HOST_ID');
	let participantsList: Tables<"live_debate_participants">[] = [];

	onMount(async () => {
		supabase
			.channel(`scene_${hostId}`)
			.on('broadcast', { event: 'scene_change' }, onSceneChange)
			.subscribe();

		// Get participants list
		const { data, error } = await supabase.from("live_debate_participants").select();
		participantsList = data as Tables<"live_debate_participants">[];
		participantsList.length = 2
		console.log({ error, participantsList });
	});

	function onSceneChange({ payload }: { payload: ScenePayload }) {
		if (!payload || !payload.sceneType) {
			console.error('Empty payload received?', payload);
			return;
		}
		payloadData = payload;

		if (payload.sceneType === 'scene_content') {
			lastScreenPayloadContent.set(payload);
		}

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
		<ContentScene payload={payloadData} {participantsList} />
	{:else}
		<div class="loader-container">
			<Loader />
		</div>
	{/if}
</div>

<style lang="postcss">
	.video-container {
		aspect-ratio: 16 / 9;
		/* padding-top: 56.25%; */
		@apply border border-light-gray;
		overflow: hidden;
		width: 100%;
		/* height: 100%; */
	}

	.loader-container {
		@apply flex justify-center items-center;
		@apply w-full h-full;
	}
</style>
