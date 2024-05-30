import { writable, type Writable } from "svelte/store";

type SidePanelKey = "none" | "equip";
export const sidePanelKey: Writable<SidePanelKey> = writable("none"); 
export const sidePanelHeader: Writable<string> = writable("");

export function openSidePanel(newSidePanelKey: SidePanelKey) {
  sidePanelKey.set(newSidePanelKey);
}

export function closeSidePanel() {
  sidePanelKey.set("none");
}
