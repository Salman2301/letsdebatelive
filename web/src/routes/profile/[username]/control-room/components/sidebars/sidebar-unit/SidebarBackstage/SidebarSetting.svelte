<script lang="ts">
	import Button from "$lib/components/button/Button.svelte";
	import { GoBack } from "$lib/components/icon";

  interface Props {
    type: "backstage" | "stage";
    onclose?: () => void;
  }
  const { onclose, type }: Props = $props();
</script>


<div class="px-4">
  <Button label="Back to {type==="stage" ? "Stage" : "Backstage"}" fillType="hover" onclick={onclose} >
    <GoBack slot="icon-left"/>
  </Button>

  <div class="setting-item">
    <label class="label" for="in-min-participant">Min. number of participant</label>
    <input type="number" id="in-min-participant" value="1" min="1" />
  </div>

  <div class="setting-item">
    <label class="label" for="in-min-stage">Min. number of stage member</label>
    <input type="number" id="in-min-stage" value="1" min="1" />
  </div>

  <div class="setting-item">
    <label for="in-auto-stage">Auto move everyone to backstage</label>
    <input type="checkbox" />
  </div>
  
  <div class="setting-item">
    <label class="label" for="drop-allowed-member">Backstage open for</label>
    <select id="drop-allowed-member">
      <option value="none">None</option>
      <option value="anyone">Anyone</option>
      <option value="logged">Logged In</option>
      <option value="follower">Follower</option>
      <option value="supporter">Supporter</option>
      <option value="moderator">Moderator</option>
      <option value="" disabled>----</option>
      <!-- TODO: add list of team -->
      <option>Team - Team A</option>
    </select>
  </div>
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
