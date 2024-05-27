export function selectAll(node: HTMLInputElement, cb?: () => void) {

  node.addEventListener("focus", selectAll);
	function selectAll() {
		if (node && node.select ) node.select();
	}

	return {
		destroy() {
			node.removeEventListener('focus', selectAll);
		}
	};
}
