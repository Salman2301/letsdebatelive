import { get } from "svelte/store";
import { errorSpeakerFeed, speakerCtx, speakerDeviceId, speakerEnabled, speakerIsPlaying, speakerNode } from "../stores/media.store";
import { newToast } from "../components/toast/Toast.svelte";

let audioBuffer: AudioBufferSourceNode | null;

speakerEnabled.subscribe(onSpeakerChange);
speakerDeviceId.subscribe(onSpeakerChange);

async function onSpeakerChange() {
  const $speakerDeviceId = get(speakerDeviceId);
  const $speakerNode = get(speakerNode);
  const $speakerCtx = get(speakerCtx);

  if (!$speakerDeviceId) {
    errorSpeakerFeed.set('Speaker device id not found');
    return;
  }
  
  if (!$speakerCtx) {
    errorSpeakerFeed.set('Speaker context not found');
    return;
  }

  if (!$speakerNode) return;

  $speakerNode?.disconnect?.();
  const dest = $speakerCtx.createMediaStreamDestination();
  $speakerNode.connect(dest);

  const audioOutput = new Audio();
  audioOutput.srcObject = dest.stream;
  await audioOutput.setSinkId($speakerDeviceId);
  audioOutput.play();
}

export async function extractAndPlay() {
  // if(!speakerCtx )
  const $speakerCtx = get(speakerCtx);
  const $speakerNode = get(speakerNode);

  if (audioBuffer) {
    audioBuffer.stop();
    audioBuffer = null;
    speakerIsPlaying.set(false);
    return;
  }

  if (!$speakerCtx) {
    errorSpeakerFeed.set('Speaker context not found');
    throw new Error("Speaker context not found");
  }

  if (!$speakerNode) {
    return;
  }

  audioBuffer = $speakerCtx.createBufferSource();

  let decodedAudioData = await getDecodedAudioData();
  audioBuffer.buffer = decodedAudioData;

  audioBuffer.connect($speakerNode);

  audioBuffer.onended = () => {
    speakerIsPlaying.set(false);
  };

  speakerIsPlaying.set(true);
  audioBuffer.start();
}


let decodedAudioData: AudioBuffer;
async function getDecodedAudioData(): Promise<AudioBuffer> {
  const $speakerCtx = get(speakerCtx)!;
  if (!$speakerCtx) {
    errorSpeakerFeed.set('Speaker context not found');
    throw new Error("Speaker context not found");
  }

  if (decodedAudioData) return decodedAudioData;
  const audioData = await fetch('/sounds/test/guitar.mp3').then((resp) => {
    if (resp.status !== 200) {
      newToast({
        message: 'Failed to load audio file',
        type: 'error',
      })
    }
    return resp.arrayBuffer()
  });
  decodedAudioData = await $speakerCtx.decodeAudioData(audioData);
  return decodedAudioData;
}
