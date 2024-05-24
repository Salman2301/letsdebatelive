<script context="module" lang="ts">
	import { writable } from "svelte/store";
	import type { Writable } from "svelte/store";
	import {
		ICON_BACKSTAGE_SETTINGS,
		ICON_BROADCAST,
		ICON_PARTICIPANTS,
		ICON_SETTINGS,
		ICON_DEBATE_AGENDA,
		ICON_POLL_ANALYTICS,
		ICON_QA,
		ICON_BANNER,
		ICON_CHAT_LIVE,
		ICON_CHAT_MODERATION
	} from "./sidebars/sidebar-icons";
	
	import {
		SidebarBroadcast,
		SidebarSetting,
		SidebarAgenda,
		SidebarPoll,
		SidebarQA,
		SidebarBanner,
		SidebarBackstageSetting,
		SidebarChatLive,
		SidebarChatModerator,
		SidebarParticipant
	} from "./sidebars/sidebar-unit";

	type SidebarKey = "setting" | "participants" | "backstageSetting" | "chatLive" | "agenda" | "poll" | "qa" | "banner" | "chatModerator" | "broadcast";

	type SidebarSmall = {
		[index in SidebarKey]: {
			label: string;
			icon: typeof ICON_SETTINGS;
			sidebar: typeof ICON_SETTINGS;
			divider?: true;
		};
	};

	
	const sidebarSmall: SidebarSmall = {
		setting: {
			label: "Setting",
			icon: ICON_SETTINGS,
			sidebar: SidebarSetting
		},
		participants: {
			label: "Participants",
			icon: ICON_PARTICIPANTS,
			sidebar: SidebarParticipant
		},
		backstageSetting: {
			label: "Backstage Setting",
			icon: ICON_BACKSTAGE_SETTINGS,
			sidebar: SidebarBackstageSetting
		},
		chatLive: {
			label: "Chat Live",
			icon: ICON_CHAT_LIVE,
			sidebar: SidebarChatLive,
			divider: true
		},

		agenda: {
			label: "Debate Agenda",
			icon: ICON_DEBATE_AGENDA,
			sidebar: SidebarAgenda
		},
		poll: {
			label: "Poll",
			icon: ICON_POLL_ANALYTICS,
			sidebar: SidebarPoll
		},
		qa: {
			label: "Question and Answer",
			icon: ICON_QA,
			sidebar: SidebarQA
		},
		banner: {
			label: "Banner",
			icon: ICON_BANNER,
			sidebar: SidebarBanner,
			divider: true
		},
		
		chatModerator: {
			label: "Chat Moderator",
			icon: ICON_CHAT_MODERATION,
			sidebar: SidebarChatModerator
		},
		broadcast: {
			label: "Broadcast setting",
			icon: ICON_BROADCAST,
			sidebar: SidebarBroadcast
		}
	} as const;

	export let currentSidebar: Writable<SidebarKey> = writable("backstageSetting");

</script>

<script lang="ts">
	let sidebarKeys = $state(Object.keys(sidebarSmall) as Array<SidebarKey>);

	function hasDivider(key: SidebarKey) {
		return !!sidebarSmall[key].divider;
	}
</script>

<div class="sidebar">
	<div class="sidebar-small-icon">
    <!-- List of icons -->
		{#each sidebarKeys as sidebarKey}
			<div class="icon-item" class:active={$currentSidebar === sidebarKey}>
				<button
				class="icon-sidebar"
				class:active={$currentSidebar===sidebarKey}
				onclick={()=>($currentSidebar=sidebarKey)}
			>
				<svelte:component this={sidebarSmall[sidebarKey].icon} />
			</button>
			<div class="popup">
				{sidebarSmall[sidebarKey].label}
			</div>
			</div>
			{#if hasDivider(sidebarKey)}
				<div class="divider"></div>
			{/if}
		{/each}
	</div>
	<div class="sidebar-content">
		<svelte:component this={sidebarSmall[$currentSidebar].sidebar} />
	</div>
</div>

<style lang="postcss">
	.sidebar {
		height: calc(100vh - 76px);
    @apply flex;
	}

	.icon-item {
		@apply relative;
		@apply flex justify-center items-center;
	}
	.popup {
		@apply absolute left-14 top-0;
		@apply bg-black;
		@apply rounded;
		@apply px-2;
		@apply flex items-center;
		@apply border border-light-gray;
		width: 140px;
		font-size: 12px;
		height: 40px;
		display: none;
		word-wrap: none;
		z-index: 1000;
	}
	.icon-item:hover .popup {
		display: flex;
	}

	.icon-item {
		@apply pt-1;
		@apply flex items-center justify-center;
		padding-bottom: 2px;
	}
	.icon-item.active {
		@apply bg-white/20;
	}

	.icon-sidebar {
		color: #A8A8A8;
		display: flex;
		justify-content: center;
		height: 40px;
		scale: 0.9;
	}

	.icon-sidebar:focus,
	.icon-sidebar:active
	 {
		outline: none;
	}

	.active {
		color: white;
	}
	.sidebar-small-icon {
		@apply bg-secondary-dark;
		width: 50px;
		height: 100%;

    position: fixed;
    top: 76px;
    height: calc(100vh - 76px);
		z-index: 999;
		/* Causing z-index issue with the sidebar name popup? */
		/* position: sticky; */ 

		display: flex;
		justify-content: space-evenly;
		flex-direction: column;
	}
	.divider {
		@apply mb-8;
	}
	.sidebar-content {
		@apply bg-primary-dark;
		width: calc( 50vw - 180px );
		height: 100%;
		overflow: auto;
		margin-left: 50px;
		@apply relative;
		z-index: 1;
		/* @apply px-4; */
	}

</style>
