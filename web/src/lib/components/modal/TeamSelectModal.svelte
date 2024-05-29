<script lang="ts">
	import Modal from "./Modal.svelte";
	import { currentModalData, type ModalData } from "./modal.store";

	const {
		teams,
		onSelect
	}: ModalData["team-select"] = ($currentModalData || {});

</script>

<Modal title="Select a team">
	<div class="modal-container">
		<p class="font-semibold text-white/50 mb-4">Select one of the team to partcipant in chat / backstage <br> and other activities! during live stream</p>
		{#each (teams || []) as team}
			<button
				onclick={()=>onSelect?.(team)}
			>
				<div
					class="color-team"
					style="background:{team.color}"
				></div>
				{team.title}
			</button>
		{:else}
			<p>No team found!</p>
		{/each}
	</div>
</Modal>

<style lang="postcss">
	.modal-container {
		@apply w-full h-full;
		@apply flex flex-col items-center mt-4;

	}
	button {
		@apply flex gap-4 items-center;
		@apply border border-transparent border-b-light-gray;
		@apply px-2;
		height: 40px;
		width: 280px;
		&:hover {
			@apply border border-white;
		}
	}

	.color-team {
		width: 14px;
		height: 14px;
		border-radius: 100%;
	}

</style>