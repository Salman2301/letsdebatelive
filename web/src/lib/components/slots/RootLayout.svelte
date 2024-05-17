<script lang="ts">
  import Header from "$lib/components/header/Header.svelte";
  import ModalAll from "$lib/components/modal/ModalAll.svelte";
  import Toast from "$lib/components/toast/Toast.svelte";

  import { onMount } from "svelte";
	import supabase from "$lib/supabase";
	import { authUserData } from "$lib/components/auth/auth.store";

  onMount(async ()=>{
    const { data: {session}} = await supabase.auth.getSession();
    if(!session) return;

    // Create an account for new user! Should be handled somewhere backend? without RLS
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
      console.error({ error });
    }
  })
</script>

<ModalAll />
<Toast />
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
