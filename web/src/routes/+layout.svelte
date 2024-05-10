<script>
  import "../app.css";
  import Header from "$lib/components/header/Header.svelte";
  import ModalAll from "$lib/components/modal/ModalAll.svelte";
  import Toast from "$lib/components/toast/Toast.svelte";
	import { currentModal } from "$lib/components/modal/modal.store";

  
</script>

<ModalAll />
{#if $currentModal}
  <Toast />
{/if}
<Header />

<slot />
