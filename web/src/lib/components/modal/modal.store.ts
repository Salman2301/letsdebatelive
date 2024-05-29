import { writable, type Writable } from 'svelte/store';

type Modal = 'login' |
  'register' |
  'reset-password' |
  'forgot-password' |
  'team-select' |
  null;

export const currentModal: Writable<Modal> = writable(null);
export const currentModalData: Writable<any> = writable(null);


export function openModal(key: Modal, data: any) {
  currentModal.set(key);
  currentModalData.set(data || null);
}
