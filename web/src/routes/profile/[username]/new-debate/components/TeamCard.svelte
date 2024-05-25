<script lang="ts">
	import Button from "$lib/components/button/Button.svelte";
	import { newToast } from "$lib/components/toast/Toast.svelte";
  import type { Tables } from "$lib/schema/database.types";

  interface Props {
    team: Partial<Tables<"live_debate_team">>;
    participants?: Tables<"live_debate_participants">[];
  }
  let { team, participants = [] }: Props = $props();
</script>

<div class="team-card">
  <div class="header">
    <div class="team-color">
      <div class="color-selection" style="background:{team.color}"></div>
    </div>
    <div class="input-container"><input class="team-title" bind:value={team.title} /></div>

  </div>

  <div class="participants-list">
    {#each participants as participant}
      <div class="participant-item">
        <svg width="11" height="19" viewBox="0 0 11 19" fill="none" xmlns="http://www.w3.org/2000/svg">
          <ellipse cx="1.44257" cy="1.5" rx="1.44257" ry="1.5" fill="white"/>
          <ellipse cx="9.13642" cy="1.5" rx="1.44257" ry="1.5" fill="white"/>
          <ellipse cx="1.44257" cy="9.5" rx="1.44257" ry="1.5" fill="white"/>
          <ellipse cx="9.13642" cy="9.5" rx="1.44257" ry="1.5" fill="white"/>
          <ellipse cx="1.44257" cy="17.5" rx="1.44257" ry="1.5" fill="white"/>
          <ellipse cx="9.13642" cy="17.5" rx="1.44257" ry="1.5" fill="white"/>
        </svg>          
        <p>participant.display_name</p>
      </div>
      {:else}
        <div class="flex items-center w-full mt-10 justify-center flex-col gap-4 bg-secondary-dark/40 py-2 rounded">   
          <p class="text-white/80 text-xs">No participant found (Optional)</p>     
          <Button label="Invite user" color="secondary" fillType="dark" onclick={()=>newToast({ type: "error", message: "Not implemented!"})} >
            <svg slot="icon-left" width="15" height="15" viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M7.5 2.5V11.25" stroke="white" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M3.125 6.875H11.875" stroke="white" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </Button>
        </div>
    {/each}
  </div>
</div>

<style lang="postcss">
  .team-card {
     background-image: url("data:image/svg+xml,%3csvg width='100%25' height='100%25' xmlns='http://www.w3.org/2000/svg'%3e%3crect width='100%25' height='100%25' fill='none' rx='4' ry='4' stroke='rgba(120,120,120, 0.8)' stroke-width='2' stroke-dasharray='6%2c 3' stroke-dashoffset='0' stroke-linecap='round'/%3e%3c/svg%3e");
    width: 250px;
    min-height: 380px;
    padding: 10px;
  }
  .header {
    @apply flex justify-start gap-4 items-center;
  }
  .color-selection {
    width: 15px;
    height: 15px;
    border-radius: 100%;
  }

  .team-title {
    border: 0px;
    outline: none;
    border-bottom: 1px solid white;
    background-color: transparent;
  }
</style>