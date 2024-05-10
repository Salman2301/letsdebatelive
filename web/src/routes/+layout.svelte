<script>
  import "../app.css";
  import Header from "$lib/components/header/Header.svelte";
	import { currentModal } from "$lib/components/modal/modal.store";
  import ModalAll from "$lib/components/modal/ModalAll.svelte";

</script>

<ModalAll />
<Header />

<slot />
