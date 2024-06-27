<script lang="ts">
	import SupportButton from '$lib/components/button/SupportButton.svelte';
	import FollowButton from '$lib/components/button/FollowButton.svelte';
	import BackstagePanel, { type DevicesEnable } from './components/panel/BackstagePanel.svelte';
	import JoinBackstagePanel from './components/panel/JoinBackstagePanel.svelte';
	import UserImage from '$src/lib/components/user-image/UserImage.svelte';
	import Chat from './components/sidebar/Chat.svelte';
	import VideoFeed from '$src/lib/components/video-feed/VideoFeed.svelte';

	import { newToast } from '$lib/components/toast/Toast.svelte';
	import { onDestroy, onMount } from 'svelte';
	import { authUserData } from '$lib/stores/auth.store';
	import { getSupabase } from '$lib/supabase';
	import { PageCtx } from '$src/lib/context';
	import { writable } from 'svelte/store';
	import { participantsWithUserDataSelect, type ParticipantsWithUserData } from '$src/lib/types';

	import type { RealtimeChannel } from '@supabase/supabase-js';
	import type { ActionData, PageData } from './$types';

	interface Props {
		data: PageData;
		form: ActionData;
	}

	let { data, form }: Props = $props();

	let sidebar: 'chat' | 'agenda' | 'qa' | 'backstage-chat' = $state('chat');

	const supabase = getSupabase();
	const pageCtx = new PageCtx('live');

	let backstageChannel: RealtimeChannel;

	let myBackstageInfo = writable(data.myBackstageInfo);
	let participants = writable(data.participants || []);
	let isJoined = writable(data.isJoined);

	pageCtx.set({
		pageDataProps: data,
		myBackstageInfo: myBackstageInfo
	});

	let devicesEnable: DevicesEnable = $derived({
		cam_enable: !!$myBackstageInfo?.cam_enable,
		mic_enable: !!$myBackstageInfo?.mic_enable,
		screenshare_enable: !!$myBackstageInfo?.screenshare_enable,
		speaker_enable: !!$myBackstageInfo?.speaker_enable
	});

	onMount(() => {
		if ($isJoined && data?.live_feed?.id) {
			backstageChannel = supabase.channel(`backstage_${data.live_feed.id}`);

			backstageChannel.on(
				'postgres_changes',
				{
					event: '*',
					schema: 'public',
					table: 'live_feed_participants',
					filter: `live_feed=eq.${data.live_feed.id}`
				},
				(payload) => syncBackstage()
			);

			backstageChannel.subscribe();
		}
	});

	async function syncBackstage() {
		if (!data?.live_feed?.id) return;
		if (!$authUserData) {
			return;
		}
		const { data: participantsData, error } = await supabase
			.from('live_feed_participants')
			.select(participantsWithUserDataSelect)
			.eq('live_feed', data.live_feed.id)
			.order('created_at', { ascending: true })
			.returns<ParticipantsWithUserData[]>();

		$participants = participantsData || [];

		$myBackstageInfo =
			$participants.find((item) => item.participant_id.id === $authUserData.id) || null;

		$isJoined = !!myBackstageInfo;
		if (!$isJoined) backstageChannel.unsubscribe();
	}

	if (form && form.error_code && form.error_code === 'MAX_PARTICIPANT') {
		newToast({
			type: 'error',
			message: form.message
		});
	}

	onDestroy(() => {
		backstageChannel?.unsubscribe();
	});
</script>

<div class="page-container">
	<div class="live-video-content">
		<div class="video-container">
			{#if data?.live_feed?.id}
				<VideoFeed live_feed_id={data.live_feed.id}/>
			{/if}
		</div>
		{#if $isJoined}
			<BackstagePanel
				bind:participants={$participants}
				myBackstageInfo={$myBackstageInfo}
				pageData={data}
				{devicesEnable}
			/>
		{:else}
			<JoinBackstagePanel />
		{/if}
		<div class="title-action">
			<div class="title">Title</div>
			<div class="support-follower">
				<FollowButton 
					userId={data.live_feed?.host}
				/>
				<SupportButton />
			</div>
		</div>
		<div class="host-header">
			<div class="host-img">
				<UserImage user={data.host} />
			</div>
			<div class="host-title-desc">
				<div class="host-detail">{data.host?.displayName}</div>
				<div class="followers">11.k followers</div>
			</div>
		</div>
		<!-- <div class="comment-section">After fact comment section</div> -->
	</div>
	<div class="chat-sticky-container">
		<div class="chat-content">
			<div class="chat-header">
				<button
					class="btn-switch"
					class:active={sidebar === 'chat'}
					onclick={() => (sidebar = 'chat')}
				>
					Chat
				</button>
				<button
					class="btn-switch"
					class:active={sidebar === 'agenda'}
					onclick={() => (sidebar = 'agenda')}
				>
					Agenda
				</button>
				<button class="btn-switch" class:active={sidebar === 'qa'} onclick={() => (sidebar = 'qa')}>
					QA
				</button>
				<button
					class="btn-switch"
					class:active={sidebar === 'backstage-chat'}
					onclick={() => (sidebar = 'backstage-chat')}
				>
					Backstage Chat
				</button>
			</div>
			<Chat />
		</div>
	</div>
</div>

<style lang="postcss">
	.page-container {
		@apply flex gap-2;
		@apply mx-2;
	}

	.live-video-content {
		/* width: calc( 100% - 520px); */
		@apply w-full;
		@apply h-full;
	}
	.video-container {
		aspect-ratio: 16 / 9;
		@apply rounded border border-light-gray;
		@apply bg-black;
	}
	.chat-sticky-container {
		@apply flex-grow;
	}
	.chat-content {
		width: 480px;
		height: calc(100vh - 76px);
		@apply flex flex-col;
		@apply sticky;
		right: 0px;
		top: 0px;
	}

	.chat-header {
		@apply flex items-center justify-evenly;
		@apply px-2 my-1;
	}

	.btn-switch {
		width: 100%;
		height: 40px;
		@apply rounded;
		@apply text-xs;
	}

	.btn-switch.active {
		@apply bg-white;
		@apply text-secondary;
	}

	.title-action {
		@apply flex;
	}

	.title {
		@apply text-2xl;
		@apply my-2;
		@apply flex-grow;
	}

	.host-img {
		width: 40px;
		height: 40px;
		border-radius: 100%;
		@apply bg-light-gray;
		overflow: hidden;
	}

	.host-header {
		@apply flex items-center;
		@apply my-2;
	}

	.host-title-desc {
		@apply px-3;
		@apply flex-grow;
		.host-detail {
			@apply text-xs font-bold;
		}
		.followers {
			@apply mt-1 text-sm text-white/60;
		}
	}

	.support-follower {
		@apply flex justify-end items-start gap-4;
	}
</style>
