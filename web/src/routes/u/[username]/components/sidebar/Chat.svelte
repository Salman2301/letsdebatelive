<script lang="ts">
	import { closeModal, currentModal, openModal } from "$lib/components/modal/modal.store";
	import { newToast } from "$src/lib/components/toast/Toast.svelte";
	import { getLiveRoomCtx } from "$src/lib/context/live-page";

	import type { Tables } from "$src/lib/schema/database.types";

	const ctx = getLiveRoomCtx("pageDataProps");

	function handleOpenTeamSelect() {
		if( !ctx ) {
			return newToast(({
				type: "error",
				message: "Failed to get the ctx"
			}))
		}
		openModal({
			key: "team-select", 
			data: {
				teams: ctx.teams,
				onSelect: (team) =>{
					closeModal()
				}
			}
		})
	}
</script>

<div class="chat-container">
	<div class="chat-items">
		<div class="chat-item">
			<span class="chat-item-username">username</span><span class="chat-item-content"
				>This is a content of the chat user</span
			>
		</div>
		<div class="chat-input-container">
			<textarea class="chat-text"></textarea>
      <div class="chat-footer">
        <div class="left">
          <button
						class="team-circle"
						onclick={()=>handleOpenTeamSelect()}
					>
            <div class="circle-icon"></div>
            <span>Change team?</span>
          </button>
        </div>
  			<button
					class="btn-submit"
				>Submit</button>
      </div>
		</div>
	</div>
</div>

<style lang="postcss">
	.chat-container {
		@apply flex-grow;
		@apply overflow-auto;
		@apply flex flex-col justify-between;
	}

	.chat-items {
		@apply w-full;
		@apply px-2;
	}
  button {
    @apply flex justify-center items-center gap-1;
    &:hover span {
      opacity: 1;
    }
  }

  button span {
    @apply text-xs ;
    opacity: 0;

  }
  .circle-icon {
    width: 15px;
    height: 15px;
    border-radius: 100%;
    @apply bg-team-a;
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
  .chat-footer {
    @apply flex justify-between;
    @apply my-1;
  }
	.btn-submit {
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
</style>
