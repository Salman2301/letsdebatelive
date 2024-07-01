<script lang="ts">
	import { authUserData } from '$src/lib/stores/auth.store';
	import { webcamStream } from '$src/lib/stores/media.store';
	import { getProfileImage } from '$src/lib/utils/profile.utils';
	import { onMount } from 'svelte';

	import type { ParticipantsWithUserData } from '$src/lib/types';

	interface Props {
		type?: 'audio' | 'video';
		participant: ParticipantsWithUserData;
	}

	let { type = "audio", participant }: Props = $props();

	let videoEl: HTMLVideoElement | null = $state(null);

	onMount(()=>{
		if(!$authUserData) return;
		if(!videoEl) return;
		if(!participant.participant_id.id) return;
		if( $authUserData.username === participant.participant_id.username && $webcamStream ) {
			videoEl.srcObject = $webcamStream;
			console.log({ videoEl })
		}
	});

	// Listen for the stream WebRTC
</script>

<div class="card">
	{#if type === "audio"}

		<div class="image-container">
			<div class="circle-icon">
				{#if participant.participant_id.profile_image}
					<img class="img-participant" src={getProfileImage(participant?.participant_id?.profile_image)} alt="participant profile" />
				{:else}
					{participant.display_name?.[0].toUpperCase() || 'A'}
				{/if}
			</div>
		</div>
	{:else}
		<div class="video-container">
			<video
				playsinline
				autoplay
				data-participant={participant.participant_id.id}
				id="video-{participant.participant_id.id}"
				bind:this={videoEl}
			>
				<track kind="captions">
			</video>
		</div>
	{/if}
	<div class="profile-name">
		<p>{participant?.display_name}</p>
	</div>
</div>

<style lang="postcss">
	.card {
		border: 1px solid var(--color-light-gray);
		@apply flex flex-col items-center justify-center;
		@apply m-1;
		@apply relative;
		aspect-ratio: 4 / 3;
	}
	.img-participant {
		width: 100%;
		height: 100%;
	}
	.image-container {
		aspect-ratio: 4 / 3;
		width: 400px;
		@apply flex items-center justify-center;
		border: 1px solid;
		@apply border-none border-light-gray;
		@apply rounded;
	}
	.video-container {
		aspect-ratio: 4 / 3;
		width: 300px;
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
	video {
		width: 100%;
		height: 100%;
		aspect-ratio: 4 / 3;
		background-color: black;
	}
	.profile-name {
		@apply absolute;
		@apply bottom-0;
		@apply left-0;

		@apply flex items-center justify-center;

		background-color: rgba(0, 0, 0, 0.5);
		color: white;

		@apply bg-white;
		@apply px-4;

		p {
			@apply text-black;
		}
	}
</style>
