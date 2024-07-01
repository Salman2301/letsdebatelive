<script context="module" lang="ts">
  import { derived, writable, type Readable, type Writable } from "svelte/store";
  
  type PromptItem = {
    question: string;
    yesLabel?: string;
    noLabel?: string;
    onYes?:()=>void;
    onNo?:()=>void;
    type?: "danger" | "default";
  }
  const promptItem: Writable<PromptItem | null> = writable(null);
  
  const showPrompt: Readable<boolean> = derived(promptItem, $promptItem=>!!$promptItem);
  
  export function newPrompt(newItem: PromptItem) {
    promptItem.set(newItem);
  }
  
</script>

<script lang="ts">
	import CloseX from "../icon/CloseX.svelte";
	import { escape } from "$src/lib/action/escape";


  function handleYes() {
    $promptItem?.onYes?.();
    $promptItem = null;
  }

  function handleNo() {
    $promptItem?.onNo?.();
    $promptItem = null;
  }
 
</script>


{#if $showPrompt}
<div class="overlay" use:escape={()=>$promptItem = null}>
  <div class="prompt-container">
    <div class="header">
      <button onclick={handleNo}>
        <CloseX />
      </button>
    </div>

    <div class="question">
      {$promptItem?.question}
    </div>

    <div class="action">
      <button
        onclick={handleNo}
      >
        {$promptItem?.noLabel || "No"}
      </button>
      <button
        onclick={handleYes}
        class:danger={$promptItem?.type === "danger"}
        class:default={!$promptItem?.type || $promptItem.type==="default"}
      >
        {$promptItem?.yesLabel || "Yes"}
      </button>
      
    </div>
  </div>
</div>

{/if}

<style lang="postcss">
  .overlay {
    z-index: 999;
    @apply flex flex-col items-center justify-center;
    @apply bg-primary-dark;
    @apply absolute;
    @apply w-full h-full;
    @apply bg-black/60;
  }
  .prompt-container {
    @apply bg-primary-dark;
    @apply border border-light-gray;
    @applt rounded;
    min-width: 400px;
    max-width: 700px;
    @apply px-4 py-4;
  }
  .header {
    @apply flex w-full justify-end;
    @apply mb-3;
  }
  .question {
    @apply text-xl;
  }
  .action {
    @apply flex justify-center gap-4;
    @apply pt-2;
    button {
      @apply border border-light-gray rounded;
      @apply px-4 py-2;
      &:hover {
        @apply border-white;
        @apply bg-light-gray;
        &.danger {
          @apply border-red-500;
          @apply bg-red-500/20;
        }
        &.default {
          @apply border-primary;
          @apply bg-primary/20;
        }
      }
    }
  }

</style>