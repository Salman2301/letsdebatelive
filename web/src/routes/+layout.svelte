<script>
  import "../app.css";
  import Header from "$lib/components/header/Header.svelte";
  import ModalAll from "$lib/components/modal/ModalAll.svelte";
  import Toast from "$lib/components/toast/Toast.svelte";

</script>

<Toast />
<ModalAll />
<Header />

<slot />
