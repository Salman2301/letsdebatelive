<script lang="ts">
	import ScreenCard from './component/content/ScreenCard.svelte';
	import ProfileVideoCard from './component/content/ProfileVideoCard.svelte';
	import SceneLayout from "./component/SceneLayout.svelte";
	import type { LayoutContentType, ScenePayloadContent } from "../video-feed.types";
	import type { Tables } from '$lib/schema/database.types';

  let { payload }: { payload: ScenePayloadContent } = $props();
  let layoutId: LayoutContentType;
  let participantsList: Tables<"live_debate_participants">[] = [];

  function filterParticipants(layoutId: LayoutContentType): any[] {
    if(participantsList) {
      return participantsList.filter(({ type }: any) => type === "profile");
    }
    return [];
  }

  function filterScreen(): any {
    // Find the active screen id from live debate setting
    // Filter the screen id based on the participant list
    if(participantsList[0].screenshare_available) {
      return participantsList;
    }
    return [];
  }

</script>

<SceneLayout>
  <div class="layer">
    {#if layoutId === "profile_multiple"}
      {#each filterParticipants(layoutId) as list}
        <ProfileVideoCard {list} />
      {/each}
    {:else if layoutId === "profile_single"}
    <div class="layer">
      {#each filterParticipants(layoutId) as list}
        <ProfileVideoCard {list} />
      {/each}
    </div>
    {:else if layoutId === "profile_screen"}
    
      {#each filterParticipants(layoutId) as list}
        <ProfileVideoCard {list} />
      {/each}
      <ScreenCard screen={filterScreen()} />

    {:else if layoutId === "screen_full"}
      <ScreenCard screen={filterScreen()} />
    {:else if layoutId === "screen_focus"}
      <div class="m-4">
        <ScreenCard screen={filterScreen()} />
      </div>
    {:else if layoutId === "screen_overlay_profile"}
      <ScreenCard screen={filterScreen()} />
    {:else if layoutId === "audio_only"}
      {#each filterParticipants(layoutId) as list}
        <ProfileVideoCard {list} type="audio" />
      {/each}
    {:else if layoutId === "audio_profile"}
      {#each filterParticipants(layoutId) as list}
        <ProfileVideoCard {list} type="audio" />
      {/each}
    {/if}
    </div>
</SceneLayout>

<style lang="postcss">

</style>