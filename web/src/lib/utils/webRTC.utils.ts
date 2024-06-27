import { get } from "svelte/store";
import { authUserData } from "../stores/auth.store";
import { getSupabase } from "../supabase";

import { webcamStream } from "../stores/media.store";
import type { Database, Tables } from "../schema/database.types";
import type { RealtimeChannel, SupabaseClient } from "@supabase/supabase-js";

// This file is only for the speaker
// For the listener, they will use the RTMP stream

const CONFIG = {
  iceServers: [
    {
      // urls: 'stun:stun.l.google.com:19302'
      urls: 'stun:stun.cloudflare.com:3478'
    },
    // {
    //   urls: 'turn:mac.local:3478', // Replace with your TURN server IP or domain
    //   username: 'user', // You can configure this in Coturn if needed
    //   credential: 'your_secret_key' // Should match the static-auth-secret in turnserver.conf
    // }
  ]
};

export class WebRTCRoom {
  liveFeed: Tables<"live_feed"> | null;
  liveFeedId: string;

  rtc: Map<string,RTCPeerConnection>;
  channel: Map<string, RealtimeChannel>;
  supabase: SupabaseClient<Database>;

  isHost: boolean;
  isJoined: Map<string, boolean>;
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
    this.isJoined = new Map();
    this.isGhost = false;
    this.isRTCCreated = false;
    this.isInit = false;

    this.rtc = new Map();
    this.channel = new Map();

    this.supabase = supabase;
  }

  // Setup signaling server
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
    if ($authUserData?.id) {
      this.setupSignalingServer($authUserData.id);
    }
    this.isInit = true;
    // this.runForAllParticipant(this.setupSignalingServer);
  }

  getChannel(participant_id: string): RealtimeChannel {
    return this.supabase.channel(`live_feed_${this.liveFeedId}_${participant_id}`);
  }

  async setupSignalingServer(user_id: string) {
    const supabaseChannel = this.getChannel(user_id);

    supabaseChannel.on("broadcast", { event: "icecandidate" }, async (data) => {
      const { candidate, sdpMid, sdpMLineIndex, participant_id } = data.payload;
      if (candidate) {
        console.log("icecandidate", { data });

        const rtcCandidate = new RTCIceCandidate({
          candidate,
          sdpMid,
          sdpMLineIndex
        });
        // console.log("adding ice candidate", { user_id, candidate, participant_id })
        await this.rtc.get(participant_id)!.addIceCandidate(rtcCandidate).catch((e) => {
          console.error("Failed to add ice candidate", { user_id, candidate, participant_id, e })
          debugger;
        });
      }
    });

    supabaseChannel.on("broadcast", { event: "offer" }, async (data) => {
      console.debug("recieve offer", data);
      const { sdp, by } = data.payload;
      this.handleOffer(by, sdp); 
    });

    supabaseChannel.on("broadcast", { event: "answer" }, async (data) => {
      console.debug("recieve answer", data);
      const { sdp, by } = data.payload;
      this.handleAnswer(by, sdp); 
    });

    supabaseChannel.subscribe();
 
  }
  async createRTC() {
    if (!this.isInit) {
      throw new Error("The live feed is not initialized");
    }

    await this.checkDB();
    this.isRTCCreated = true;

    // send stream to all the other peer
    // create a connect to other peer
   

    await this.runForAllParticipant(this.createRTCPeerConnection);
  }

  async createRTCPeerConnection(participant_id: string) {
    this.rtc.set(participant_id, new RTCPeerConnection(CONFIG));
    console.log("creating RTC for peer ", participant_id)


    // video stream track exchange
    this.sendMyStreamToPeer(participant_id);

    this.rtc.get(participant_id)!.ontrack = e => {
      // debugger;
      const vidEl = document.getElementById(`video-el-${this.liveFeedId}`) as HTMLDivElement;
      const video = vidEl.querySelector(`#video-${participant_id}`) as HTMLVideoElement;
      console.log({
        video,
        vidEl
      })
      // This should be mapped based on the pariticipant id
      if( video ) {
        console.log("setting src object", { video, s: e.streams[0] })
        video.srcObject = e.streams[0];
      }

      // this.remoteVideoInstance!.srcObject = e.streams[0]
    };

    this.rtc.get(participant_id)!.addEventListener("icecandidate", event => {
      const message: RTCIceCandidateInit & { type: 'candidate', participant_id: string } = {
        type: 'candidate',
        candidate: undefined,
        participant_id: get(authUserData)?.id!
      };

      if (event.candidate) {
        message.candidate = event.candidate.candidate;
        message.sdpMid = event.candidate.sdpMid;
        message.sdpMLineIndex = event.candidate.sdpMLineIndex;
      }

      this.getChannel(participant_id)!.send({
        payload: message,
        type: "broadcast",
        event: "icecandidate"
      });

    });
  }


  async sendMyStreamToPeer(participant_id: string) {
    if (!this.rtc?.get(participant_id)) {
      throw new Error(`No rtc connection for ${participant_id}`);
    }

    const $webcamStream = get(webcamStream);
    console.log("webcam stream", $webcamStream, this)

    if( !$webcamStream ) {
      throw new Error(`No webcam feed to send ${participant_id}`);
    }

    console.warn("Sending my webcam feed to the peer", { participant_id });
    const track = $webcamStream.getTracks()[0];
    this.rtc?.get(participant_id)?.addTrack(track, $webcamStream);

  }
  async runForAllParticipant(fn: (participant_id: string) => Promise<void>) {
    const { data, error } = await this.supabase
      .from("live_feed_participants")
      .select("participant_id")
      .eq("live_feed", this.liveFeedId)
      .not("participant_id", "eq", get(authUserData)?.id)

    if (error || !data) {
      this.errorCode = "NO_PARTICIPANT";
      this.errorMessage = "Failed to join the live feed";
      this.error = true;
      console.error(error);
      return;
    }

    for (const { participant_id } of data) {
      fn.apply(this, [participant_id]);
    }
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

  }

  async makeCall() {
    if (!this.isInit) {
      throw new Error(`The live feed is not initialized: ${this.liveFeedId}`);
    }

    await this.createRTC();
    if (!this.isRTCCreated) {
      throw new Error(`Failed to create RTC: ${this.liveFeedId}`);
    }
    console.log("make call")
    await this.runForAllParticipant(this.sendOffer);
 }

  async sendOffer(participant_id: string) {
    console.log("sending offer ... ", participant_id)
    const offer = await this.rtc.get(participant_id)!.createOffer();
    const { sdp } = offer;
    this.getChannel(participant_id)!.send({
      type: "broadcast", event: "offer", payload: {
        sdp,
        by: get(authUserData)?.id
      }
    });
    await this.rtc.get(participant_id)!.setLocalDescription(offer);
  }

  // Handle offfer is sent to the other peer who listen
  // This will init peer, add local and remote sdp and sent the answer
  // handling offer is listened, so the participant id here should be peer not the current user
  async handleOffer(participant_id: string, sdpOffer: RTCSessionDescriptionInit["sdp"]) {
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

    await this.rtc.get(participant_id)!.setRemoteDescription(offer);

    const answer = await this.rtc.get(participant_id)!.createAnswer();
    const { sdp } = answer;
    this.getChannel(participant_id)!.send({
      type: "broadcast", event: "answer", payload: {
        sdp,
        by: get(authUserData)?.id
      }
    });

    await this.rtc.get(participant_id)!.setLocalDescription(answer);

    this.isJoined.set(participant_id, true);
  }

  // Once we get the answer from the other peer, we can update the remote sdp
  async handleAnswer(participant_id: string, sdpAnswer: RTCSessionDescriptionInit["sdp"]) {
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
    await this.rtc.get(participant_id)!.setRemoteDescription(answer);

    this.isJoined.set(participant_id, true);
  }
}

// A                           B
//     Offer SDP --->
//     Answer SDP <---
//     ICE Candidates(A) --->
//     ICE Candidates(B) <---

