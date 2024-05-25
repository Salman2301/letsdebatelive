<script lang="ts">
	import SupportButton from '$lib/components/button/SupportButton.svelte';
	import FollowButton from '$lib/components/button/FollowButton.svelte';
	import BackstagePanel from './components/panel/BackstagePanel.svelte';
	import JoinBackstagePanel from './components/panel/JoinBackstagePanel.svelte';
	
	import { getContext, onDestroy, onMount } from 'svelte';
	import { getSupabase } from '$lib/supabase';
	import { authUserData } from '$lib/components/auth/auth.store';

	import type { RealtimeChannel } from '@supabase/supabase-js';
	import type { PageServerData } from './$types';

	interface Props {
		data: PageServerData;
	}
	let { data } : Props = $props();

	let sidebar: 'chat' | 'agenda' | 'qa' | 'backstage-chat' = $state('chat');
	let userJoined = $state(data.isJoined);

	const supabase = getSupabase(getContext);
	let backstageChannel: RealtimeChannel;

	let participants = $state(data.participants || []);
	let isJoined = $state(data.isJoined);
	
	onMount(()=>{
		if( data.isJoined && data?.live_debate?.id) {
			backstageChannel = supabase.channel(`backstage_${data.live_debate.id}`);

			backstageChannel.on("postgres_changes",
				{
					event: '*',
					schema: 'public',
					table: 'live_debate_participants',
					filter: `live_debate=eq.${data.live_debate.id}`		
				},
				payload=>syncBackstage()
			)

			backstageChannel.subscribe();
		}
	});

	async function syncBackstage() {
		if( !data?.live_debate?.id) return;
		if( !$authUserData ) {
			return;
		}
		const { data: participantsData, error  } = await supabase.from("live_debate_participants")
			.select().eq("live_debate", data.live_debate.id);

		participants = participantsData || [];

		isJoined = !!participants.find(item=>item.participant_id === $authUserData.id )

		if(!isJoined) backstageChannel.unsubscribe();
	}

	onDestroy(()=>{
		backstageChannel?.unsubscribe();
	})

</script>

<div class="page-container">
	<div class="live-video-content">
		<div class="video-container"></div>
		{#if userJoined}
			<BackstagePanel bind:participants={participants}/>
		{:else}
			<JoinBackstagePanel />
		{/if}
		<div class="title-action">
			<div class="title">Title</div>
			<div class="support-follower">
				<FollowButton />
				<SupportButton />
			</div>
		</div>
		<div class="host-header">
			<div class="host-img"></div>
			<div class="host-title-desc">
				<div class="host-detail">Host detail</div>
				<div class="followers">11.k followers</div>
			</div>
		</div>
		<div class="comment-section">After fact comment section</div>
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
			<div class="chat-container">
				<div class="chat-items">
					<div class="chat-item">
						<span class="chat-item-username">username</span><span class="chat-item-content"
							>This is a content of the chat user</span
						>
					</div>
					<div class="chat-input-container">
						<textarea class="chat-text"></textarea>
						<button class="btn-submit">Submit</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="postcss">
	.page-container {
		@apply w-full;
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

	.chat-container {
		@apply flex-grow;
		@apply overflow-auto;
		@apply flex flex-col justify-between;
	}

	.chat-items {
		@apply w-full;
		@apply px-2;
	}

	.chat-input-container {
		@apply flex flex-col justify-end;
		height: calc(100vh - 76px - 70px);
	}
	.chat-text {
		@apply rounded;
		@apply border border-light-gray;
		@apply bg-transparent text-white;
	}
	.btn-submit {
		@apply self-end;
		@apply text-xs;
		@apply bg-primary;
		@apply px-2 py-1;
		@apply my-1;
		@apply rounded;
		@apply border border-primary;
	}
	.btn-submit:hover {
		@apply bg-primary-dark;
	}

	.chat-item {
		@apply py-1;
		@apply text-xs;
	}
	.chat-item-username {
		@apply text-team-a;
		@apply font-bold;
		@apply pr-2;
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
