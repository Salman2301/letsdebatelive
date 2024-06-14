export function load({ locals, params }) {
	const supabase = locals.supabase;
	//
	// only the bot can access this page?
	// Check if the id is a valid id and it's

	return {
		live_feed_id: params.id
	};
}
