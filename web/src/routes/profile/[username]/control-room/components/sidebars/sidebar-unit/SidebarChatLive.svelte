<script lang="ts">
	import EmojiBoard, { type EmojiItem } from '$src/lib/components/emoji-board/EmojiBoard.svelte';
	import Heading2 from '$src/lib/components/form/Heading2.svelte';
	import Loader from '$src/lib/components/icon/Loader.svelte';
	import { newToast } from '$src/lib/components/toast/Toast.svelte';
	import { PageCtx } from '$src/lib/context';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { getSupabase } from '$src/lib/supabase';
	import { convetToHtml } from '$src/lib/utils/html.utils';
	import { onDestroy, tick } from 'svelte';

	import { chatWithSenderData, type ChatWithSenderData } from '$src/lib/types';

	// User able to popup the chat
	// User can see multiple chats from different broadcasts
	// User can
	let isLoading: boolean = $state(true);
	let isSending: boolean = $state(false);
	let chats: ChatWithSenderData[] = $state([]);
	const supabase = getSupabase();

	let textAreaInstance: HTMLTextAreaElement;

	const pageCtx = new PageCtx('control-room');
	const liveFeed = pageCtx.get('ctx_table$live_feed');

	let value: string = $state('');

	let intervalId: NodeJS.Timeout;
	let scrollContainer: HTMLDivElement;
	let scrollStream: boolean = $state(true);
	let maxChatLen: number = $state(80);
	let hasScrollbar: boolean = $state(false);

	let lastCaretPos: number = $state(0);

	$effect(() => {
		fetchChats();
		// mockChat();	
		scrollContainer.addEventListener("wheel", handleWheel);
	});

	function mockChat() {
		let i = 0;
		intervalId = setInterval(async () => {
			balancePush([{...chats[0], chat: "test " + i}]);
			await tick();
			if(scrollStream) scrollToEnd();
			i ++;
		}, 300);
	}

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
			.order('created_at', { ascending: false })
			.limit(100)
			.returns<ChatWithSenderData[]>();

		chats = last20Data?.reverse() || [];
		await tick()

		if(scrollStream) scrollToEnd();
		isLoading = false;
	}

	function handleWheel(e: WheelEvent) {
		if (e.deltaY < 0) {
			scrollStream = false;
		}
		else {
			// user try to scoll to the bottom of the chat
			// contiue streaming if the container hit the bottom
			const { scrollHeight, scrollTop, clientHeight } = scrollContainer;
			if ( ( scrollHeight - scrollTop ) === clientHeight) {
				handleContinueScroll();
			}
		}
	}

	function handleContinueScroll() {
		scrollStream = true;
		scrollToEnd();
	}

	function balancePush(newChats: ChatWithSenderData[]) {
		let oldChats: ChatWithSenderData[] = chats;
		if (scrollStream && chats.length > maxChatLen) {
			oldChats = chats.slice(-maxChatLen);
		}
		chats = [...oldChats, ...newChats];
		hasScrollbar = scrollContainer.scrollHeight > scrollContainer.clientHeight;
		if(scrollStream) scrollToEnd();
	}

	function scrollToEnd() {
		scrollContainer.scrollTop = scrollContainer.scrollHeight;
	}

	onDestroy(() => {
		clearInterval(intervalId);
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

		function handleEmojiSelected(emoji: EmojiItem) {
			value = value.slice(0, lastCaretPos) + emoji.unicode + value.slice(lastCaretPos);
			lastCaretPos += emoji.unicode.length;
			textAreaInstance.selectionStart = lastCaretPos;
			textAreaInstance.selectionEnd = lastCaretPos;
		}
</script>

<div class="sidebar-chat-live">
	<div class="heading">
		<Heading2 content="Chat"></Heading2>
	</div>
	<div
		class="chat-container"
		bind:this={scrollContainer}
	>
		{#if isLoading}
			<div class="loader-container mt-2">
				<Loader />
			</div>
		{:else}
			{#each chats as chat}
				<div class="chat-item">
					<span class="username">{chat.sender_id.username}</span>
					<span>:</span>
					<span class="chat">{@html convetToHtml(chat.chat)}</span>
				</div>
			{/each}
		{/if}
	</div>
	<div class="input-chat">
		{#if hasScrollbar && !scrollStream}
			<button
				class="stream-scroll-btn"
				onclick={handleContinueScroll}
			>
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" transform="scale(1.4)" class="bi bi-pause" viewBox="0 0 16 16">
					<path d="M6 3.5a.5.5 0 0 1 .5.5v8a.5.5 0 0 1-1 0V4a.5.5 0 0 1 .5-.5m4 0a.5.5 0 0 1 .5.5v8a.5.5 0 0 1-1 0V4a.5.5 0 0 1 .5-.5"/>
				</svg>
				Chat Streaming is Paused
			</button>
		{/if}
		<textarea
			class="input-chat-text"
			placeholder="Type your message here..."
			bind:value
			bind:this={textAreaInstance}
			onblur={()=> lastCaretPos = textAreaInstance.selectionStart}
			onkeydown={handleKeyDown}
		>
		</textarea>
		<div class="footer">
			<EmojiBoard onEmojiSelected={handleEmojiSelected} />
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
</div>

<style lang="postcss">
	.loader-icon {
		@apply w-full flex justify-center;
	}

	.heading {
		@apply flex items-center my-4 justify-between;
	}
	.sidebar-chat-live {
		@apply flex flex-col h-full;
		@apply px-4;
	}
	.chat-container {
		width: 100%;
		height: stretch;
		scrollbar-color: rgb(var(--color-primary)) black;
		overflow: scroll;
	}

	.stream-scroll-btn {
		@apply border border-light-gray;
		@apply px-4 py-2;
		@apply flex items-center justify-center gap-2;
		&:hover {
			@apply underline;
		}
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
	.footer {
		@apply flex gap-2 justify-end;
		@apply w-full
	}
	.input-chat-btn {
		width: 100px;
		@apply my-1;
		@apply rounded;
		@apply bg-primary hover:bg-primary-dark;
		@apply py-1;
	}
	.chat-item {
		@apply text-white;
	}
	:global(.chat a) {
		@apply underline; 
	}
	.username {
		@apply font-bold;
		@apply text-primary;
	}
</style>
