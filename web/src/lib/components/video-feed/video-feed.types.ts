// import type { Tables } from "$lib/schema/database.types";

export type SceneType =
	| 'scene_start'
	| 'scene_content'
	| 'scene_break'
	| 'scene_end'
	| 'scene_loading';

export type LayerIdContent =
	| 'profile_multiple'
	| 'screen'
	| 'screen_profile'
	| 'profile_main'
	| 'profile_chat';

export type ScenePayload = ScenePayloadDefault | ScenePayloadBreak | ScenePayloadContent;

interface ScenePayloadDefault extends LayerText {
	sceneType: 'scene_start' | 'scene_end' | 'scene_loading';
}

export interface ScenePayloadContent {
	sceneType: 'scene_content';
	layerId: LayerIdContent;
	// Metadata should be coming from a different channel live_feeds_participants
	// metadata: {
	//   participants: any[];
	//   screen: any[]
	// }
}

interface ScenePayloadBreak {
	sceneType: 'scene_break';
	layerId: 'layer_break';
	metadata: {
		timeout: string;
		breakEndAt: string;
	};
}

interface LayerText {
	layerId: 'layer_text';
	metadata: {
		text: string;
	};
}

// interface ParticipantsMetadata {
//   data: Tables<"live_feed_participants">;
// }
