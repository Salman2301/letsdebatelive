export function clickOutside(node: HTMLElement, cb?: () => void) {
	window.addEventListener('click', handleClick);

	function handleClick(e: MouseEvent) {
		if (e && e.target && !node.contains(e.target as Node)) cb?.();
	}

	return {
		destroy() {
			window.removeEventListener('click', handleClick);
		}
	};
}
