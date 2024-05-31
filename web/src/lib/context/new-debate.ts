import type { Writable } from "svelte/store";
import type { Tables } from "../schema/database.types";

export type ContextTypes = {
  liveDebate: Writable<Tables<"live_debate"> | null >;
  hostParticipant: Writable<Tables<"live_debate_participants"> | null >;
  title: Writable<string>;
};
