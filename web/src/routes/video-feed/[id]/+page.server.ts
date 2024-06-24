import { fail } from "@sveltejs/kit";

export async function load({ locals, params }) {
	const supabase = locals.supabase;

	// only the bot can access this page?
	// Check if the id is a valid id and it's
	// Create a ghost participant on bot click on the URL
	// Check if the id is valid
	// Check if the page is only accessible by the bot

	const { data: liveFeed, error } = await supabase
		.from("live_feed")
		.select()
		.eq("id", params.id)
		.single();
	
	if (error) {
		console.error(error);
		throw fail(500, {
			message: "Server Error live_feed"
		})
	}
	if (!liveFeed) {
		throw fail(404, {
			message: "Not Found live_feed"
		});
	}

	// Check for th bots

	return {
		live_feed_id: params.id
	};
}
