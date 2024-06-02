/***
  Clean up the code, feed only works if the device is
  enabled / disabled, based on that the feed is created
  and streamd to the respective device stream,
  Any element can tap into the stream and use it.

  Use device id to create the stream from different device id's
  On device change stop the stream, and create a new stream
*/

import { get, writable, type Writable } from 'svelte/store';
import { stopStream } from '../utils/media.utils';

export const webCamEnable: Writable<boolean> = writable(false);
export const screenShareEnable: Writable<boolean> = writable(false);
export const micEnabled: Writable<boolean> = writable(false);
export const speakerEnabled: Writable<boolean> = writable(false);

export const webCamDeviceId: Writable<string | null> = writable(null);
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

export const micWavPercent: Writable<number> = writable(0);
let clearIntervalMic: NodeJS.Timeout;
let currentMicSource: MediaStreamAudioSourceNode;

micEnabled.subscribe(($micEnabled) => {
  setMicrophoneStream();
  if(!$micEnabled) micWavPercent.set(0);
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
  if (typeof window === 'undefined') return errorWebcamFeed.set('Unsupported browser try different browser');
  if (typeof window.navigator === 'undefined') return errorWebcamFeed.set('Unsupported browser try different browser');

  const $webCamDeviceId = get(webCamDeviceId);

  if (!$webCamDeviceId) {
    // TODO: If there is any stream end the stream immediately
    return errorWebcamFeed.set('No device selected');
  }
  
  let feedNotAvailable = !(navigator.mediaDevices && navigator.mediaDevices.getUserMedia);
  if (feedNotAvailable) errorWebcamFeed.set('Unsupported browser try different browser');

  const stream = await navigator.mediaDevices.getUserMedia({
    video: { deviceId: $webCamDeviceId }
  });

  errorWebcamFeed.set('');
  webcamStream.set(stream);
}

export async function setScreenShareStream() {
  if (typeof window === 'undefined') return errorWebcamFeed.set('Unsupported browser try different browser');
  if (typeof window.navigator === 'undefined') return errorWebcamFeed.set('Unsupported browser try different browser');

  let feedNotAvailable = !(navigator.mediaDevices && navigator.mediaDevices.getDisplayMedia);
  if (feedNotAvailable) errorScreenShareFeed.set('Unsupported browser try different browser');

  const stream = await navigator.mediaDevices.getDisplayMedia({ video: true });
  screenShareStream.set(stream);
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


export function disconnectMic() {
  const $micStream = get(micStream);
  clearInterval(clearIntervalMic);
  stopStream($micStream);
  currentMicSource?.disconnect?.();
  return;
}


// navigator.permissions.query(
//   // { name: 'camera' }
//   { name: 'microphone' }
//   // { name: 'geolocation' }
//   // { name: 'notifications' } 
//   // { name: 'midi', sysex: false }
//   // { name: 'midi', sysex: true }
//   // { name: 'push', userVisibleOnly: true }
//   // { name: 'push' } // without userVisibleOnly isn't supported in chrome M45, yet
// ).then(function(permissionStatus){

//   console.log(permissionStatus.state); // granted, denied, prompt

//   permissionStatus.onchange = function(){
//       console.log("Permission changed to " + this.state);
//   }

// })
