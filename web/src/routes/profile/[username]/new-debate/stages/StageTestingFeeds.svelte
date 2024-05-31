<script lang="ts">
	import NoFeedCard from '$lib/components/feed/NoFeedCard.svelte';
	import Button from '$lib/components/button/Button.svelte';
	import Heading3 from '$lib/components/form/Heading3.svelte';
	import BubbleError from '$lib/components/bubble/BubbleError.svelte';
	import VolumeProgress from '$lib/components/mic/VolumeProgress.svelte';

	import { getContext, onMount } from 'svelte';
	import { authUserData } from '$lib/stores/auth.store';
	import { ScreenShareDisabled, ScreenShareEnabled, WebCamDisabled, WebCamEnabled } from '../icon';
	import {
		CTX_KEY_HOST_PARTICIPANT,
		CTX_KEY_NEW_DEBATE,
		type CTX_KEY_HOST_PARTICIPANT_TYPE,
		type CTX_KEY_NEW_DEBATE_TYPE
	} from '../new-debate.constant';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	import { getSupabase } from '$lib/supabase';

	import type { Tables } from '$lib/schema/database.types';
	import Input from '$src/lib/components/form/input/Input.svelte';
	import {
		DeviceCamera,
		DeviceCameraDisabled,
		DeviceMic,
		DeviceMicDisabled,
		DeviceScreen,
		DeviceScreenDisabled,
		DeviceSpeaker,
		DeviceSpeakerDisabled
	} from '$src/lib/components/icon';

	let errorWebcamFeed: string = $state('');
	let errorScreenShareFeed: string = $state('');
	let webcamFeedPlaying: boolean = $state(false);
	let screenSharePlaying: boolean = $state(false);

	let inTitle = $state('');

	let webCamDeviceId: string = $state('');
	let videoInstance: HTMLVideoElement;
	let videoScreenShareInstance: HTMLVideoElement;

	let micVolume = $state(0);
	let micDeviceId: string = $state('default');

	let micCtx: AudioContext;
	let micStream: MediaStream | null;
	let currentMicSource: MediaStreamAudioSourceNode;
	let clearIntervalMic: NodeJS.Timeout;

	let speakerCtx: AudioContext;
	let speakerDeviceId: string = $state('default');
	let speakerNode: GainNode;
	let audioBuffer: AudioBufferSourceNode | null;

	let speakerIsPlaying = $state(false);
	let micIsPlaying = $state(false);

	let kindMapDevices: Record<MediaDeviceKind, MediaDeviceInfo[]> = $state({
		audioinput: [],
		videoinput: [],
		audiooutput: []
	});

	interface SelectOptions {
		label: string;
		value: string;
	}

	const supabase = getSupabase(getContext);

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

	function toggleSpeaker() {
		speakerIsPlaying = !speakerIsPlaying;
	}

	function toggleMic() {
		micIsPlaying = !micIsPlaying;
	}

	const liveDebate = getContext<CTX_KEY_NEW_DEBATE_TYPE>(CTX_KEY_NEW_DEBATE);
	const hostParticipant = getContext<CTX_KEY_HOST_PARTICIPANT_TYPE>(CTX_KEY_HOST_PARTICIPANT);
	export async function beforeOnNext() {
		try {
			// add host to the current  participants table
			// Create a live debate If the debate didn't exist in the store
			//
			if (!$liveDebate?.id) {
				const { data, error } = await supabase
					.from('live_debate')
					.insert([
						{
							host: $authUserData?.id as string
							// studio_mode: true,
							// published: true,
							// published_tz: new Date().toISOString(),
						}
					])
					.select();

				if (error || !data) throw new Error('Failed create debate');

				$liveDebate = data[0] as Tables<'live_debate'>;

				const { data: hostData, error: hostError } = await supabase
					.from('live_debate_participants')
					.insert([
						{
							live_debate: $liveDebate.id as string,
							is_host: true,

							cam_available: Boolean(errorWebcamFeed || webcamFeedPlaying),
							mic_available: kindMapDevices.audioinput.length > 0,
							speaker_available: kindMapDevices.audiooutput.length > 0,
							screenshare_available: Boolean(errorScreenShareFeed || screenSharePlaying),

							cam_enable: webcamFeedPlaying,
							mic_enable: kindMapDevices.audioinput.length > 0, // TODO: set it as mute or unmute
							speaker_enable: kindMapDevices.audiooutput.length > 0,

							cam_id: webCamDeviceId,
							speaker_id: speakerDeviceId,
							mic_id: micDeviceId,

							team: '5932f887-2683-4489-b659-2024f57fd80d',
							display_name: 'Host',
							location: 'stage'
						}
					])
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
			throw new Error('Failed to create new debate');
		}
	}
</script>

<div class="flex justify-center mb-10">
	<div class="flex justify-between items-center gap-4 w-[700px]">
		<div class="in-display-name">
			<Input
				rounded="sm"
				title="Display name"
				width="440px"
				placeholder="Enter title for your live debate"
				value={$authUserData?.displayName || ''}
			/>
		</div>

		<div class="flex justify-center my-2">
			<div class="main-buttons">
				<button onclick={toggleSpeaker} class="btn-main-icon">
					{#if speakerIsPlaying}
						<DeviceSpeaker />
					{:else}
						<DeviceSpeakerDisabled />
					{/if}
				</button>

				<button onclick={toggleMic} class="btn-main-icon">
					{#if micIsPlaying}
						<DeviceMic />
					{:else}
						<DeviceMicDisabled />
					{/if}
				</button>
				<button onclick={toggleWebCam} class="btn-main-icon">
					{#if webcamFeedPlaying}
						<DeviceCamera />
					{:else}
						<DeviceCameraDisabled />
					{/if}
				</button>
				<button onclick={toggleScreenShare} class="btn-main-icon">
					{#if screenSharePlaying}
						<DeviceScreen />
					{:else}
						<DeviceScreenDisabled />
					{/if}
				</button>
			</div>
		</div>
	</div>
</div>

<div class="video-feed">
	<div class="video-title-container">
		<div class="video-container">
			{#if !webcamFeedPlaying}
				<NoFeedCard label="No web camera feed" feedType="profile" onclick={toggleWebCam} />
			{/if}

			<video bind:this={videoInstance} class="video-el" autoplay playsinline>
				<track kind="captions" />
			</video>
		</div>
		<div class="header">
			<button onclick={toggleWebCam} class="btn-icon">
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
				<NoFeedCard label="No screen share feed" onclick={toggleScreenShare} feedType="screen" />
			{/if}
		</div>

		<div class="header">
			<button onclick={toggleScreenShare} class="btn-icon">
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
			<select class="select-audio" bind:value={micDeviceId} onchange={micAnalyser}>
				{#each kindMapDevices['audioinput'] as device}
					<option value={device.deviceId}>{device.label}</option>
				{/each}
			</select>

			<VolumeProgress percent={micVolume} bar={36} />
		</div>
	</div>

	<div class="audio-speaker-container">
		<Heading3 content="SPEAKER" />
		<div class="audio-select-container">
			<select class="select-audio" bind:value={speakerDeviceId} onchange={handleSpeakerChange}>
				{#each kindMapDevices['audiooutput'] as device}
					<option value={device.deviceId}>{device.label}</option>
				{/each}
			</select>

			<Button
				label={speakerIsPlaying ? 'Playing... Stop?' : 'Play Sound'}
				onclick={toggleSound}
				color={speakerIsPlaying ? 'accent-red' : 'secondary'}
				fillType={speakerIsPlaying ? 'solid' : 'outline-solid'}
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

	.in-display-name {
		@apply flex items-center justify-center;
	}
	.main-buttons {
		@apply flex gap-4;
	}

	.btn-main-icon {
		@apply text-transparent;
		height: 40px;
		width: 40px;
		@apply border border-light-gray;
		@apply flex items-center justify-center;
		@apply rounded;
	}

	:global(.btn-main-icon > svg) {
		scale: 1.2;
	}
</style>
