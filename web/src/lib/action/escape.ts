export function escape(node: HTMLElement, cb?: () => void) {
	window.addEventListener('keyup', handleKeyUp);

	function handleKeyUp(e: KeyboardEvent) {
    if (e.key === "Escape") {
      cb?.();
    }
	}

	return {
		destroy() {
			window.removeEventListener('keyup', handleKeyUp);
		}
	};
}
