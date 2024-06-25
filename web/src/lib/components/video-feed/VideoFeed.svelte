<script lang="ts">
	import EndingScene from './scenes/EndingScene.svelte';
	import StartingScene from './scenes/StartingScene.svelte';
	import BreakScene from './scenes/BreakScene.svelte';
	import ContentScene from './scenes/ContentScene.svelte';
	import Loader from '$lib/components/icon/Loader.svelte';

	import { getSupabase } from '$lib/supabase';
	import { onMount } from 'svelte';
	import { lastScreenPayloadContent } from './scenes/store/scene';

	import type { ScenePayload } from './video-feed.types';
	import type { Tables } from '$lib/schema/database.types';
	import type { RealtimePostgresChangesPayload } from '@supabase/supabase-js';
	import {
		participantsWithUserDataSelect,
		type ParticipantsWithUserData
	}
	from '$src/lib/types';
	import { WebRTCRoom } from '$src/lib/utils/webRTC.utils';

	// let sceneType: SceneType;
	let payloadData: ScenePayload = $state({
		sceneType: 'scene_loading',
		layerId: 'layer_text',
		metadata: { text: 'loading' }
	});

	interface Props {
		live_feed_id: string;
		makeCall?: boolean;
	}

	let { live_feed_id, makeCall }: Props = $props();

	const supabase = getSupabase();
	let participantsList: ParticipantsWithUserData[] = $state([]);

	onMount(async () => {
		supabase
			.channel(`scene_${live_feed_id}`)
			.on('broadcast', { event: 'scene_change' }, onSceneChange)
			.subscribe();

		supabase
			.channel(`participants_${live_feed_id}`)
			.on(
				'postgres_changes',
				{
					event: '*',
					schema: 'public',
					table: 'live_feed_participants',
					filter: `live_feed=eq.${live_feed_id}`
				},
				(payload: RealtimePostgresChangesPayload<Tables<'live_feed_participants'>>) =>
					onParticpantChange()
			)
			.subscribe();

		onParticpantChange();
	});

	async function onParticpantChange() {
		if (!live_feed_id) return;
		const { data, error } = await supabase
			.from('live_feed_participants')
			.select(participantsWithUserDataSelect)
			.eq('live_feed', live_feed_id)
			.eq('location', 'stage')
			.returns<ParticipantsWithUserData[]>();
		participantsList = data ?? [];
	}

	async function onSceneChange({ payload }: { payload: ScenePayload }) {
		if (!payload || !payload.sceneType) {
			console.error('Empty payload received?', payload);
			return;
		}
		payloadData = payload;

		if (payload.sceneType === 'scene_content') {
			lastScreenPayloadContent.set(payload);

			const rtc = new WebRTCRoom(live_feed_id, supabase);
			await rtc.init();
			if(makeCall) await rtc.makeCall();

		}
	}

</script>

<div class="video-container" id="video-el-{live_feed_id}" data-feed-id={live_feed_id}>
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
