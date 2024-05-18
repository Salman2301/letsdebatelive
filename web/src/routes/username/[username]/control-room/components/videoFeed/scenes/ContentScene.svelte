<script lang="ts">
	import ScreenCard from './component/content/ScreenCard.svelte';
	import ProfileVideoCard from './component/content/ProfileVideoCard.svelte';
	import type { LayoutContentType, OnSceneChangeProps } from "../video-feed.types";
	import SceneLayout from "./component/SceneLayout.svelte";

  let { payload }: OnSceneChangeProps = $props();

  let layoutId: LayoutContentType;

  let participantsList: any[] = [];

  function filterParticipants(layoutId: LayoutContentType) {
    if(payload.metadata.participants) {
      return payload.metadata.participants.filter(({ type }: any) => type === "profile");
    }
  }

  function filterScreen() {
    if(payload.metadata.screen) {
      return payload.metadata.screen;
    }
  }

</script>

<SceneLayout>
  <div class="layer">
    {#if layoutId === "profileMultiple"}
      {#each filterParticipants(layoutId) as list}
        <ProfileVideoCard {list} />
      {/each}
    {:else if layoutId === "profileSingle"}
    <div class="layer">
      {#each filterParticipants(layoutId) as list}
        <ProfileVideoCard {list} />
      {/each}
    </div>
    {:else if layoutId === "profileScreen"}
    
      {#each filterParticipants(layoutId) as list}
        <ProfileVideoCard {list} />
      {/each}
      <ScreenCard screen={filterScreen()} />

    {:else if layoutId === "screenFull"}
      <ScreenCard screen={filterScreen()} />
    {:else if layoutId === "screenFocus"}
      <div class="m-4">
        <ScreenCard screen={filterScreen()} />
      </div>
    {:else if layoutId === "screenOverlayProfile"}
      <ScreenCard screen={filterScreen()} />
    {:else if layoutId === "audioOnly"}
      {#each filterParticipants(layoutId) as list}
        <ProfileVideoCard {list} type="audio" />
      {/each}
    {:else if layoutId === "audioProfileSingle"}
      {#each filterParticipants(layoutId) as list}
        <ProfileVideoCard {list} type="audio" />
      {/each}
    {/if}
    </div>
</SceneLayout>

<style lang="postcss">

</style>