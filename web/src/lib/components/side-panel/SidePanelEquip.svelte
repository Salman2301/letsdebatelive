<script lang="ts">
	import { sidePanelHeader } from './side-panel.store';

	import NoFeedCard from '$lib/components/feed/NoFeedCard.svelte';
	import Button from '$lib/components/button/Button.svelte';
	import Heading2 from '../form/Heading2.svelte';
	import Heading3 from '$lib/components/form/Heading3.svelte';
	import BubbleError from '$lib/components/bubble/BubbleError.svelte';
	import VolumeProgress from '$lib/components/mic/VolumeProgress.svelte';

	import { getContext, onMount } from 'svelte';
	import {
		DeviceScreen,
		DeviceScreenDisabled,
		DeviceCamera,
		DeviceCameraDisabled
	} from '$lib/components/icon';

	import {
		errorScreenShareFeed,
		errorWebcamFeed,

		toggleMedia,

		micDeviceId,
		micWavPercent,

		screenShareEnable,
		screenShareStream,

		speakerDeviceId,
		speakerEnabled,
		speakerIsPlaying,

		webcamDeviceId,
		webcamEnable,
		webcamStream,

		webcamIsPlaying,
		screenShareIsPlaying
	} from '$src/lib/stores/media.store';
	import DeviceMainFeed from '../feed/DeviceMainFeed.svelte';
	import { extractAndPlay } from '$src/lib/utils/sampleSound.utils';
	import { getDevices } from '$src/lib/utils/media.utils';

	$sidePanelHeader = 'Equipments';

	let videoInstance: HTMLVideoElement;
	let videoScreenShareInstance: HTMLVideoElement;

	let kindMapDevices: Record<MediaDeviceKind, MediaDeviceInfo[]> = {
		audioinput: [],
		videoinput: [],
		audiooutput: []
	};


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
		if(!$webcamDeviceId) $webcamDeviceId = kindMapDevices['videoinput']?.[0]?.deviceId;
		if(!$speakerDeviceId) $speakerDeviceId = kindMapDevices['audiooutput']?.[0]?.deviceId;
		if(!$micDeviceId) $micDeviceId = kindMapDevices['audioinput']?.[0]?.deviceId;

		if($webcamStream) {
			videoInstance.srcObject = $webcamStream;
			videoInstance.play();
		}

		if ($screenShareStream) {
			videoScreenShareInstance.srcObject = $screenShareStream;
			videoScreenShareInstance.play();
		}
	});
</script>

<div class="flex justify-center w-full">
	<DeviceMainFeed />
</div>

<div class="mb-3">
	<Heading2 content="Advance" textAlign="left" />
</div>

<div class="video-feed">
	<Heading3 content="Webcam" />
	<div class="video-title-container">
		<div class="video-container">
			{#if !$webcamIsPlaying}
				<NoFeedCard label="No web camera feed" feedType="profile" onclick={()=>toggleMedia("webcam")} />
			{/if}

			<video bind:this={videoInstance} class="video-el" autoplay playsinline>
				<track kind="captions" />
			</video>
		</div>
		<div class="header">
			<button onclick={()=>toggleMedia("webcam")} class="btn-icon">
				{#if $webcamIsPlaying}
					<DeviceCamera />
				{:else}
					<DeviceCameraDisabled />
				{/if}
			</button>
			<select bind:value={$webcamDeviceId}>
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
	<div class="mt-2">
		<Heading3 content="Screenshare" />
	</div>
	<div class="video-title-container">
		<div class="video-container">
			<video bind:this={videoScreenShareInstance} class="video-el" autoplay playsinline>
				<track kind="captions" />
			</video>
			{#if !$screenShareIsPlaying}
				<NoFeedCard label="No screen share feed" onclick={()=>toggleMedia("screenShare")} feedType="screen" />
			{/if}
		</div>

		<div class="header">
			<button onclick={()=>toggleMedia("screenShare")} class="btn-icon">
				{#if !$screenShareEnable}}
					<DeviceScreen />
				{:else}
					<DeviceScreenDisabled />
				{/if}
			</button>
			<button onclick={()=>toggleMedia("screenShare")}>Screen share</button>
			<div class="info-btn">
				<BubbleError show={!!$errorScreenShareFeed} message={$errorScreenShareFeed} />
			</div>
		</div>
	</div>
</div>

<div class="audio-container">
	<div class="audio-mic-container">
		<Heading3 content="Microphone" textAlign="center" />
		<div class="audio-select-container">
			<select class="select-audio" bind:value={$micDeviceId}>
				{#each kindMapDevices['audioinput'] as device}
					<option value={device.deviceId}>{device.label}</option>
				{/each}
			</select>

			<VolumeProgress percent={$micWavPercent} bar={16} />
		</div>
	</div>

	<div class="audio-speaker-container">
		<Heading3 content="Speaker" textAlign="center" />
		<div class="audio-select-container">
			<select class="select-audio" bind:value={$speakerDeviceId}>
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
		@apply flex flex-col items-center justify-center;
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
		/* @apply flex flex-col; */
		display: flex;
		justify-content: center;
		position: relative;
	}
	.video-el {
		aspect-ratio: 16 / 9;
		width: 330px;
	}

	select {
		@apply bg-black;
		width: 290px;
		height: 40px;
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
		@apply my-8;
	}
</style>
