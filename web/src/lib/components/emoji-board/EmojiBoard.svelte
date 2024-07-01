<script context="module" lang="ts">
  export interface EmojiItem {
    unicode: string;
    name: string;
  }
  export interface EmojiJson {
    categoryName: string;
    categoryIcon: string;
    data: Array<EmojiItem >;
  }
</script>

<script lang="ts">
	import { clickOutside } from "$src/lib/action/clickOutside";

	import { getSupabase } from "$src/lib/supabase";

  const supabase = getSupabase();

  interface Props {
    onEmojiSelected?: (emoji: EmojiJson['data'][0]) => void;
  }

  let { onEmojiSelected }: Props = $props();

  let emojis: EmojiJson[] = $state([]);
  let selectedIndex = $state(0);
  let showEmojis = $state(false);

  $effect(() => {
    fetchEmojisSupbase();
  });


  async function fetchEmojisSupbase() {
    const res = await fetch(`/data/emojis.json`);

    if(!res.ok) {
      console.error({ res });
      return;
    }
    emojis = await res.json();
  }

  function handleKeyDown(e: KeyboardEvent) {
    if (e.key === "Escape") {
      showEmojis = false;
    }
  }
</script>

<svelte:window onkeydown={handleKeyDown} />
<div class="emoji-board" use:clickOutside={()=>(showEmojis = false)}>
  {#if showEmojis}
    <div class="container-board">
      <div class="header-items">
        {#each emojis as item, index}
          <button
            class="header-item"
            class:selected={index === selectedIndex}
            onclick={()=>selectedIndex = index}
          >
            {item.categoryIcon}
          </button>
        {/each}
      </div>
      <div class="emoji-items">
        {#if emojis[selectedIndex]}
          {#each emojis[selectedIndex].data as emoji, index}
            <button
              class="emoji-item"
              onclick={()=>onEmojiSelected?.(emoji)}
            >
              {emoji.unicode}
            </button>
          {/each}
        {/if}
      </div>
      </div>
  
  {/if}
  <button
    onclick={()=>showEmojis = !showEmojis}

    class="emoji-board-button"
    class:open={showEmojis}
  >
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-emoji-smile-fill" viewBox="0 0 16 16">
      <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16M7 6.5C7 7.328 6.552 8 6 8s-1-.672-1-1.5S5.448 5 6 5s1 .672 1 1.5M4.285 9.567a.5.5 0 0 1 .683.183A3.5 3.5 0 0 0 8 11.5a3.5 3.5 0 0 0 3.032-1.75.5.5 0 1 1 .866.5A4.5 4.5 0 0 1 8 12.5a4.5 4.5 0 0 1-3.898-2.25.5.5 0 0 1 .183-.683M10 8c-.552 0-1-.672-1-1.5S9.448 5 10 5s1 .672 1 1.5S10.552 8 10 8"/>
    </svg>
  </button>
</div>

<style lang="postcss">
  .emoji-board {
    position: relative;
  }

  .container-board {
		width: 300px;
		height: 240px;
		border-radius: 4px;
    @apply border border-light-gray;
    position: absolute;
    bottom: 40px;
    right: 10px;

    @apply bg-primary-dark;
	}
	.header-items {
		display: flex;
		margin-bottom: 4px;
		border-radius: 0px;

    @apply border-b border-light-gray;
	}
	.header-item {
		border: 0px;
		aspect-ratio: 1/1;
		width: 100%;
	}
	.selected {
		background-color: #333;
	}

	.emoji-items {
		overflow: scroll;
		width: 100%;
		height: 200px;
    scrollbar-color: #333 black;
    padding: 4px;
	}
	.emoji-item {
		background-color: transparent;
		border: 0;
		width: 28px;
		font-size: 22px;
		aspect-ratio: 1/1;
    &:hover {
      background-color: #333;
      scale: 1.4;
    }
	}
  .emoji-board-button {
    @apply flex items-center justify-center;
    @apply w-10 h-10;
    &:hover, &:focus, &.open {
      outline:none;
      color: yellow;
    }
  }
</style>