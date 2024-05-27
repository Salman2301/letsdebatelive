import { derived, writable, type Readable, type Writable } from 'svelte/store';

type ScreenSize = 'lg' | 'md' | 'sm' | 'xl' | '2xl';
let screenSizeMapPx = {
	'2xl': 1536,
	xl: 1280,
	lg: 1024,
	md: 768,
	sm: 0
};

export const screenWindowSizePx: Writable<number> = writable(0);
export const screenWindowSize: Readable<ScreenSize> = derived(screenWindowSizePx, getScreenSize);
export const isLessThanLg: Readable<boolean> = derived(
	screenWindowSizePx,
	($width) => $width >= screenSizeMapPx['lg']
);

export function getScreenSize(width: number): ScreenSize {
	if (width >= screenSizeMapPx['2xl']) {
		return '2xl';
	} else if (width >= screenSizeMapPx['xl']) {
		return 'xl';
	} else if (width >= screenSizeMapPx['lg']) {
		return 'lg';
	} else if (width >= screenSizeMapPx['md']) {
		return 'md';
	} else {
		return 'sm';
	}
}
