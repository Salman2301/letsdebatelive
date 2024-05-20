<script lang="ts">
	import Button from "$lib/components/button/Button.svelte";

  interface Props {
    onclose?: () => void;
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
    <div class="label">Min. number of user</div>
    <input type="number" value="1" min="1" />
  </div>

  <div class="setting-item">
    <div class="label">Backstage open for</div>
    <select>
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