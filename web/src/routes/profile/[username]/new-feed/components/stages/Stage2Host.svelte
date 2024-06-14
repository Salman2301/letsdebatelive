<script lang="ts">
	import Button from '$lib/components/button/Button.svelte';
	import Heading3 from '$lib/components/form/Heading3.svelte';
	import Heading2 from '$src/lib/components/form/Heading2.svelte';
	import Input from '$src/lib/components/form/input/Input.svelte';
	import Label from '$src/lib/components/form/input/Label.svelte';
	import NoFeedCard from '$lib/components/feed/NoFeedCard.svelte';
	import BubbleError from '$lib/components/bubble/BubbleError.svelte';
	import VolumeProgress from '$lib/components/mic/VolumeProgress.svelte';

	import { onMount } from 'svelte';
	import { authUserData } from '$lib/stores/auth.store';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	import { getSupabase } from '$lib/supabase';

	import {
		DeviceCamera,
		DeviceCameraDisabled,
		DeviceScreen,
		DeviceScreenDisabled
	} from '$src/lib/components/icon';
	import { PageCtx } from '$src/lib/context';
	import { getDevices } from '$lib/utils/media.utils';
	import {
		errorScreenShareFeed,
		errorWebcamFeed,
		toggleMedia,
		micDeviceId,
		micWavPercent,
		screenShareEnable,
		screenShareStream,
		speakerDeviceId,
		speakerIsPlaying,
		webcamDeviceId,
		webcamEnable,
		webcamStream,
		webcamIsPlaying,
		screenShareIsPlaying
	} from '$src/lib/stores/media.store';
	import { extractAndPlay } from '$lib/utils/sampleSound.utils';
	import DeviceMainFeed from '$src/lib/components/feed/DeviceMainFeed.svelte';

	let videoInstance: HTMLVideoElement;
	let videoScreenShareInstance: HTMLVideoElement;

	let kindMapDevices: Record<MediaDeviceKind, MediaDeviceInfo[]> = $state({
		audioinput: [],
		videoinput: [],
		audiooutput: []
	});

	const supabase = getSupabase();

	const pageCtx = new PageCtx('new-feed');
	const liveFeed = pageCtx.get('liveFeed');
	const teams = pageCtx.get('teams');
	const hostParticipant = pageCtx.get('hostParticipant');

	let hostDisplayName = $state($hostParticipant?.display_name || $authUserData?.displayName || '');
	let hostTeamId = $state($hostParticipant?.team || null);

	webcamStream.subscribe((stream) => {
		if (stream && videoInstance) {
			videoInstance.srcObject = stream;
			videoInstance.play();
		}
	});
	screenShareStream.subscribe((stream) => {
		if (stream && videoInstance) {
			videoScreenShareInstance.srcObject = stream;
			videoScreenShareInstance.play();
		}
	});

	onMount(async () => {
		kindMapDevices = await getDevices();
		if (!$webcamDeviceId) $webcamDeviceId = kindMapDevices['videoinput']?.[0]?.deviceId;
		if (!$speakerDeviceId) $speakerDeviceId = kindMapDevices['audiooutput']?.[0]?.deviceId;
		if (!$micDeviceId) $micDeviceId = kindMapDevices['audioinput']?.[0]?.deviceId;

		if ($webcamStream) {
			videoInstance.srcObject = $webcamStream;
			videoInstance.play();
		}

		if ($screenShareStream) {
			videoScreenShareInstance.srcObject = $screenShareStream;
			videoScreenShareInstance.play();
		}
	});

	export async function beforeOnNext() {
		try {
			// add host to the current  participants table
			// Create a live feed If the feed didn't exist in the store
			//
			if ($liveFeed?.id) {
				// Move this after the user created team
				const { data: hostData, error: hostError } = await supabase
					.from('live_feed_participants')
					.update({
						cam_available: Boolean($errorWebcamFeed || $webcamEnable),
						mic_available: kindMapDevices.audioinput.length > 0,
						speaker_available: kindMapDevices.audiooutput.length > 0,
						screenshare_available: Boolean($errorScreenShareFeed || $screenShareEnable),

						cam_enable: $webcamEnable,
						mic_enable: kindMapDevices.audioinput.length > 0, // TODO: set it as mute or unmute
						speaker_enable: kindMapDevices.audiooutput.length > 0,

						cam_id: $webcamDeviceId,
						speaker_id: $speakerDeviceId,
						mic_id: $micDeviceId!,

						display_name: hostDisplayName,
						team: hostTeamId
					})
					.eq('live_feed', $liveFeed.id)
					.eq('participant_id', $hostParticipant?.participant_id!)
					.select();

				if (hostError || !hostData) {
					console.error(hostError);
					throw new Error('Failed to create database participants!');
				}

				$hostParticipant = hostData[0];
			}

			return true;
		} catch (e) {
			console.error(e);
			newToast({
				type: 'error',
				message: 'Something went wrong!'
			});
			throw new Error('Failed to create new feed');
		}
	}
</script>

<div class="flex justify-center mb-10">
	<div class="main-setting">
		<div class="in-display-name">
			<Input
				rounded="sm"
				title="Display name"
				width="240px"
				placeholder="Enter title for your live feed"
				bind:value={hostDisplayName}
				testId="in-display-name"
			/>
		</div>

		<Label label="Team">
			<select name="team" class="team-select" bind:value={hostTeamId}>
				{#each $teams as team}
					<option value={team.id}>{team.title}</option>
				{/each}
			</select>
		</Label>

		<div class="flex justify-center my-2">
			<DeviceMainFeed />
		</div>
	</div>
</div>

<div class="my-4">
	<Heading2 content="Adavance setup" textAlign="center"></Heading2>
</div>

<div class="video-feed">
	<div class="video-title-container">
		<div class="video-container">
			{#if !$webcamIsPlaying}
				<NoFeedCard
					label="No web camera feed"
					feedType="profile"
					onclick={() => toggleMedia('webcam')}
				/>
			{/if}

			<video bind:this={videoInstance} class="video-el" autoplay playsinline>
				<track kind="captions" />
			</video>
		</div>
		<div class="header">
			<button onclick={() => toggleMedia('webcam')} class="btn-icon">
				{#if $webcamEnable}
					<DeviceCamera />
				{:else}
					<DeviceCameraDisabled />
				{/if}
			</button>
			<select class="device-select" bind:value={$webcamDeviceId}>
				{#each kindMapDevices['videoinput'] as device}
					<option value={device.deviceId}>{device.label}</option>
				{:else}
					<option disabled>No device found</option>
				{/each}
			</select>
			<div class="info-btn">
				<BubbleError show={!!$errorWebcamFeed} message={$errorWebcamFeed} />
			</div>
		</div>
	</div>
	<div class="video-title-container">
		<div class="video-container">
			<video bind:this={videoScreenShareInstance} class="video-el" autoplay playsinline>
				<track kind="captions" />
			</video>
			{#if !$screenShareIsPlaying}
				<NoFeedCard
					label="No screen share feed"
					onclick={() => toggleMedia('screenShare')}
					feedType="screen"
				/>
			{/if}
		</div>

		<div class="header">
			<button onclick={() => toggleMedia('screenShare')} class="btn-icon">
				{#if $screenShareEnable}
					<DeviceScreen />
				{:else}
					<DeviceScreenDisabled />
				{/if}
			</button>
			<span>Screen share</span>
			<div class="info-btn">
				<BubbleError show={!!$errorScreenShareFeed} message={$errorScreenShareFeed} />
			</div>
		</div>
	</div>
</div>

<div class="audio-container">
	<div class="audio-mic-container">
		<Heading3 content="MICROPHONE" />
		<div class="audio-select-container">
			<select class="device-select select-audio" bind:value={$micDeviceId}>
				{#each kindMapDevices['audioinput'] as device}
					<option value={device.deviceId}>{device.label}</option>
				{/each}
			</select>

			<VolumeProgress percent={$micWavPercent} bar={36} />
		</div>
	</div>

	<div class="audio-speaker-container">
		<Heading3 content="SPEAKER" />
		<div class="audio-select-container">
			<select class="device-select select-audio" bind:value={$speakerDeviceId}>
				{#each kindMapDevices['audiooutput'] as device}
					<option value={device.deviceId}>{device.label}</option>
				{/each}
			</select>
			<Button
				label={$speakerIsPlaying ? 'Playing... Stop?' : 'Play Sound'}
				onclick={extractAndPlay}
				color={$speakerIsPlaying ? 'accent-red' : 'secondary'}
				fillType={$speakerIsPlaying ? 'solid' : 'outline-solid'}
			/>
		</div>
	</div>
</div>

<style lang="postcss">
	.video-feed {
		@apply flex justify-center gap-10;
	}

	.main-setting {
		@apply flex justify-between items-center;
		width: 700px;
	}

	.header {
		@apply flex items-center justify-between gap-1;
		padding: 0px 10px;
		@apply bg-black;
	}
	.video-title-container {
		@apply flex flex-col;
		@apply border;
		@apply overflow-hidden;
		border-radius: 4px;
		border: 1px solid var(--color-light-gray);
		width: 330px;
	}
	.video-container {
		width: 330px;
		overflow: hidden;
		display: flex;
		justify-content: center;
		position: relative;
	}
	.video-el {
		aspect-ratio: 16 / 9;
		width: 330px;
	}

	.device-select {
		@apply bg-black;
		width: 290px;
		height: 40px;
	}
	.device-select:hover {
		@apply border-white;
	}

	.btn-icon {
		width: 40px;
		height: 40px;
		display: flex;
		justify-content: center;
		align-items: center;
		@apply text-transparent;
	}
	.btn-icon:hover,
	.btn-icon:focus {
		outline: 0;
	}

	.info-btn {
		width: 20px;
		height: 40px;
		display: flex;
		justify-content: center;
		align-items: center;
	}

	.audio-container {
		max-width: 700px;
		margin: 0 auto;
		margin-top: 30px;
	}
	.select-audio {
		width: 240px;
		border: 1px solid var(--color-light-gray);
		padding: 10px 4px;
		border-radius: 4px;
		font-size: 12px;
	}

	.audio-select-container {
		@apply flex items-center justify-start gap-4;
		@apply mt-2;
	}
	.audio-speaker-container {
		@apply mt-8;
	}

	.in-display-name {
		@apply flex items-center justify-center;
	}

	.team-select {
		@apply rounded;
		@apply border border-light-gray;
		width: 180px;
		height: 46px;
		@apply bg-primary-dark;
	}

	.team-select:hover {
		@apply border-white;
	}
</style>
