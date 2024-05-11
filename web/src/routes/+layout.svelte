<script lang="ts">
  import "../app.css";
  import Header from "$lib/components/header/Header.svelte";
  import ModalAll from "$lib/components/modal/ModalAll.svelte";
  import Toast from "$lib/components/toast/Toast.svelte";
	import { currentModal } from "$lib/components/modal/modal.store";

  import { onMount } from "svelte";
	import supabase from "$lib/supbase";
	import { authUserData } from "$lib/components/auth/auth.store";

  onMount(async ()=>{
    const { data: {session}} = await supabase.auth.getSession();
    if(!session) return;

    const { data: userData } = await supabase.from("user_data").select();
    if( userData && userData.length > 0) {
      authUserData.set(userData[0])
    }
    else {
      const email = session.user.email as string;
      const { data, error} = await supabase.from("user_data").insert({
        username: email,
        email: email,
      });
      console.log({ error });
    }
  })
</script>

<ModalAll />
{#if $currentModal}
  <Toast />
{/if}
<Header />

<div class="page">
  <slot />
</div>

<style lang="postcss">
  .page {
    @apply bg-primary-dark;
    min-height: calc(100vh - 76px);
  }
</style>
