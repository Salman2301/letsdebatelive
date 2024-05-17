<script lang="ts">
	import ICON_SETTINGS from "./sidebar-icons/ICON_SETTINGS.svelte";
	import ICON_DEBATE_AGENDA from "./sidebar-icons/ICON_DEBATE_AGENDA.svelte";
	import ICON_POLL_ANALYTICS from "./sidebar-icons/ICON_POLL_ANALYTICS.svelte";
	import ICON_QA from "./sidebar-icons/ICON_QA.svelte";
	import ICON_BANNER from "./sidebar-icons/ICON_BANNER.svelte";
	import ICON_BACKSTAGE_SETTINGS from "./sidebar-icons/ICON_BACKSTAGE_SETTINGS.svelte";
	import ICON_BACKSTAGE_CHAT from "./sidebar-icons/ICON_BACKSTAGE_CHAT.svelte";
	import ICON_CHAT_LIVE from "./sidebar-icons/ICON_CHAT_LIVE.svelte";
	import ICON_CHAT_MODERATION from "./sidebar-icons/ICON_CHAT_MODERATION.svelte";
	import ICON_CHAT_FLAGGED from "./sidebar-icons/ICON_CHAT_FLAGGED.svelte";
	import ICON_USER_BAN from "./sidebar-icons/ICON_USER_BAN.svelte";
	import SidebarSetting from "./sidebars/SidebarSetting.svelte";
	import SidebarAgenda from "./sidebars/SidebarAgenda.svelte";
	import SidebarPoll from "./sidebars/SidebarPoll.svelte";
	import SidebarQA from "./sidebars/SidebarQA.svelte";
	import SidebarBanner from "./sidebars/SidebarBanner.svelte";
	import SidebarBackstageSetting from "./sidebars/SidebarBackstageSetting.svelte";
	import SidebarBackstageChat from "./sidebars/SidebarBackstageChat.svelte";
	import SidebarChatSetting from "./sidebars/SidebarChatSetting.svelte";
	import SidebarChatLive from "./sidebars/SidebarChatLive.svelte";
	import SidebarChatModerator from "./sidebars/SidebarChatModerator.svelte";
	import SidebarChatFlagged from "./sidebars/SidebarChatFlagged.svelte";
	import SidebarUserBan from "./sidebars/SidebarUserBan.svelte";




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
		backstageSetting: {
			label: "Backstage Setting",
			icon: ICON_BACKSTAGE_SETTINGS,
			sidebar: SidebarBackstageSetting
		},
		backstageChat: {
			label: "Backstage Chat",
			icon: ICON_BACKSTAGE_CHAT,
			sidebar: SidebarBackstageChat,
			divider: true
		},
		chatSetting: {
			label: "Chat Setting",
			sidebar: SidebarChatSetting,
			icon: ICON_SETTINGS,
		},
		chatLive: {
			label: "Chat Live",
			icon: ICON_CHAT_LIVE,
			sidebar: SidebarChatLive
		},
		chatModerator: {
			label: "Chat Moderator",
			icon: ICON_CHAT_MODERATION,
			sidebar: SidebarChatModerator
		},
		chatFlagged: {
			label: "Chat Flagged",
			icon: ICON_CHAT_FLAGGED,
			sidebar: SidebarChatFlagged
		},
		userBan: {
			label: "User Ban",
			icon: ICON_USER_BAN,
			sidebar: SidebarUserBan
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
		@apply absolute left-20 top-0;
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
  .sidebar-small-container {
    height: calc(100vh - 76px);
  }
	.sidebar-small-icon {
		@apply bg-secondary-dark;
		width: 70px;
		height: 100%;
		position: sticky;
		top: 0px;

		display: flex;
		justify-content: space-evenly;
		flex-direction: column;
	}
	.divider {
		@apply mb-4;
	}
	.sidebar-content {
		@apply bg-primary-dark;
		width: 400px;
		height: 100%;
		margin-left: 70px;
    overflow: auto;
	}

</style>
