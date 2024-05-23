<script lang="ts">
	import { goto } from '$app/navigation';
	import Button from '$lib/components/button/Button.svelte';
	import { authUserData } from "$lib/components/auth/auth.store";

  
</script>

{JSON.stringify($authUserData)}

<Button
onclick={()=>{
	goto(`/profile/${$authUserData?.username}/control-room`);
}}
label="Go to control room"
>

</Button>
<style lang="postcss">

</style>
