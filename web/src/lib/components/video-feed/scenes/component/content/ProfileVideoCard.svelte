<script lang="ts">
	import type { Tables } from '$lib/schema/database.types';
	import type { ParticipantsWithUserData } from '$src/lib/types';

	interface Props {
		type?: 'audio' | 'video';
		participant: ParticipantsWithUserData;
	}
	let { type, participant }: Props = $props();

	// Listen for the stream WebRTC
</script>

<div class="card">
	{#if type === "audio"}

		<div class="image-container">
			<div class="circle-icon">
				{#if participant.participant_id.profile_image}
					<img src={participant.participant_id.profile_image} alt="participant profile" />
				{:else}
					{participant.display_name?.[0].toUpperCase() || 'A'}
				{/if}
			</div>
		</div>

		<div class="video-container">
			<video data-participant={participant.participant_id} >
				<track kind="captions">
			</video>
		</div>
	{/if}
	<div class="profile-name">
		{participant?.display_name}
	</div>
</div>

<style lang="postcss">
	.card {
		border: 1px solid white;
		@apply flex flex-col items-center justify-center;
		@apply m-1 p-1;
	}
	.image-container {
		aspect-ratio: 4 / 3;
		width: 200px;
		@apply flex items-center justify-center;
	}
	.video-container {
		aspect-ratio: 4 / 3;
		width: 200px;
	}
	.circle-icon {
		width: 60px;
		height: 60px;
		@apply my-2;
		@apply rounded-full;
		@apply flex items-center justify-center;
		@apply text-center;
		font-size: 32px;
		background-color: white;
		@apply text-secondary-dark;
		@apply overflow-hidden;
	}
</style>
