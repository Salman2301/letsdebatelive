<script lang="ts">
	import LayoutProfileMain from './components/layout-setting-icon/LayoutProfileMain.svelte';
	import LayoutScreenProfile from './components/layout-setting-icon/LayoutScreenProfile.svelte';
	import LayoutScreen from './components/layout-setting-icon/LayoutScreen.svelte';
	import LayoutProfileTwo from './components/layout-setting-icon/LayoutProfileTwo.svelte';
	import LayoutProfileChat from './components/layout-setting-icon/LayoutProfileChat.svelte';
	import SmallSidePanel from "./components/small-sidepanel/SmallSidePanel.svelte";

  
  type LayoutStyle = "profileTwo" | "screen" | "screenProfile" | "profileMain" | "profileChat";
  export let currentLayoutStyle: LayoutStyle = "profileTwo";
</script>

<!-- Check for admin -->
<!-- Sidebar -->

<div class="control-room-container">
  <div class="video-container">

  </div>
  <div class="layout-setting-container">
    <div class="layout-icons">
      <button
        class="layout-icon"
        class:active={currentLayoutStyle === "profileTwo"} on:click={() => (currentLayoutStyle = "profileTwo")}
      >
        <LayoutProfileTwo />
      </button>
      <button
        class="layout-icon"
        class:active={currentLayoutStyle === "screen"} on:click={() => (currentLayoutStyle = "screen")}
      >
        <LayoutScreen />
      </button>
      <button
        class="layout-icon"
        class:active={currentLayoutStyle === "screenProfile"} on:click={() => (currentLayoutStyle = "screenProfile")}
      >
        <LayoutScreenProfile />
      </button>
      <button
        class="layout-icon"
        class:active={currentLayoutStyle === "profileMain"} on:click={() => (currentLayoutStyle = "profileMain")}
      >
        <LayoutProfileMain />
      </button>
      <button
        class="layout-icon"
        class:active={currentLayoutStyle === "profileChat"} on:click={() => (currentLayoutStyle = "profileChat")}
      >
        <LayoutProfileChat />
      </button>
    </div>
    <div class="layout-break-end">

    </div>
  </div>
  <div class="small-panel-container">
    <div class="small-panel small-panel-1">
      <SmallSidePanel />
    </div>
    <div class="small-panel small panel-2">
      <SmallSidePanel />
    </div>  
  </div>
</div>

<style lang="postcss">
  .video-container {
    aspect-ratio: 16 / 9;
    @apply border border-light-gray;
  }
  .layout-setting-container {
    height: 48px;
    width: 100%;
  }
  .small-panel-container {
    display: flex;
    width: 100%;
    height: calc( 100vh - 420px - 48px - 76px );  /* 100vh - video height -layout-panel - navbar height */
    @apply border border-light-gray;
  }

  .small-panel {
    width: 50%;
    height: 100%;
  }
  .small-panel-1 {
    @apply border-r border-light-gray;
  }
  .small-panel-2 {
    /* @apply border-r border-light-gray; */
  }
  .layout-setting-container {
    @apply flex items-center;
  }

  .layout-icons {
    @apply flex gap-2;
  }

  .layout-icon {
    color: #4A0335;
  }
  .layout-icon:focus {
    outline: none;
  }

  .layout-icon.active {
    color: #8B0457;
  }
</style>