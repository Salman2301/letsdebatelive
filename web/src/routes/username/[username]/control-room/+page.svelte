<script lang="ts">
	import LayoutProfileMain from './components/layout-setting-icon/LayoutProfileMain.svelte';
	import LayoutScreenProfile from './components/layout-setting-icon/LayoutScreenProfile.svelte';
	import LayoutScreen from './components/layout-setting-icon/LayoutScreen.svelte';
	import LayoutProfileTwo from './components/layout-setting-icon/LayoutProfileTwo.svelte';
	import LayoutProfileChat from './components/layout-setting-icon/LayoutProfileChat.svelte';
	import SmallSidePanel from "./components/small-sidepanel/SmallSidePanel.svelte";
	import TakeABreak from './components/TakeABreak.svelte';

  
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
      <TakeABreak />
      <button class="btn-stop" on:click={()=>console.log("stop broadcast")}>
        Stop Broadcast
      </button>
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
    @apply flex justify-between;
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
    @apply text-secondary-dark;
  }

  .layout-icon.active {
    @apply text-secondary;
  }

  .layout-break-end {
    @apply flex gap-2 items-center justify-end; 

  }
  .btn-stop {
    @apply h-full;
    width: 140px;
    @apply bg-accent-red rounded;
    height: 40px;
    font-size: 14px;
  }

  .btn-stop:hover {
    @apply bg-accent-red-dark;
  }
</style>