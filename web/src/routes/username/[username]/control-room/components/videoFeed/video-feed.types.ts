
export type SceneType = 'scene_start' | 'scene_content' | 'scene_break' | 'scene_end' | 'scene_loading';

export type ContentLayoutStyle = 'profileTwo' | 'screen' | 'screenProfile' | 'profileMain' | 'profileChat';
	
export interface OnSceneChangeProps<T=Record<string, any>> {
  payload: Payload<T>;
}
export interface Payload<T=Record<string, any>> { 
  sceneType: SceneType;
  metadata: T
}


export type LayoutContentType = "profileMultiple" |
"profileSingle" |
"profileScreen" |
"screenFull" |
"screenFocus" |
"screenOverlayProfile" |
"audioOnly" |
"audioProfileSingle";