// @ts-nocheck
export class AudioDeviceManager {
  constructor() {
    this.currentInputDevice = null;
    this.currentOutputDevice = null;
    this.outputNode = null;
    this.analyser = null;
    this.audioBuffer = null;
    this.decodedAudioData = null;
    this.delayNode = null;
    this.delayEnabled = false;
    this.echoCancellationEnabled = false;

    this.audioElement = document.createElement('audio');
    this.audioElement.src = 'guitar.mp3';
    this.audioElement.loop = true;
    this.audioElement.volume = 0.2;
    document.body.append(this.audioElement);

    this.createContext();
  }

  createContext() {
    if (this.ctx) {
      this.ctx.close();
    }
    if (this.audioBuffer) {
      this.audioBuffer.stop();
    }

    this.ctx = new (window.AudioContext || window.webkitAudioContext)();
    console.log(this.ctx);
    this.outputNode = this.ctx.createGain();
    this.outputNode.connect(this.ctx.destination);

    this.analyser = this.ctx.createAnalyser();
    this.analyser.connect(this.outputNode);
    this.analyser.fftSize = 32;
    this.analyserData = new Uint8Array(this.analyser.frequencyBinCount);

    this.audioBuffer = null;
    this.decodedAudioData = null;

    if (this.currentInputDevice) {
      this.setInputDevice(this.currentInputDevice);
    }
    if (this.currentOutputDevice) {
      this.setOutputDevice(this.currentOutputDevice);
    }
  }

  resumeContext() {
    if (this.ctx.state === 'suspended') {
      this.ctx.resume();
    }
  }

  async getDevices(kind) {
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true });

    const devices = (await navigator.mediaDevices.enumerateDevices()).filter(
      (device) => device.kind === kind
    );
    devices.sort((a, b) => (a.label.toLowerCase() > b.label.toLowerCase() ? 1 : -1));

    // We need to call getUserMedia media in order to enumerateDevices with labels.
    // Then we have to stop the audio track, since Firefox thinks we're still using
    // the stream if we try to switch devices later.
    for (const track of stream.getAudioTracks()) {
      track.stop();
    }

    return devices;
  }

  async setInputDevice(deviceId) {
    this.currentInputDevice = deviceId;

    if (this.currentSource) {
      this.currentSource.disconnect();
    }

    if (this.inputStream) {
      for (const track of this.getInputTracks()) {
        track.stop();
      }
    }

    this.inputStream = await navigator.mediaDevices.getUserMedia({
      audio: { deviceId, echoCancellation: this.echoCancellationEnabled }
    });

    this.currentSource = this.ctx.createMediaStreamSource(this.inputStream);
    this.delayNode = new DelayNode(this.ctx, { delayTime: 1 });

    if (this.delayEnabled) {
      this.currentSource.connect(this.delayNode);
      this.delayNode.connect(this.analyser);
    } else {
      this.currentSource.connect(this.analyser);
    }
  }

  async setOutputDevice(deviceId) {
    this.currentOutputDevice = deviceId;

    this.outputNode.disconnect();
    const dest = this.ctx.createMediaStreamDestination();
    this.outputNode.connect(dest);

    const audioOutput = new Audio();
    audioOutput.srcObject = dest.stream;
    audioOutput.setSinkId(deviceId);
    audioOutput.play();

    this.audioElement.setSinkId(deviceId);
  }

  getAnalyserLevel() {
    this.analyser.getByteFrequencyData(this.analyserData);
    let sum = 0;
    for (let i = 0; i < this.analyserData.length; i++) {
      sum += this.analyserData[i] / 255;
    }
    sum = sum / this.analyserData.length;
    return sum;
  }

  getInputTracks() {
    return this.inputStream.getAudioTracks();
  }

  getConstraints() {
    return navigator.mediaDevices.getSupportedConstraints();
  }

  toggleAudioElement() {
    if (this.audioElement.paused) {
      this.audioElement.play();
    } else {
      this.audioElement.pause();
    }
  }

  async toggleAudioBuffer() {
    if (this.audioBuffer) {
      this.audioBuffer.stop();
      this.audioBuffer = null;

      return true;
    } else {
      this.audioBuffer = this.ctx.createBufferSource();

      if (!this.decodedAudioData) {
        const audioData = await fetch('beat.mp3').then((resp) => resp.arrayBuffer());
        this.decodedAudioData = await this.ctx.decodeAudioData(audioData);
      }

      this.audioBuffer.buffer = this.decodedAudioData;

      this.audioBuffer.connect(this.outputNode);
      this.audioBuffer.loop = true;
      this.audioBuffer.start();

      return false;
    }
  }

  toggleDelay() {
    if (this.delayEnabled) {
      if (this.currentSource) {
        this.currentSource.disconnect();
        this.delayNode.disconnect();
        this.currentSource.connect(this.analyser);
      }
      this.delayEnabled = false;
    } else {
      if (this.currentSource) {
        this.currentSource.disconnect();
        this.currentSource.connect(this.delayNode);
        this.delayNode.connect(this.analyser);
      }
      this.delayEnabled = true;
    }
    return this.delayEnabled;
  }

  toggleEchoCancellation() {
    this.echoCancellationEnabled = !this.echoCancellationEnabled;
    if (this.currentInputDevice) {
      this.setInputDevice(this.currentInputDevice);
    }
    return this.echoCancellationEnabled;
  }
}