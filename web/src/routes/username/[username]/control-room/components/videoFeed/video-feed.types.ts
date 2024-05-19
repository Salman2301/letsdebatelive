
export type SceneType = 'scene_start' | 'scene_content' | 'scene_break' | 'scene_end' | 'scene_loading';

export type LayerIdContent = 'profileTwo' | 'screen' | 'screenProfile' | 'profileMain' | 'profileChat';
	
// export interface OnSceneChangeProps<T=Record<string, any>> {
//   payload: Payload<T>;
// }
// export interface Payload<T=Record<string, any>> { 
//   sceneType: SceneType;
//   metadata: T
// }


export type LayoutContentType = "profileMultiple" | "profileSingle" | "profileScreen" | "screenFull" | "screenFocus" | "screenOverlayProfile" | "audioOnly" | "audioProfileSingle";
 
export type ScenePayload = ScenePayloadDefault | ScenePayloadBreak | ScenePayloadContent;

export interface ScenePayloadDefault extends LayerText {
  sceneType: "scene_start" | "scene_end"
}

interface ScenePayloadContent {
  sceneType: "scene_content",
  layerId: LayerIdContent
}

interface ScenePayloadBreak {
  sceneType: "scene_break";
  layerId: "layer_break",
  metadata: {
    timeout: string;
    breakEndAt: string;
  }
}

interface LayerText {
  layerId: "layer_text",
  metadata: {
    text: string;
  }
}
