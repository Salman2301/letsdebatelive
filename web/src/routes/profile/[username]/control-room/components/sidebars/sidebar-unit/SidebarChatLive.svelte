<script lang="ts">
	import Heading2 from '$src/lib/components/form/Heading2.svelte';
	import Loader from '$src/lib/components/icon/Loader.svelte';
	import { newToast } from '$src/lib/components/toast/Toast.svelte';
	import { PageCtx } from '$src/lib/context';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { getSupabase } from '$src/lib/supabase';

	import type { Tables } from '$src/lib/schema/database.types';
	import { chatWithSenderData, type ChatWithSenderData } from '$src/lib/types';
	// User able to popup the chat
	// User can see multiple chats from different broadcasts
	// User can
	let isLoading: boolean = $state(true);
	let isSending: boolean = $state(false);
	let chats: ChatWithSenderData[] = $state([]);
	const supabase = getSupabase();

	const pageCtx = new PageCtx('control-room');
	const liveFeed = pageCtx.get('ctx_table$live_feed');

	let value: string = $state('');
	async function submitChat() {
		try {
			if (value.trim().length === 0) return;
			isSending = true;
			await supabase
				.from('live_feed_chat')
				.insert({
					chat: value.trim(),
					live_feed: $liveFeed!.id,
					sender_id: $authUserData!.id
				})
				.throwOnError();
			isSending = false;
			value = '';
		} catch (e) {
			console.log('error', e);
			isSending = false;
			newToast({
				message: 'Failed to send the message',
				type: 'error'
			});
		}
	}

	function handleKeyDown(e: KeyboardEvent) {
		if (e.key === 'Enter' && e.shiftKey === true) {
			e.preventDefault();
			submitChat();
		}
	}

	async function fetchChats() {
		const { data: last20Data } = await supabase
			.from('live_feed_chat')
			.select(chatWithSenderData)
			.order('created_at', { ascending: true })
			.limit(20)
			.returns<ChatWithSenderData[]>();

		chats = last20Data || [];
		isLoading = false;
	}

	$effect(() => {
		fetchChats();
	});

	supabase
		.channel('chat')
		.on(
			'postgres_changes',
			{
				event: '*',
				schema: 'public',
				table: 'live_feed_chat',
				filter: `live_feed=eq.${$liveFeed!.id}`
			},
			fetchChats
		)
		.subscribe();
</script>

<div class="sidebar-chat-live">
	<Heading2 content="Chat"></Heading2>
	<div class="chat-container">
		{#if isLoading}
			<div class="loader-container mt-2">
				<Loader />
			</div>
		{:else}
			{#each chats as chat}
				<div class="chat-item">
					<span class="username">{chat.sender_id.username}</span>
					<span class="chat">: {chat.chat}</span>
				</div>
			{/each}
		{/if}
	</div>
	<div class="input-chat">
		<textarea
			class="input-chat-text"
			placeholder="Type your message here..."
			bind:value
			onkeydown={handleKeyDown}
		>
		</textarea>
		<button class="input-chat-btn" onclick={submitChat}>
			{#if isSending}
				<div class="loader-icon">
					<Loader />
				</div>
			{:else}
				Send
			{/if}
		</button>
	</div>
</div>

<style lang="postcss">
	.loader-icon {
		@apply w-full flex justify-center;
	}
	.sidebar-chat-live {
		@apply flex flex-col h-full;
		@apply px-2;
	}
	.chat-container {
		width: 100%;
		height: stretch;
		overflow: scroll;
	}
	.input-chat {
		@apply flex flex-col justify-end;
		@apply pt-1;
	}
	.input-chat-text {
		@apply rounded;
		@apply border border-light-gray;
		@apply bg-transparent text-white;
		field-sizing: content;
		min-height: 40px;
		max-height: 120px;
		@apply w-full;
		@apply outline-none;
		overflow: scroll;
		@apply focus-within:bg-secondary-dark;
		@apply px-2;
	}
	.input-chat-btn {
		width: 100px;
		@apply self-end;
		@apply my-1;
		@apply rounded;
		@apply bg-primary hover:bg-primary-dark;
		@apply py-1;
	}
	.chat-item {
		@apply text-sm;
	}
	.username {
		@apply font-bold;
		@apply text-primary;
	}
</style>
