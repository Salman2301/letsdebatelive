<script lang="ts">
	import { currentModal } from '$lib/components/modal/modal.store';
	import { goto } from "$app/navigation";
	import { onMount } from "svelte";

  onMount(()=>{
    $currentModal = "reset-password";
    goto("/");
  });
</script>



<style lang="postcss">

</style>