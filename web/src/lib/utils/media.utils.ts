type DeviceMapOpt = Record<MediaDeviceKind, MediaDeviceInfo[]>;

export async function getDevices(): Promise<DeviceMapOpt> {
  
  let kindMapDevices: DeviceMapOpt = {
    audioinput: [],
    videoinput: [],
    audiooutput: []
  };
  try {
    // In firefox, Not initializing a stream doesn't capture all the devices
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true, video: true }).catch(() => null);

    const devices = await navigator.mediaDevices.enumerateDevices();
    devices.sort((a, b) => (a.label.toLowerCase() > b.label.toLowerCase() ? 1 : -1));

    for (const key of Object.keys(kindMapDevices)) {
      kindMapDevices[key as MediaDeviceKind] = devices.filter((device) => device.kind === key);
    }

    // We need to call getUserMedia media in order to enumerateDevices with labels.
    // Then we have to stop the audio track, since Firefox thinks we're still using
    // the stream if we try to switch devices later.
    stopStream(stream);
  }
  catch (e) {
    console.error("Failed to get the user media devices");
    console.error(e);
  }
  // console.log("kindMapDevices", kindMapDevices);
  return kindMapDevices; 
}


export async function stopStream(stream: MediaStream | null) {
  if (!stream) return;
  await Promise.all(stream.getTracks().map((track) => track.stop()));
}
