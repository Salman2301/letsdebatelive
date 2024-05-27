import { writable, type Writable } from 'svelte/store';
import type { ScenePayloadContent } from '../../video-feed.types';

export const lastScreenPayloadContent: Writable<ScenePayloadContent> = writable({
	layerId: 'screen',
	sceneType: 'scene_content'
});
