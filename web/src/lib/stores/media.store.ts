import { derived, get, writable, type Readable, type Writable } from 'svelte/store';
import { stopStream } from '../utils/media.utils';

export const webcamEnable: Writable<boolean> = writable(false);
export const screenShareEnable: Writable<boolean> = writable(false);
export const micEnabled: Writable<boolean> = writable(false);
export const speakerEnabled: Writable<boolean> = writable(false);

export const webcamDeviceId: Writable<string | null> = writable(null);
export const screenShareDeviceId: Writable<string | null> = writable(null);
export const micDeviceId: Writable<string | null> = writable(null);
export const speakerDeviceId: Writable<string | null> = writable(null);

export const webcamStream: Writable<MediaStream | null> = writable(null);
export const screenShareStream: Writable<MediaStream | null> = writable(null);
export const micStream: Writable<MediaStream | null> = writable(null);

export const errorWebcamFeed: Writable<string> = writable('');
export const errorScreenShareFeed: Writable<string> = writable('');
export const errorMicrophoneFeed: Writable<string> = writable('');
export const errorSpeakerFeed: Writable<string> = writable('');

export const speakerIsPlaying: Writable<boolean> = writable(false);
export const speakerNode: Writable<GainNode |  null> = writable(null);

export const micCtx: Writable<AudioContext | null> = writable(null);
export const speakerCtx: Writable<AudioContext | null> = writable(null);


export const webcamIsPlaying: Readable<boolean> = derived([webcamEnable, errorWebcamFeed], ([$webcamEnable, $errorWebcamFeed]) => $webcamEnable && !$errorWebcamFeed);
export const screenShareIsPlaying: Readable<boolean> = derived([screenShareEnable, errorScreenShareFeed], ([$screenShareEnable, $errorScreenShareFeed]) => $screenShareEnable && !$errorScreenShareFeed);

export const micWavPercent: Writable<number> = writable(0);
let clearIntervalMic: NodeJS.Timeout;
let currentMicSource: MediaStreamAudioSourceNode;

micEnabled.subscribe(($micEnabled) => {
  setMicrophoneStream();
  if(!$micEnabled) micWavPercent.set(0);
});

webcamEnable.subscribe(($webCamEnable) => {
  if ($webCamEnable) setWebcamStream()
  else stopWebcamStream();
});

webcamDeviceId.subscribe(($webCamDeviceId) => {
  stopWebcamStream();
  if ($webCamDeviceId) setWebcamStream();
});

screenShareEnable.subscribe(($screenShareEnable) => {
  if ($screenShareEnable) setScreenShareStream()
  else stopScreenShareStream();
});


export function initCtx() {
  // Browser require mouse event to enable mic and speaker context.
  // The code is initialized in routes/+page.svelte on mouse click
  micCtx.set(new (window.AudioContext || window.webkitAudioContext)());
  speakerCtx.set(new (window.AudioContext || window.webkitAudioContext)());
  
  let $micCtx = get(micCtx)!;
  let $speakerCtx = get(speakerCtx)!;

  speakerNode.set($speakerCtx.createGain());

  if ($micCtx.state === 'suspended') $micCtx.resume();
  if ($speakerCtx.state === 'suspended') $speakerCtx.resume();
}

export async function setWebcamStream() {
  try {
      
    if (typeof window === 'undefined') throw errorWebcamFeed.set('Unsupported browser try different browser');
    if (typeof window.navigator === 'undefined') throw errorWebcamFeed.set('Unsupported browser try different browser');
    if (!get(webcamEnable)) return;
    const $webCamDeviceId = get(webcamDeviceId);

    if (!$webCamDeviceId) {
      // TODO: If there is any stream end the stream immediately
      throw errorWebcamFeed.set('No device selected');
    }
    
    let feedNotAvailable = !(navigator.mediaDevices && navigator.mediaDevices.getUserMedia);
    if (feedNotAvailable) throw errorWebcamFeed.set('Unsupported browser try different browser');

    const stream = await navigator.mediaDevices.getUserMedia({
      video: { deviceId: $webCamDeviceId }
    });
    
    errorWebcamFeed.set('');
    webcamStream.set(stream);
  }
  catch (e) {
    errorWebcamFeed.set('');
    webcamEnable.set(false);
  }
}

export async function setScreenShareStream() {
  try {
    
    if (typeof window === 'undefined') throw errorScreenShareFeed.set('Unsupported browser try different browser');
    if (typeof window.navigator === 'undefined') throw errorScreenShareFeed.set('Unsupported browser try different browser');

    let feedNotAvailable = !(navigator.mediaDevices && navigator.mediaDevices.getDisplayMedia);
    if (feedNotAvailable) throw errorScreenShareFeed.set('Unsupported browser try different browser');

    const stream = await navigator.mediaDevices.getDisplayMedia({ video: true });
    errorScreenShareFeed.set('');
    screenShareStream.set(stream);
  }
  catch (e) {
    screenShareEnable.set(false);
    errorScreenShareFeed.set('Permission denied');
  }
}

async function setMicrophoneStream() {
  const $micEnabled = get(micEnabled);
  
  const $micDeviceId = get(micDeviceId);
  if ( !$micEnabled || !$micDeviceId) {
    disconnectMic();
    return;
  }

  const $micStream = await navigator.mediaDevices.getUserMedia({
    audio: { deviceId: $micDeviceId, echoCancellation: true }
  });

  micAnalyser($micStream);
  micStream.set($micStream);
}

export async function stopWebcamStream() {
  const $webCamStream = get(webcamStream);
  if (!$webCamStream) return;
  stopStream($webCamStream);
}

export async function stopScreenShareStream() {
  const $screenShareStream = get(screenShareStream);
  if (!$screenShareStream) return;
  stopStream($screenShareStream);
}

export function disconnectMic() {
  const $micStream = get(micStream);
  clearInterval(clearIntervalMic);
  stopStream($micStream);
  currentMicSource?.disconnect?.();
  return;
}

type MediaType = 'webcam' | 'screenShare' | 'mic' | 'speaker';
export function toggleMedia(media: MediaType) {
  switch (media) {
    case 'webcam':
      return webcamEnable.set(!get(webcamEnable));
    case 'screenShare':
      return screenShareEnable.set(!get(screenShareEnable));
    case 'mic':
      return micEnabled.set(!get(micEnabled));
    case 'speaker':
      return speakerEnabled.set(!get(speakerEnabled));
  }
}

async function micAnalyser($micStream: MediaStream | null) {
  // let $micStream = get(micStream)!;
  let $micCtx = get(micCtx)!;

  if (!$micCtx || !$micStream) return disconnectMic();

  currentMicSource = $micCtx.createMediaStreamSource($micStream);

  let analyser = $micCtx.createAnalyser();

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

  function updateWaveLoop() {
    micWavPercent.set(getAnalyserLevel());
    clearIntervalMic = setTimeout(updateWaveLoop, 60);
  }

  updateWaveLoop();
}
