import type { Writable } from 'svelte/store';
import type { PageData } from '../../routes/u/[username]/$types';
import type { ParticipantsWithUserData } from '$src/routes/u/[username]/page.types';

export type ContextTypes = {
	pageDataProps: PageData;
	myBackstageInfo: Writable<ParticipantsWithUserData | null >
};
