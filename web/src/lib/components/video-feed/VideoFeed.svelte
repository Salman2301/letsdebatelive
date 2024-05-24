<script lang="ts">
	import EndingScene from './scenes/EndingScene.svelte';
	import StartingScene from './scenes/StartingScene.svelte';
	import BreakScene from './scenes/BreakScene.svelte';
	import ContentScene from './scenes/ContentScene.svelte';
	import Loader from '$lib/components/icon/Loader.svelte';

	import { getSupabase } from '$lib/supabase';
	import { getContext, onMount } from 'svelte';
	import { lastScreenPayloadContent } from './scenes/store/scene';

	import type { ScenePayload, SceneType } from './video-feed.types';
	import type { Tables } from '$lib/schema/database.types';
	import type { SubscriptionCB } from '$lib/schema/subscription.types';
	import type { RealtimePostgresChangesPayload } from '@supabase/supabase-js';
	// let sceneType: SceneType;
	let payloadData: ScenePayload = $state({
		sceneType: 'scene_loading',
		layerId: 'layer_text',
		metadata: { text: 'loading' }
	});

	interface Props {
		live_debate_id: string;
	}

	let { live_debate_id }: Props = $props();

	const supabase = getSupabase(getContext);
	let participantsList: Tables<'live_debate_participants'>[] = $state([]);

	onMount(async () => {
		supabase
			.channel(`scene_${live_debate_id}`)
			.on('broadcast', { event: 'scene_change' }, onSceneChange)
			.subscribe();

		supabase
			.channel(`participants_${live_debate_id}`)
			.on("postgres_changes",
			{
				event: '*',
				schema: 'public',
				table: 'live_debate_participants',
				filter: `live_debate=eq.${live_debate_id}`
			}, (payload: RealtimePostgresChangesPayload<Tables<"live_debate_participants">>)=>onParticpantChange())
			.subscribe();

			onParticpantChange();

	});

	async function onParticpantChange() {
		const { data, error } = await supabase.from('live_debate_participants')
			.select()
			.eq("live_debate", live_debate_id)
			.eq("location", "stage");
		participantsList = data ?? [];
	}

	function onSceneChange({ payload }: { payload: ScenePayload }) {
		if (!payload || !payload.sceneType) {
			console.error('Empty payload received?', payload);
			return;
		}
		payloadData = payload;

		if (payload.sceneType === 'scene_content') {
			lastScreenPayloadContent.set(payload);
		}
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
		@apply border border-light-gray;
		overflow: hidden;
		width: 100%;
	}

	.loader-container {
		@apply flex justify-center items-center;
		@apply w-full h-full;
	}
</style>
