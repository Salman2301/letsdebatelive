<script lang="ts">
	import { browser } from "$app/environment";
	import { getUserId } from "$lib/components/auth";
	import type { Tables } from "$lib/schema/database.types";
	import TeamCard from "../components/TeamCard.svelte";

  let teamInfos: Partial<Tables<"live_debate_team">>[] = [];

  if( browser ) {
    if(teamInfos.length === 0 ) createNeutralTeam();
  }


  async function createNeutralTeam() {
    teamInfos = [
      {
        color: "#ccc",
        title: "Neutral",
        user_id: await getUserId() as string
      }
    ]
  }

  export function beforeOnNext() {
    // Add all stage to teams and participants table
  }

</script>

<div class="flex justify-center gap-4">
  {#each teamInfos as team}
    <TeamCard team={team} />
  {/each}
</div>

<style lang="postcss">

</style>