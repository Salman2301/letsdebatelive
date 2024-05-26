<script lang="ts">
	import Button from "$lib/components/button/Button.svelte";
  import Switch from "$lib/components/form/Switch.svelte";
	import Heading3 from "$lib/components/form/Heading3.svelte";
	import { GoBack } from "$lib/components/icon";
	import { getControlRoomCtx } from "$lib/context/control-room";
	import { getContext } from "svelte";
	import CloseX from "$lib/components/icon/CloseX.svelte";
	import CheckMark from "$lib/components/icon/CheckMark.svelte";

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
    <input class="in-max-number" type="number" id="in-max-participant" value="{$live_debate?.max_participants}" min="1" max="100" />
  </div>

  <div class="setting-item">
    <label class="label" for="in-max-stage">Max. number of stage member</label>
    <input class="in-max-number" type="number" id="in-max-stage" value="{$live_debate?.max_stage}" min="1" max="100" />
  </div>

  <div class="setting-item">
    <label for="in-auto-stage">Auto move everyone to stage when joined backstage</label>
    <Switch />
  </div>
  
  <div class="mt-12">
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
  <div class="mt-12">
    <Heading3 content="Team" textAlign="center" />
    <p class="team-desc">Split your audience into different teams</p>
    <div class="teams-container">
      {#each $teams as team}
      <div class="team-item-container">
        <div class="circle-box">
          <div
            class="circle-icon"
            style="background-color:{team.color}"
          ></div>
        </div>
        <div class="team-input-container">
          <input class="team-name-input" value={team.title}/>
          <button
            class="in-submit"
            class:hidden={team}
          >
            <CheckMark />
          </button>
          <button
            class="btn-team-default"
            class:active={team.slug==="team-b"}
          >Default</button>
        </div>
        <button class="delete-icon">
          <CloseX />
        </button>
      </div>
    {/each}
    </div>
    <div class="new-team-container">
      <input class="in-new-team" placeholder="+ Create new team"/>
      
      <button
        class="btn-new-team"
      >
        <CheckMark />
      </button>
    </div>
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

  .in-max-number {
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

  .team-desc {
    @apply text-xs font-bold mb-2;
    color: #ccc;
  }
  .teams-container {
    @apply border border-light-gray;
    @apply rounded;
  }
  .team-item-container {
    @apply flex justify-between items-center;
    @apply border-b border-light-gray;
  }
  .team-item-container:last-child {
    @apply border-none;
  }
  .circle-box {
    min-width: 30px;
    height: 30px;
    @apply flex items-center justify-center;

  }
  .circle-icon {
    width: 18px;
    height: 18px;
    @apply rounded-full;
  }
  .team-input-container {
    @apply border border-light-gray border-y-transparent;
    @apply flex-grow;
    @apply flex items-center justify-between;
    @apply w-full;
    
    @apply focus-within:outline-secondary focus-within:outline;

    &:hover .btn-team-default{
      opacity: 1;
    }
  }
  .team-name-input {
    height: 40px;
    width: 100%;
    @apply px-4;
    @apply text-left bg-transparent border-none outline-none;
  }
  .delete-icon {
    width: 30px;
    @apply flex items-center justify-center;
  }

  .btn-team-default {
    @apply rounded-full;
    @apply text-xs;
    @apply border border-light-gray;
    @apply bg-light-gray;
    @apply px-2 py-1 mx-1;
    opacity: 0;
    &:hover {
      opacity: 1;
    }
    &.active {
      opacity: 1;
      @apply bg-white text-black;
    }
  }

  .delete-icon {
    width: 30px;
    height: 40px;
  }

  .delete-icon:hover {
    
    @apply text-accent-red;
  }

  .new-team-container {
    @apply relative;
  } 

  .in-new-team {
    height: 40px;
    @apply w-full;
    @apply px-2 mt-2;
    @apply outline-none border-0 bg-transparent;
    @apply border-b border-b-light-gray;
    @apply mb-12;
  }

  .btn-new-team {
    @apply absolute;
    right: 10px;
    top: 20px;
  }
</style>
