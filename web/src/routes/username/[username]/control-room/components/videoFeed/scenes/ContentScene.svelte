<script lang="ts">
	import ScreenCard from './component/content/ScreenCard.svelte';
	import ProfileVideoCard from './component/content/ProfileVideoCard.svelte';
	import SceneLayout from "./component/SceneLayout.svelte";
	import type { LayoutContentType, ScenePayloadContent } from "../video-feed.types";
	import type { Tables } from '$lib/schema/database.types';

  let { payload }: { payload: ScenePayloadContent } = $props();
  let layoutId: LayoutContentType = "profile_single";
  let participantsList: Tables<"live_debate_participants">[] = [];

  function filterParticipants(layoutId: LayoutContentType): Tables<"live_debate_participants">[] {
    if(participantsList) {
      return participantsList.filter(({ type }: any) => type === "profile");
    }
    return [];
  }

  function filterScreen(): Tables<"live_debate_participants"> | null {
    // Find the active screen id from live debate setting
    // Filter the screen id based on the participant list
    if(participantsList[0].screenshare_available) {
      participantsList[0];
    }
    return null;
  }

</script>

<SceneLayout>
  <div class="layer">
    {layoutId}
    {#if layoutId === "profile_single"}
      {#each filterParticipants(layoutId) as participant}
        <ProfileVideoCard {participant} />
      {/each}

    {:else if layoutId === "profile_main"}
    <div class="layer">
      {#each filterParticipants(layoutId) as participant}
        <ProfileVideoCard {participant} />
      {/each}
    </div>

    {:else if layoutId === "profile_screen"}
      {#each filterParticipants(layoutId) as participant}
        <ProfileVideoCard {participant} />
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
      {#each filterParticipants(layoutId) as participant}
        <ProfileVideoCard {participant} type="audio" />
      {/each}

    {:else if layoutId === "audio_profile"}
      {#each filterParticipants(layoutId) as participant}
        <ProfileVideoCard {participant} type="audio" />
      {/each}
    {/if}
    </div>
</SceneLayout>

<style lang="postcss">

</style>