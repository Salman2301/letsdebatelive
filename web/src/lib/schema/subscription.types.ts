import type { Database, Tables } from './database.types';

type TableList = keyof Database['public']['Tables'];

export type SubscriptionCB<T extends TableList> = EventInsert<T> | EventDelete<T> | EventUpdate<T>;

type EventInsert<T extends TableList> = BaseSubscriptionResult & {
	table: T;
	eventType: 'INSERT';
	new: Tables<T>;
	old: object;
};

type EventDelete<T extends TableList> = BaseSubscriptionResult & {
	table: T;
	eventType: 'DELETE';
	new: object;
	old: Partial<Tables<T>>;
};

type EventUpdate<T extends TableList> = BaseSubscriptionResult & {
	table: T;
	eventType: 'UPDATE';
	new: Tables<T>;
	old: Partial<Tables<T>>;
};

type BaseSubscriptionResult = {
	schema: 'public';
	commit_timestamp: string;
	old: Record<string, string>;
	error: any | null;
};

/*
  // Update

{
  "schema": "public",
  "table": "live_feed_participants",
  "commit_timestamp": "2024-05-21T07:24:39.773Z",
  "eventType": "UPDATE",
  "new": {
      "cam_available": null,
      "cam_enable": true,
      "cam_id": null,
      "created_at": "2024-05-21T04:13:56.177617+00:00",
      "current_stage": null,
      "display_name": "Test",
      "hand_raised": null,
      "is_host": false,
      "is_kicked": null,
      "live_feed": "4167bf11-dc10-46d3-9d32-e5b7ad9d3e67",
      "location": "backstage",
      "mic_available": null,
      "mic_enable": true,
      "mic_id": null,
      "participant_id": "dc81fe33-706b-40eb-962b-14ebf3eadc58",
      "screenshare_available": null,
      "speaker_available": null,
      "speaker_enable": true,
      "speaker_id": "2",
      "team": "8dd04996-eddd-49ee-8e36-c459202e87e4"
  },
  "old": {
      "live_feed": "4167bf11-dc10-46d3-9d32-e5b7ad9d3e67",
      "participant_id": "dc81fe33-706b-40eb-962b-14ebf3eadc58"
  },
  "errors": null
}

// delete
{
  "schema": "public",
  "table": "live_feed_participants",
  "commit_timestamp": "2024-05-21T07:25:03.170Z",
  "eventType": "DELETE",
  "new": {},
  "old": {
      "live_feed": "b39f5e45-df05-42d2-b9b0-53d87e3ab647",
      "participant_id": "dc81fe33-706b-40eb-962b-14ebf3eadc58"
  },
  "errors": null
}

{
    "schema": "public",
    "table": "live_feed_participants",
    "commit_timestamp": "2024-05-21T07:29:56.825Z",
    "eventType": "INSERT",
    "new": {
        "cam_available": null,
        "cam_enable": true,
        "cam_id": null,
        "created_at": "2024-05-21T07:29:56.819559+00:00",
        "current_stage": null,
        "display_name": "test",
        "hand_raised": null,
        "is_host": false,
        "is_kicked": null,
        "live_feed": "4167bf11-dc10-46d3-9d32-e5b7ad9d3e67",
        "location": "backstage",
        "mic_available": null,
        "mic_enable": true,
        "mic_id": null,
        "participant_id": "dc81fe33-706b-40eb-962b-14ebf3eadc58",
        "screenshare_available": null,
        "speaker_available": null,
        "speaker_enable": true,
        "speaker_id": null,
        "team": "5932f887-2683-4489-b659-2024f57fd80d"
    },
    "old": {},
    "errors": null
}
*/
