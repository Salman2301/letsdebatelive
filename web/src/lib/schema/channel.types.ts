// Supabase Channel and types
import supabase from "$lib/supabase";

/**
 * DOCS
 * Rooms access
 * - Control room - Only the host have access to the Control room and may be in future the co-host
 * - Record room - only access by the ghost user, Ghost user are craeted per host and it's hidden to record the video
 * L- ive room  - can be access by any user unless the host restrict it either by support only, follower only and team only
 * 
 * Role Hierarchy
 * We have describe this in the lower order
 * 
 * 1. Host - The user who started the live video call
 * 2. Moderator - The user who join as moderators to the host channel
 * 3. Backstage - The user who join the backstage from the Live room
 * 4. Team - User who selected in a specific team
 * 5. User - Any user, even anonymous, event can send from chats, QA etcs, User can split into  Supporter | Follower | Anon
 * 
 */

// TODO: have a separate channel for support chat
// TODO: split activity into different group like chat | action to lower the load  of chat channel

const channelList = [
  "host:video_activity:$sec_channel_id",
  "host:setting_activity:$channel_id",
  "host:request_action:$channel_id",
  
  "service:notification_read:$channel_id",

  "backstage:activity:$channel_id",
  "backstage:chat:$channel_id",
  "moderation:activity:$channel_id",
  "user:activity:$channel_id",
  "user:chat:$channel_id",
] as const;

interface InfoAndPayload {
  description: string;
  trigger: string;
  role: { write: string[], read:string[]}; // Role are min. roles that required see role-hierarchy
  payload: {
    
  }
}
const channelPayload: Record<typeof channelList[number], InfoAndPayload> = {
  "host:video_activity:$sec_channel_id": {
    description: "Host and the Video feed setting used between control and record room, Consumed by ghost user",
    trigger: "host",
    role: {
      write: ["host"],
      read: ["ghost", "backstage"] // this can also be specific team based
    },
    payload: {

    }
  },
  "host:setting_activity:$channel_id": {
    description: "Host can change the setting live support only, follower only and anyone can consume it",
    trigger: "host",
    role: {
      write: ["host"],
      read: ["user"]
    },
    payload: {

    }
  },
  "host:request_action:$channel_id": {
    description: "Host can 'call for action' and this will popup in the frontend",
    trigger: "host",
    role: {
      write: ["host"],
      read: ["user"], // can only be a specfic team
    },
    payload: {

    }
  },
  "service:notification_read:$channel_id": {
    description: "Only write by one of the service used to check if the notification is read, only host can see",
    trigger: "service",
    role: {
      write: ["service"],
      read: ["host"]
    },
    payload: {
      hostId: "",
      seriviceId: "",
      hasRead: "boolean",
      count: "number"
    }
  },
  "backstage:activity:$channel_id": {
    description: "Used by the backstage and the host. User might have access since we need to see the raise hands",
    trigger: "backstage",
    role: {
      write: ["backstage"],
      read: ["user"]
    },
    payload: {

    }
  },
  "backstage:chat:$channel_id": {
    description: "Used by the backstage and the host. Communication between only host and the backstage",
    trigger: "backstage",
    role: {
      write: ["backstage"],
      read: ["moderator"]
    },
    payload: {

    }
  },
  "moderation:activity:$channel_id": {
    description: "Only the moderator can write to this channel and consumed by any rooms",
    trigger: "moderator",
    role: {
      write: ["moderator"],
      read: ["user"]
    },
    payload: {

    }
  },
  "user:activity:$channel_id": {
    description: "Any user can access it can be from live room",
    trigger: "user",
    role: {
      write: ["user"],
      read: ["user"]
    },
    payload: {

    }
  },
  "user:chat:$channel_id": {
    description: "Any user can send the chat via live room",
    trigger: "user",
    role: {
      write: ["user"],
      read: ["user"]
    },
    payload: {

    }
  }
}
