<script lang="ts">
	import Button from "$lib/components/button/Button.svelte";
  import Heading3 from "$lib/components/form/Heading3.svelte";
  import { enhance } from '$app/forms';

  import { invalidateAll } from '$app/navigation';


</script>

<form
  method="POST"
  action="?/join_backstage"
  class="join-backstage-panel"
>
  <Heading3 content="Join the backstage panel and chat with the host and audience!"/>
  <div class="button-container">
    <Button
      label="Join Backstage"
      fillType="solid-white"
      color="secondary"
    />
  </div>
</form>
<style lang="postcss">
  .join-backstage-panel {
    @apply my-2;
    @apply px-2 py-2;
    @apply flex justify-between items-center;
    @apply bg-secondary-dark;
    @apply rounded;
  }
</style>