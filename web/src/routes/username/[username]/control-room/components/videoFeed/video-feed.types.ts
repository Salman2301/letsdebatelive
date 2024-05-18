
export type SceneType = 'scene_start' | 'scene_content' | 'scene_break' | 'scene_end' | 'scene_loading';
export interface OnSceneChangeProps<T=Record<string, any>> {
  payload: Payload<T>;
}
export interface Payload<T=Record<string, any>> { 
  sceneType: SceneType;
  metadata: T
}