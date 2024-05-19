// require('dotenv').config();
import "dotenv/config";
import supabase from "./supabase";
import { spawn } from "node:child_process";
import { PuppeteerScreenRecorder } from "puppeteer-screen-recorder";
import puppeteer from "puppeteer";
import { PassThrough } from "node:stream";
import { logger } from "./logger";

// 1080p
let width = 1920;
let height = 1080;

// 720p
// let width = 1280;
// let height = 720;

const Config = {
  followNewTab: false,
  fps: 30,
  ffmpeg_Path: null,
  videoFrame: {
    width,
    height,
  },
  videoCrf: 18,
  videoCodec: "libx264",
  videoPreset: "ultrafast",
  videoBitrate: 1000,
  autopad: {
    color: "black",
  },
};

logger().info("Listening for broadcast_start");

let hostId = "123-456-789";

let lastRecording: { unsubscribe: () => Promise<void> } | null;

const channel = supabase.channel(`broadcast_${hostId}`);

channel
  .on("broadcast", { event: "broadcast_start" }, async () => {
    lastRecording = await onNewLiveDebate();
  })

channel
  .on("broadcast", { event: "broadcast_end" }, async () => {
    setTimeout(async () => {
      if (lastRecording) await lastRecording.unsubscribe();
      else logger().warn(`Nothing to end?`)
    }, 3000);
  })

channel.subscribe();

async function onNewLiveDebate() {
  if (lastRecording) await lastRecording.unsubscribe();

  const browser = await puppeteer.launch({
    defaultViewport: { width, height },
  });
  const page = await browser.newPage();

  await page.goto("http://localhost:5172/username/salman2301/record-view");

  // There is a bug in the app where the screen is stuck in loading.
  // Fix the bug in the video element
  await page.waitForSelector(".loaded-video-el", { visible: false });

  const recorder = new PuppeteerScreenRecorder(page, Config);

  const savePath = `./records/demo_${Date.now()}.mp4`;
  await recorder.start(savePath);

  // const pipeStream = streamToRtmp();
  // const stream = await recorder.startStream(pipeStream);

  logger().info(`Recording: ${savePath}`);
  return {
    unsubscribe: async () => {
      logger().info(`Saved to ${savePath}`);
      await recorder.stop();
      await browser.close();
      lastRecording = null;
    },
  };
}

function streamToRtmp() {
  const pipeStream = new PassThrough();
  
  const ffmpegCommand: string[] = [
    "-i",
    "-",
    "-c:v", "libx264",
    "-preset", "ultrafast",
    "-tune", "zerolatency",
    "-r", `${25}`,
    "-g", `${25}`, // 50
    "-keyint_min", `25`,
    "-bf", "0", // Disable B-frames
  
    "-crf", "25",
    "-pix_fmt", "yuv420p",
    "-sc_threshold", "0",
    "-profile:v", "main",
    "-level", "3.1",
    "-c:a", "aac",
    "-b:a", "128k",
    "-ar", String(128000 / 4),
    "-f", "flv",
    // "output.mp4"
    "rtmp://localhost:1935/live/stream", // RTMP server URL
  ];
  
  const ffmpegProcess = spawn("ffmpeg", ffmpegCommand);
  pipeStream.pipe(ffmpegProcess.stdin);
  
  return pipeStream;
}
