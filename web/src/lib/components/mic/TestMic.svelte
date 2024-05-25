<script lang="ts">
	import { AudioDeviceManager } from "$lib/utils/audioManager";
	import { onMount } from "svelte";
	import VolumeProgress from "./VolumeProgress.svelte";

	let volume = 0.5;

	let status = '';
	let inputDevices: MediaDeviceInfo[] = [];
	let outputDevices: MediaDeviceInfo[] = [];
	let inputTracks = [];
	let constraints = [];
	let meter = 0;
	let audioElementPaused = true;
	let audioBufferPaused = true;
	let delayEnabled = false;
	let echoCancellationEnabled = false;
  let audioDeviceManager: AudioDeviceManager;

  let currentInputDeviceId: string | null = null;
  let currentOutputDeviceId: string | null = null;

  onMount(async ()=>{
    audioDeviceManager = new AudioDeviceManager();

    inputDevices = await audioDeviceManager.getDevices("audioinput"); //"audiooutput"
    outputDevices = await audioDeviceManager.getDevices("audiooutput"); //"audiooutput"
    // outputDevices = await audioDeviceManager.getInputTracks()

    audioDeviceManager.setInputDevice(inputDevices[0].deviceId);
    audioDeviceManager.setOutputDevice(outputDevices[0].deviceId);

    function updateValue () {
      volume = audioDeviceManager?.getAnalyserLevel() || 0;

      window.requestAnimationFrame(updateValue);
    }

    requestAnimationFrame(updateValue);
  })


	function handleTestMic() {
    audioDeviceManager.resumeContext();
  }

  function handleDeviceOutputChange() {
    audioDeviceManager.setOutputDevice(currentOutputDeviceId);
  }
  function handleDeviceInputChange() {
    audioDeviceManager.setInputDevice(currentInputDeviceId);
  }
</script>

<div class="container">
  
<button onclick={handleTestMic}>Test Mic</button>

<select bind:value={currentInputDeviceId} placeholder="Microphone" onchange={handleDeviceInputChange}>
  {#each inputDevices as inputDevice}
    <option value={inputDevice.deviceId}>{inputDevice.label}</option>
  {/each}
</select>

<select bind:value={currentOutputDeviceId} placeholder="Speaker" onchange={handleDeviceOutputChange}>
  {#each outputDevices as outputDevice}
    <option value={outputDevice.deviceId}>{outputDevice.label}</option>
  {/each}
</select>

<progress value={volume}></progress>

</div>
<VolumeProgress percent={volume} />

<style lang="postcss">
  select {
    background-color: transparent;
    padding: 4px 10px;
    border: 1px solid var(--color-light-gray);
    border-radius: 4px;
  }

  .container {
    @apply flex flex-col justify-start;
    @apply my-2;
    width: 280px;
  }
</style>
