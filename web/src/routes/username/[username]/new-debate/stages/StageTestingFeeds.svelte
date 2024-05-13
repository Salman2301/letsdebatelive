<script lang="ts">
	import Button from '$lib/components/button/Button.svelte';
	import VolumeProgress from '$lib/components/mic/VolumeProgress.svelte';
	import { onMount } from 'svelte';
	import Heading3 from '$lib/components/form/Heading3.svelte';
	import BubbleError from '$lib/components/bubble/BubbleError.svelte';
	import { ScreenShareDisabled, ScreenShareEnabled, WebCamDisabled, WebCamEnabled } from '../icons';
	import NoFeedCard from '../components/NoFeedCard.svelte';

	let errorWebcamFeed: string = '';
	let errorScreenShareFeed: string = '';
	let webcamFeedPlaying: boolean = false;
	let screenSharePlaying: boolean = false;

	let webCamDeviceId: string;
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
					const streams = videoScreenShareInstance.srcObject as MediaStream;
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

			const stream = await navigator.mediaDevices.getUserMedia({
				video: { deviceId: webCamDeviceId }
			});
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

	let micVolume = 0;
	let micDeviceId: string = 'default';

	let micCtx: AudioContext;
	let micStream: MediaStream | null;
	let currentMicSource: MediaStreamAudioSourceNode;
	let clearIntervalMic: NodeJS.Timeout;

	let speakerCtx: AudioContext;
	let speakerDeviceId: string = 'default';
	let speakerNode: GainNode;
	let audioBuffer: AudioBufferSourceNode | null;

	onMount(async () => {
		micCtx = new (window.AudioContext || window.webkitAudioContext)();
		speakerCtx = new (window.AudioContext || window.webkitAudioContext)();

		await getDevices();

		micAnalyser();
		webCamDeviceId = kindMapDevices['videoinput']?.[0]?.deviceId;

		speakerNode = speakerCtx.createGain();
		speakerNode.connect(speakerCtx.destination);

		document.addEventListener(
			'click',
			() => {
				if (micCtx.state === 'suspended') micCtx.resume();
				if (speakerCtx.state === 'suspended') speakerCtx.resume();
			},
			{ once: true }
		);
	});

	let decodedAudioData: AudioBuffer;
	async function getDecodedAudioData(): Promise<AudioBuffer> {
		if (decodedAudioData) return decodedAudioData;
		const audioData = await fetch('/sounds/test/guitar.mp3').then((resp) => resp.arrayBuffer());
		decodedAudioData = await speakerCtx.decodeAudioData(audioData);
		return decodedAudioData;
	}

	async function micAnalyser() {
		if (micStream) {
			await Promise.all(micStream.getTracks().map((track) => track.stop()));
			micStream = null;
			clearInterval(clearIntervalMic);
			currentMicSource?.disconnect?.();
		}

		micStream = await navigator.mediaDevices.getUserMedia({
			audio: { deviceId: micDeviceId, echoCancellation: true }
		});

		currentMicSource = micCtx.createMediaStreamSource(micStream);

		let analyser = micCtx.createAnalyser();

		analyser.fftSize = 32;
		let analyserData = new Uint8Array(analyser.frequencyBinCount);

		currentMicSource.connect(analyser);

		function getAnalyserLevel() {
			analyser.getByteFrequencyData(analyserData);
			let sum = 0;
			for (let i = 0; i < analyserData.length; i++) {
				sum += analyserData[i] / 255;
			}
			sum = sum / analyserData.length;
			return sum;
		}

		function updateValue() {
			micVolume = getAnalyserLevel();
			clearIntervalMic = setTimeout(updateValue, 30);
		}

		updateValue();
	}

	let speakerIsPlaying = false;
	async function toggleSound() {
		if (audioBuffer) {
			audioBuffer.stop();
			audioBuffer = null;
			speakerIsPlaying = false;
			return;
		}
		audioBuffer = speakerCtx.createBufferSource();

		let decodedAudioData = await getDecodedAudioData();
		audioBuffer.buffer = decodedAudioData;

		audioBuffer.connect(speakerNode);

		audioBuffer.onended = () => {
			speakerIsPlaying = false;
		};

		speakerIsPlaying = true;
		audioBuffer.start();
	}

	function handleSpeakerChange() {
		speakerNode.disconnect();
		const dest = speakerCtx.createMediaStreamDestination();
		speakerNode.connect(dest);

		const audioOutput = new Audio();
		audioOutput.srcObject = dest.stream;
		audioOutput.setSinkId(speakerDeviceId);

		audioOutput.play();
	}


	export async function beforeOnNext() {
		try {

			return true;
		}
		catch(e) {
			return false;
		}
	}
</script>

<div class="video-feed">
	<div class="video-title-container">
		<div class="video-container">
			{#if !webcamFeedPlaying}
				<NoFeedCard label="No web camera feed" feedType="profile" on:click={toggleWebCam} />
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
			<select bind:value={webCamDeviceId}>
				{#each kindMapDevices['videoinput'] as device}
					<option value={device.deviceId}>{device.label}</option>
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
				<NoFeedCard label="No screen share feed" on:click={toggleScreenShare} feedType="screen" />
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
			<select class="select-audio" bind:value={micDeviceId} on:change={micAnalyser}>
				{#each kindMapDevices['audioinput'] as device}
					<option value={device.deviceId}>{device.label}</option>
				{/each}
			</select>

			<VolumeProgress percent={micVolume} />
		</div>
	</div>

	<div class="audio-speaker-container">
		<Heading3 content="SPEAKER" />
		<div class="audio-select-container">
			<select class="select-audio" bind:value={speakerDeviceId} on:change={handleSpeakerChange}>
				{#each kindMapDevices['audiooutput'] as device}
					<option value={device.deviceId}>{device.label}</option>
				{/each}
			</select>

			<Button
				label={speakerIsPlaying ? 'Playing... Stop?' : 'Play Sound'}
				on:click={toggleSound}
				color={speakerIsPlaying ? 'accent-red' : 'secondary'}
				fillType="{speakerIsPlaying ? "solid": "outline-solid"}"
			/>
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
		height: 40px;
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
</style>
