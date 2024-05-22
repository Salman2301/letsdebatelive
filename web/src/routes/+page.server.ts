/** @type {import('./$types').PageLoad} */
export function load({ locals }) {
	return {
		user: locals.user
	};
}