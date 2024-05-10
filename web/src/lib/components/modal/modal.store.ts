import { writable, type Writable } from "svelte/store";

type Modal = "login" | "register" | "reset-password" | "forgot-password" | null;
export const currentModal: Writable<Modal> = writable("login");

