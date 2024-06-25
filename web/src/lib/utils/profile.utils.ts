import { NO_PROFILE_DEFAULT } from "../constatnt/file";
import { getSupabase } from "../supabase";

export function getProfileImage(image?: string|null): string {
		if (!image) return NO_PROFILE_DEFAULT;
    const supabase = getSupabase();
		const url = supabase.storage.from('profile_image').getPublicUrl(image).data.publicUrl;

		return url || NO_PROFILE_DEFAULT;
	}