<script context="module" lang="ts">
	import {
		Discord,
		Facebook,
		Github,
		Instagram,
		LinkedIn,
		Reddit,
		Snapchat,
		Telegram,
		TikTok,
		Twitch,
		Twitter,
		Youtube,
		Globe
	} from '.';

	export const SOCIAL_ICON_MAP = {
		Discord: Discord,
		Facebook: Facebook,
		Github: Github,
		Instagram: Instagram,
		LinkedIn: LinkedIn,
		Reddit: Reddit,
		Snapchat: Snapchat,
		Telegram: Telegram,
		TikTok: TikTok,
		Twitch: Twitch,
		Twitter: Twitter,
		Youtube: Youtube,
		Globe: Globe
	} as const;

	type ValueOf<T> = T[keyof T];

	/**
	 * Return a svelte icon from a URL passed
	 * @param link
	 */
	export function getSocialIcon(link?: string | null): ValueOf<typeof SOCIAL_ICON_MAP> {
		const domain = safeHostNameParser(link);

		if (!domain) return SOCIAL_ICON_MAP['Globe'];

		if (domain.startsWith('discord')) return SOCIAL_ICON_MAP['Discord'];
		if (domain.startsWith('facebook')) return SOCIAL_ICON_MAP['Facebook'];
		if (domain.startsWith('github')) return SOCIAL_ICON_MAP['Github'];
		if (domain.startsWith('instagram')) return SOCIAL_ICON_MAP['Instagram'];
		if (domain.startsWith('linkedin')) return SOCIAL_ICON_MAP['LinkedIn'];
		if (domain.startsWith('reddit')) return SOCIAL_ICON_MAP['Reddit'];
		if (domain.startsWith('snapchat')) return SOCIAL_ICON_MAP['Snapchat'];
		if (domain.startsWith('t.me')) return SOCIAL_ICON_MAP['Telegram'];
		if (domain.startsWith('tiktok')) return SOCIAL_ICON_MAP['TikTok'];
		if (domain.startsWith('twitch')) return SOCIAL_ICON_MAP['Twitch'];
		if (domain.startsWith('twitter') || domain.startsWith('x.com'))
			return SOCIAL_ICON_MAP['Twitter'];
		if (domain.startsWith('youtube')) return SOCIAL_ICON_MAP['Youtube'];
		return SOCIAL_ICON_MAP['Globe'];
	}

	function safeHostNameParser(url?: string | null): string | null {
		try {
			let urlParsed = new URL(url!);
			const hostname = urlParsed.host.replace('www.', '');
			return hostname;
		} catch (e) {
			return null;
		}
	}
</script>
