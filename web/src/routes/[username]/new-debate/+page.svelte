<script lang="ts">
	import Button from '$lib/components/button/Button.svelte';
	import VolumeProgress from '$lib/components/mic/VolumeProgress.svelte';
	import { onMount } from 'svelte';
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import Heading3 from '$lib/components/form/Heading3.svelte';
	import BubbleError from '$lib/components/bubble/BubbleError.svelte';
	import WebCamDisabled from './icons/WebCamDisabled.svelte';
	import WebCamEnabled from './icons/WebCamEnabled.svelte';
	import ScreenShareEnabled from './icons/ScreenShareEnabled.svelte';
	import ScreenShareDisabled from './icons/ScreenShareDisabled.svelte';
	import NoFeedCard from './components/NoFeedCard.svelte';

	let errorWebcamFeed: string = '';
	let errorScreenShareFeed: string = '';
	let webcamFeedPlaying: boolean = false;
	let screenSharePlaying: boolean = false;

	let videoInstance: HTMLVideoElement;
	let videoScreenShareInstance: HTMLVideoElement;

	let kindMapDevices: Record<MediaDeviceKind, MediaDeviceInfo[]> = {
		audioinput: [],
		videoinput: [],
		audiooutput: []
	};

	interface SelectOptions {
		label: string;
		value: string;
	}

	async function getDevices(): Promise<SelectOptions[]> {
		const stream = await navigator.mediaDevices.getUserMedia({ audio: true });

		const devices = await navigator.mediaDevices.enumerateDevices();
		devices.sort((a, b) => (a.label.toLowerCase() > b.label.toLowerCase() ? 1 : -1));

		for (const key of Object.keys(kindMapDevices)) {
			kindMapDevices[key as MediaDeviceKind] = devices.filter((device) => device.kind === key);
		}

		// We need to call getUserMedia media in order to enumerateDevices with labels.
		// Then we have to stop the audio track, since Firefox thinks we're still using
		// the stream if we try to switch devices later.
		for (const track of stream.getAudioTracks()) {
			track.stop();
		}

		return devices.map((e) => ({ label: e.label, value: e.deviceId }));
	}

	async function toggleWebCam() {
		try {
			if (!webcamFeedPlaying) {
				await playWebCam();
				webcamFeedPlaying = true;
			} else {
				if (videoInstance && videoInstance.srcObject) {
					const streams = videoInstance.srcObject as MediaStream;
					streams.getTracks().forEach((str) => str.stop());
				}
				webcamFeedPlaying = false;
			}
		} catch (e) {
			console.error(e);
			webcamFeedPlaying = false;
		}
	}

	async function toggleScreenShare() {
		try {
			if (!screenSharePlaying) {
				await playScreenShare();
				screenSharePlaying = true;
			} else {
				if (videoScreenShareInstance && videoScreenShareInstance.srcObject) {
					const streams = videoInstance.srcObject as MediaStream;
					streams.getTracks().forEach((str) => str.stop());
				}
				screenSharePlaying = false;
			}
		} catch (e) {
			console.error(e);
			screenSharePlaying = false;
		}
	}

	async function playScreenShare() {
		try {
			let feedNotAvailable = !(navigator.mediaDevices && navigator.mediaDevices.getDisplayMedia);
			if (feedNotAvailable) errorScreenShareFeed = 'Unsupported browser try different browser';

			const stream = await navigator.mediaDevices.getDisplayMedia({ video: true });
			errorScreenShareFeed = '';
			videoScreenShareInstance.srcObject = stream;
			videoScreenShareInstance.play();

			stream.getVideoTracks()[0].onended = function () {
				screenSharePlaying = false;
			};
		} catch (e) {
			errorScreenShareFeed = 'Permission denied!';
			console.error(e);
			throw e;
		}
	}

	async function playWebCam() {
		try {
			let feedNotAvailable = !(navigator.mediaDevices && navigator.mediaDevices.getUserMedia);
			if (feedNotAvailable) errorWebcamFeed = 'Unsupported browser try different browser';

			const stream = await navigator.mediaDevices.getUserMedia({ video: true });
			errorWebcamFeed = '';
			videoInstance.srcObject = stream;
			videoInstance.play();

			stream.getVideoTracks()[0].onended = function () {
				webcamFeedPlaying = false;
			};
		} catch (e) {
			errorWebcamFeed = 'Permission denied!';
			console.error(e);
			throw e;
		}
	}

	onMount(async () => {
		await getDevices();
	});
</script>

<Heading2 content="New debate" textAlign="center" />

<div class="video-feed">
	<div class="video-title-container">
		<div class="video-container">
			{#if !webcamFeedPlaying}
				<NoFeedCard label="No web camera feed" />
			{/if}

			<video bind:this={videoInstance} class="video-el" autoplay playsinline>
				<track kind="captions" />
			</video>
		</div>
		<div class="header">
			<button on:click={toggleWebCam} class="btn-icon">
				{#if webcamFeedPlaying}
					<WebCamEnabled />
				{:else}
					<WebCamDisabled />
				{/if}
			</button>
			<select>
				{#each kindMapDevices['videoinput'] as device}
					<option>{device.label}</option>
				{:else}
					<option disabled>No device found</option>
				{/each}
			</select>
			<div class="info-btn">
				<BubbleError show={!!errorWebcamFeed} message={errorWebcamFeed} />
			</div>
		</div>
	</div>
	<div class="video-title-container">
		<div class="video-container">
			<video bind:this={videoScreenShareInstance} class="video-el" autoplay playsinline>
				<track kind="captions" />
			</video>
			{#if !screenSharePlaying}
				<NoFeedCard label="No screen share feed" />
			{/if}
		</div>

		<div class="header">
			<button on:click={toggleScreenShare} class="btn-icon">
				{#if screenSharePlaying}
					<ScreenShareEnabled />
				{:else}
					<ScreenShareDisabled />
				{/if}
			</button>
			<span>Screen share</span>
			<div class="info-btn">
				<BubbleError show={!!errorScreenShareFeed} message={errorScreenShareFeed} />
			</div>
		</div>
	</div>
</div>

<div class="audio-container">
	<div class="audio-mic-container">
		<Heading3 content="MICROPHONE" />
		<div class="audio-select-container">
			<select class="select-audio">
				{#each kindMapDevices['audioinput'] as device}
					<option value={device.deviceId}>{device.label}</option>
				{/each}
			</select>

			<VolumeProgress />
		</div>
	</div>

	<div class="audio-speaker-container">
		<Heading3 content="SPEAKER" />
		<div class="audio-select-container">
			<select class="select-audio">
				{#each kindMapDevices['audiooutput'] as device}
					<option value={device.deviceId}>{device.label}</option>
				{/each}
			</select>

			<Button label="Test Speaker" />
		</div>
	</div>
</div>

<style lang="postcss">
	.video-feed {
		@apply flex justify-center gap-10;
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

	select {
		@apply bg-black;
		width: 290px;
	}

	.btn-icon {
		width: 40px;
		height: 40px;
		display: flex;
		justify-content: center;
		align-items: center;
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
		padding: 10px 0px;
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
</style>
