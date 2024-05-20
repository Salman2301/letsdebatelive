<script lang="ts">
	import Button from "$lib/components/button/Button.svelte";
	import type { Bindable } from "svelte";

  interface Props {
    onclose?: Bindable<() => void>;
  }
  const { onclose }: Props = $props();
</script>


<div class="px-4">
  <Button label="Back to Backstage" fillType="hover" onclick={onclose} >
    <svg slot="icon-left" width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M3.69226 7.30754H15.4615C18.3928 7.30754 20.7692 9.68388 20.7692 12.6152V12.6152C20.7692 15.5466 18.3928 17.9229 15.4615 17.9229H11.5384M3.69226 7.30754L7.84611 3.61523M3.69226 7.30754L7.84611 11.4614" stroke="white" stroke-width="2" stroke-linecap="round"/>
    </svg>
  </Button>

  <div class="setting-item">
    <label class="label" for="in-min-user">Min. number of user</label>
    <input type="number" id="in-min-user" value="1" min="1" />
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
</style>