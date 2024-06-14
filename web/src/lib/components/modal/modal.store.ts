import { writable, type Writable } from 'svelte/store';
import type { Tables } from '$src/lib/schema/database.types';

export type ModalData = {
	login: null;
	'reset-password': null;
	register: null;
	'forgot-password': null;
	'team-select': {
		teams: Tables<'live_feed_team'>[];
		onSelect: (team: Tables<'live_feed_team'>) => void;
	};
	none: null;
};

export const currentModal: Writable<keyof ModalData> = writable('none');
export const currentModalData: Writable<any> = writable(null);

type ModalArg<T extends keyof ModalData> = ModalData[T] extends null
	? { key: T }
	: { key: T; data: ModalData[T] };

export function openModal<T extends keyof ModalData>(args: ModalArg<T>) {
	currentModal.set(args.key);
	// @ts-ignore
	if (args.data) currentModalData.set(args.data || null);
}

export function closeModal() {
	openModal({ key: 'none' });
}

// openModal({ key: "login"}); // should be ok
// openModal({ key: "team-select", data: {} }); // should be throw error
// openModal({ key: "team-select", data: { teams: [], onSelect: console.error } }); // no error
