import { get } from "svelte/store";
import { authUserData } from "../stores/auth.store";
import { getSupabase } from "../supabase";

import { webcamStream } from "../stores/media.store";
import type { Database, Tables } from "../schema/database.types";
import type { RealtimeChannel, SupabaseClient } from "@supabase/supabase-js";

// This file is only for the speaker
// For the listener, they will use the RTMP stream

const CONFIG = {
  iceServers: [{
    urls: 'stun:stun.l.google.com:19302'
    // urls: 'stun:stun.cloudflare.com:3478'
  }]
};

export class WebRTCRoom {
  liveFeed: Tables<"live_feed"> | null;
  liveFeedId: string;

  rtc: RTCPeerConnection | null;
  channel: RealtimeChannel | null;
  supabase: SupabaseClient<Database>;

  isHost: boolean;
  isJoined: boolean;
  isGhost: boolean;
  isRTCCreated: boolean;
  isInit: boolean;

  error: boolean;
  errorCode: string;
  errorMessage: string;

  constructor(liveFeedId: string, supabase: SupabaseClient<Database>) {
    this.liveFeedId = liveFeedId;

    this.liveFeed = null;

    this.error = false;
    this.errorCode = "";
    this.errorMessage = "";
    
    this.isHost = false;
    this.isJoined = false;
    this.isGhost = false;
    this.isRTCCreated = false;
    this.isInit = false;

    this.rtc = null;
    this.channel = null;

    this.supabase = supabase;
  }

  async init() {
    const { data, error } = await this.supabase.from("live_feed")
      .select()
      .eq("id", this.liveFeedId)
      .single();

    if (error) {
      this.errorCode = "NO_LIVE_FEED";
      this.errorMessage = "Failed to fetch the live feed";
      this.error = true;

      console.error(error);

      throw new Error(`Failed to get the live feed: ${this.liveFeedId}`);
    }
    if (!data) {
      this.errorCode = "NO_LIVE_FEED";
      this.error = true;

      throw new Error(`Failed to get the live feed: ${this.liveFeedId}`);
    }
    this.liveFeed = data;
    const $authUserData = get(authUserData);
    this.isHost = this.liveFeed.host === $authUserData?.id;

    this.channel = this.supabase.channel(`live_feed_${this.liveFeedId}`);

    this.channel.on("broadcast", { event: "icecandidate" }, async (data) => {
      const { payload } = data;
      if (payload.candidate) {
        const candidate = new RTCIceCandidate({
          candidate: payload.candidate,
          sdpMid: payload.sdpMid,
          sdpMLineIndex: payload.sdpMLineIndex
        });
        await this.rtc!.addIceCandidate(candidate);
      }
    });

    this.channel.on("broadcast", { event: "offer" }, async (data) => {
      console.debug("recieve offer", data);
      this.handleOffer(data.payload.sdp); 
    });

    this.channel.on("broadcast", { event: "answer" }, async (data) => {
      console.debug("recieve answer", data);
      this.handleAnswer(data.payload.sdp); 
    });

    this.channel.subscribe();
    this.isInit = true;
  }

  async createRTC() {
    if (!this.isInit) {
      throw new Error("The live feed is not initialized");
    }

    await this.checkDB();
    const $webcamStream = get(webcamStream);
    this.rtc = new RTCPeerConnection(CONFIG);

    if ($webcamStream) {
      console.warn("user has no webcam feed")
      $webcamStream.getTracks().forEach(track => this.rtc?.addTrack(track, $webcamStream));
    }

    this.rtc.ontrack = e => {
      const vidEl = document.getElementById(`video-el-${this.liveFeedId}`) as HTMLDivElement;
      const videos = vidEl.getElementsByTagName("video");
      // This should be mapped based on the pariticipant id
      if( videos.length > 0 ) {
        videos[0].srcObject = e.streams[0];
      }
      
      // this.remoteVideoInstance!.srcObject = e.streams[0]
    };
    
    this.rtc.addEventListener("icecandidate", event => {
      const message: RTCIceCandidateInit & { type: 'candidate' } = {
        type: 'candidate',
        candidate: undefined
      };
      if (event.candidate) {
        message.candidate = event.candidate.candidate;
        message.sdpMid = event.candidate.sdpMid;
        message.sdpMLineIndex = event.candidate.sdpMLineIndex;
      }
  
      this.channel!.send({
        payload: message,
        type: "broadcast",
        event: "icecandidate"
      });

    });

    this.isRTCCreated = true;
  }

  async checkDB() {
    if (!this.isInit) {
      throw new Error("The live feed is not initialized");
    }

    const $authUserData = get(authUserData);
    if (!$authUserData || !$authUserData?.id) {
      // TODO: Implement supabase anon user
      this.errorCode = "NO_AUTH_USER";
      this.errorMessage = "You need to be logged in to join a live feed";
      this.error = true;
      return;
    }
    // const { data, error } = await this.supabase
    //   .from("live_feed_participants")
    //   .select()
    //   .eq("participant_id", $authUserData.id)
    //   .eq("live_feed", this.liveFeedId)
    //   .single();
    
    // if (error || !data) {
    //   this.errorCode = "NO_PARTICIPANT";
    //   this.errorMessage = "Failed to join the live feed";
    //   this.error = true;
    //   console.error(error);
    //   return;
    // }
    this.isJoined = true;
  }

  async makeCall() {
    if (!this.isInit) {
      throw new Error(`The live feed is not initialized: ${this.liveFeedId}`);
    }

    await this.createRTC();
    if (!this.rtc) {
      throw new Error(`Failed to create RTC: ${this.liveFeedId}`);
    }
    const offer = await this.rtc.createOffer();
    const { sdp } = offer;
    this.channel!.send({ type: "broadcast", event: "offer", payload: {sdp}});
    await this.rtc!.setLocalDescription(offer);
  }

  // Handle offfer is sent to the other peer who listen
  // This will init peer, add local and remote sdp and sent the answer
  async handleOffer(sdpOffer: RTCSessionDescriptionInit["sdp"]) {
    if (!this.isInit) {
      throw new Error(`The live feed is not initialized: ${this.liveFeedId}`);
    }

    if (this.isRTCCreated) {
      console.error('existing peerconnection, Skipping handling offer');
      return;
    }
    
    await this.createRTC();

    if (this.rtc === null) {
      console.error(`Failed to create RTC: ${this.liveFeedId}`);
      return;
    }

    const offer = {
      type: "offer",
      sdp: sdpOffer
    } as RTCSessionDescriptionInit;

    await this.rtc.setRemoteDescription(offer);

    const answer = await this.rtc!.createAnswer();
    const { sdp } = answer;
    this.channel!.send({ type: "broadcast", event: "answer", payload: {sdp}});
    await this.rtc!.setLocalDescription(answer);
  }

  // Once we get the answer from the other peer, we can update the remote sdp
  async handleAnswer(sdpAnswer: RTCSessionDescriptionInit["sdp"]) {
    if (!this.isInit) {
      throw new Error(`The live feed is not initialized: ${this.liveFeedId}`);
    }

    if (!this.isRTCCreated) {
      console.error(`existing peerconnection: ${this.liveFeedId}`);
      return;
    }
    const answer = {
      type: "answer",
      sdp: sdpAnswer
    } as RTCSessionDescriptionInit;
    await this.rtc!.setRemoteDescription(answer);
  }
}

// A                           B
//     Offer SDP --->
//     Answer SDP <---
//     ICE Candidates(A) --->
//     ICE Candidates(B) <---





// There is the
// 1. host video stream ( VIDEO & AUDIO )
// 2. A Screenshare element ( VIDEO & AUDIO )
// 3.
// Server send the host stream to stream server
// Get the stream from the stream server based on the
// 1. https://stream.local/stream/:liveid/cam/:participantid:
// 2. https://stream.local/stream/:liveid/screen/
// 3. Get the layout from the web server
// 4. Layout contains the position and size of the element and the source
// 5. Loop through the layout and create the element
// 6. This class is only worry about sending the stream to the stream server not sync
// 7. Video element is 

// let startTime;
// let localStream: MediaStream;
// let pc1: RTCPeerConnection;
// let pc2: RTCPeerConnection;

// const offerOptions = {
//   offerToReceiveAudio: true,
//   offerToReceiveVideo: true
// };

// async function call() {
//   console.log('Starting call');
//   startTime = window.performance.now();
//   const videoTracks = localStream.getVideoTracks();
//   const audioTracks = localStream.getAudioTracks();
//   if (videoTracks.length > 0) {
//     console.log(`Using video device: ${videoTracks[0].label}`);
//   }
//   if (audioTracks.length > 0) {
//     console.log(`Using audio device: ${audioTracks[0].label}`);
//   }
//   const configuration = {};
//   console.log('RTCPeerConnection configuration:', configuration);
//   pc1 = new RTCPeerConnection(configuration);
//   console.log('Created local peer connection object pc1');
//   pc1.addEventListener('icecandidate', e => onIceCandidate(pc1, e));
//   pc2 = new RTCPeerConnection(configuration);
//   console.log('Created remote peer connection object pc2');
//   pc2.addEventListener('icecandidate', e => onIceCandidate(pc2, e));
//   pc1.addEventListener('iceconnectionstatechange', e => onIceStateChange(pc1, e));
//   pc2.addEventListener('iceconnectionstatechange', e => onIceStateChange(pc2, e));
//   pc2.addEventListener('track', gotRemoteStream);

//   localStream.getTracks().forEach(track => pc1.addTrack(track, localStream));
//   console.log('Added local stream to pc1');

//   try {
//     console.log('pc1 createOffer start');
//     const offer = await pc1.createOffer(offerOptions);
//     await onCreateOfferSuccess(offer);
//   } catch (e: any) {
//     onCreateSessionDescriptionError(e);
//   }
// }

// function onCreateSessionDescriptionError(error: Error) {
//   console.log(`Failed to create session description: ${error.toString()}`);
// }

// async function onCreateOfferSuccess(desc: RTCSessionDescriptionInit) {
//   console.log(`Offer from pc1\n${desc.sdp}`);
//   console.log('pc1 setLocalDescription start');
//   try {
//     await pc1.setLocalDescription(desc);
//     onSetLocalSuccess(pc1);
//   } catch (e) {
//     onSetSessionDescriptionError();
//   }

//   console.log('pc2 setRemoteDescription start');
//   try {
//     await pc2.setRemoteDescription(desc);
//     onSetRemoteSuccess(pc2);
//   } catch (e) {
//     onSetSessionDescriptionError();
//   }

//   console.log('pc2 createAnswer start');
//   // Since the 'remote' side has no media stream we need
//   // to pass in the right constraints in order for it to
//   // accept the incoming offer of audio and video.
//   try {
//     const answer = await pc2.createAnswer();
//     await onCreateAnswerSuccess(answer);
//   } catch (e) {
//     onCreateSessionDescriptionError(e);
//   }
// }

// function onSetLocalSuccess(pc) {
//   console.log(`${getName(pc)} setLocalDescription complete`);
// }

// function onSetRemoteSuccess(pc) {
//   console.log(`${getName(pc)} setRemoteDescription complete`);
// }

// function onSetSessionDescriptionError(error?: any) {
//   console.log(`Failed to set session description: ${error.toString()}`);
// }

// function gotRemoteStream(e: any) {
//   // if (remoteVideo.srcObject !== e.streams[0]) {
//   //   remoteVideo.srcObject = e.streams[0];
//   //   console.log('pc2 received remote stream');
//   // }
// }

// async function onCreateAnswerSuccess(desc) {
//   console.log(`Answer from pc2:\n${desc.sdp}`);
//   console.log('pc2 setLocalDescription start');
//   try {
//     await pc2.setLocalDescription(desc);
//     onSetLocalSuccess(pc2);
//   } catch (e) {
//     onSetSessionDescriptionError(e);
//   }
//   console.log('pc1 setRemoteDescription start');
//   try {
//     await pc1.setRemoteDescription(desc);
//     onSetRemoteSuccess(pc1);
//   } catch (e) {
//     onSetSessionDescriptionError(e);
//   }
// }

// async function onIceCandidate(pc, event) {
//   try {
//     await (getOtherPc(pc).addIceCandidate(event.candidate));
//     console.log(`${getName(pc)} addIceCandidate success`);
//   } catch (e) {
//     console.log(`${getName(pc)} failed to add ICE Candidate: ${error.toString()}`);
//   }
//   console.log(`${getName(pc)} ICE candidate:\n${event.candidate ? event.candidate.candidate : '(null)'}`);
// }

// function getName(pc: any) {
//   return (pc === pc1) ? 'pc1' : 'pc2';
// }

// function getOtherPc(pc: any) {
//   return (pc === pc1) ? pc2 : pc1;
// }

// function onIceStateChange(pc, event) {
//   if (pc) {
//     console.log(`${getName(pc)} ICE state: ${pc.iceConnectionState}`);
//     console.log('ICE state change event: ', event);
//   }
// }

