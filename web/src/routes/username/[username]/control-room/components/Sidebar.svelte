<script lang="ts">
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
	} from "./sidebar-icons";
	
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
		SidebarParticipants
	} from "./sidebars";

	interface SidebarSmall {
		[name: string]: {
			label: string;
			icon: typeof ICON_SETTINGS;
			sidebar: typeof ICON_SETTINGS;
			divider?: true;
		}
	}

	let currentSidebar: string = "setting";

	const sidebarSmall: SidebarSmall = {
		setting: {
			label: "Setting",
			icon: ICON_SETTINGS,
			sidebar: SidebarSetting
		},
		participants: {
			label: "Participants",
			icon: ICON_PARTICIPANTS,
			sidebar: SidebarParticipants
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
	}
</script>

<div class="sidebar">
	<div class="sidebar-small-icon">
    <!-- List of icons -->
		{#each Object.keys(sidebarSmall) as sidebarKey}
			<div class="icon-item">
				<button
				class="icon-sidebar"
				class:divider={sidebarSmall[sidebarKey].divider}
				class:active={currentSidebar===sidebarKey}
				on:click={()=>(currentSidebar=sidebarKey)}
			>
				<svelte:component this={sidebarSmall[sidebarKey].icon} />
			</button>
			<div class="popup">
				{sidebarSmall[sidebarKey].label}
			</div>
			</div>
		{/each}
	</div>
	<div class="sidebar-content">
		<svelte:component this={sidebarSmall[currentSidebar].sidebar} />
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
	}
	.icon-item:hover .popup {
		display: flex;
	}

	.icon-sidebar {
		color: #A8A8A8;
		display: flex;
		justify-content: center;
		height: 40px;
	}

	.active {
		color: white;
	}
	.sidebar-small-icon {
		@apply bg-secondary-dark;
		width: 50px;
		height: 100%;
		position: sticky;
		top: 0px;

		display: flex;
		justify-content: space-evenly;
		flex-direction: column;
	}
	.divider {
		@apply mb-8;
	}
	.sidebar-content {
		@apply bg-primary-dark;
		width: 400px;
		height: 100%;
		margin-left: 70px;
    overflow: auto;
	}

</style>
