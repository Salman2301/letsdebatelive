# Stream Server
Listen for the supabase broadcast on broadcast start, spin up a new machine with puppeteer and start the recording, send the recording started.

On Broadcast end, send stop the recording and completed the ffmpeg.



1. Control room   -------> Broadcast start
2. Broadcast start ----subscribe----> Stream server
3. Stream server and start recording -----update record ready----> Control room (Show starting soon slide)
4. Control room -----start stream----->Layout shift ( has recorded by both the players)
5. Control room -----stop stream------>Broadcast end ( stop the ffmpeg player )
