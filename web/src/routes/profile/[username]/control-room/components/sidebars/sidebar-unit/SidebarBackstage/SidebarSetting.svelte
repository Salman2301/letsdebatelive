<script lang="ts">
	import Button from "$lib/components/button/Button.svelte";
	import Heading3 from "$lib/components/form/Heading3.svelte";
	import { GoBack } from "$lib/components/icon";
	import { getControlRoomCtx } from "$lib/context/control-room";
	import { getContext } from "svelte";

  let showSubmit: boolean = $state(true);

  interface Props {
    type: "backstage" | "stage";
    onclose?: () => void;
  }

  const live_debate = getControlRoomCtx(getContext, "ctx_table$live_debate");
  const teams = getControlRoomCtx(getContext, "ctx_table$live_debate_team");
  const { onclose, type }: Props = $props();


</script>


<div class="px-4">
  <div class="flex justify-between mb-8">
    <Button label="Back to {type==="stage" ? "Stage" : "Backstage"}" fillType="hover" onclick={onclose} >
      <GoBack slot="icon-left"/>
    </Button>
    {#if showSubmit}
      <Button
        color="secondary"
        label="Save"
        width={120}
      />
    {:else}
      <div></div>
    {/if}
  </div>

  <div class="setting-item">
    <label class="label" for="in-max-participant">Max. number of participant</label>
    <input type="number" id="in-max-participant" value="{$live_debate?.max_participants}" min="1" max="100" />
  </div>

  <div class="setting-item">
    <label class="label" for="in-max-stage">Max. number of stage member</label>
    <input type="number" id="in-max-stage" value="{$live_debate?.max_stage}" min="1" max="100" />
  </div>

  <div class="setting-item">
    <label for="in-auto-stage">Auto move everyone to stage when joined backstage</label>
    <input type="checkbox" />
  </div>
  
  <div class="mt-3">
    <Heading3 content="Audience type" textAlign="center" />
  </div>

  <div class="setting-item">
    <label class="label" for="drop-backstage-audience-type">Backstage open only for</label>
    <select id="drop-backstage-audience-type">
      <option value="anyone">Anyone</option>
      <option value="logged">Logged In</option>
      <option value="follower">Follower</option>
      <option value="supporter">Supporter</option>
      <option value="" disabled>----</option>
      <!-- TODO: add list of team -->
      <option>Team - Team A</option>
      {#each $teams as team  }
        <option value="{team.id}">Team {team.title}</option>
      {/each}
      <option value="" disabled>----</option>
      <option value="disabled">Disable</option>
    </select>
  </div>

  <div class="setting-item">
    <label class="label" for="drop-chat-audience">Chat open only for</label>
    <select id="drop-chat-audience">
      <option value="anyone">Anyone</option>
      <option value="logged">Logged In</option>
      <option value="follower">Follower</option>
      <option value="supporter">Supporter</option>
      <option value="" disabled>----</option>
      {#each $teams as team  }
        <option value="{team.id}">Team - {team.title}</option>
      {/each}
      <option value="" disabled>----</option>
      <option value="disabled">Disable</option>
    </select>
  </div>

  <div class="setting-item">
    <label class="label" for="drop-view-audience">Stream to viewer</label>
    <select id="drop-view-audience">
      <option value="anyone">Anyone</option>
      <option value="logged">Logged In</option>
      <option value="follower">Follower</option>
      <option value="supporter">Supporter</option>
      <option value="" disabled>----</option>
      {#each $teams as team  }
        <option value="{team.id}">Team - {team.title}</option>
      {/each}
      <option value="" disabled>----</option>
      <option value="disabled">Disable</option>
    </select>
  </div>

  <!-- Show list of teams below and the user can change the color -->
  <!-- Show filter chat AUTO MODERATOR? -->
  <!-- Call for backroom? -->
</div>

<style lang="postcss">
  .setting-item {
    @apply w-full flex justify-between items-center;
    @apply my-2;
  }

  input {
    @apply py-2;
    width: 60px;
    text-align: center;
    @apply rounded;
    @apply my-2;
  }

  select {
    @apply py-2;
    @apply my-2;
    @apply bg-primary;
    @apply rounded;
  }

  input[type=checkbox] {
    width: 20px;
    height: 20px;
  }
</style>
