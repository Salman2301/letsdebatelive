<script lang="ts">
	import RootLayout from '$lib/components/slots/RootLayout.svelte';
	import { page } from '$app/stores';
	import '../app.css';
	import { screenWindowSizePx } from '$lib/stores/screen-size.store';
	import { onMount, setContext } from "svelte";
	import { authUserData } from '$lib/components/auth/auth.store';

	export let data;
	setContext("lib_supabase", data.supabase);

	onMount(async ()=>{
		await data.supabase.auth.getSession();

		$authUserData = data.userData;

		data.supabase.auth.onAuthStateChange(async (event, session) => {
			console.log("state_change", { event, session });
			if (session) {
				// setAuthStore( session );
				const userId = session.user.id;
				$authUserData = (await data.supabase.from("user_data").select("*").eq("id", userId).single()).data;
			}
			else {
				$authUserData = null;
				localStorage.clear();
				// supabase.auth.signOut();
			}
		});
		// console.log({ $userAuthData})
		// data.supabase.auth.getUser().then(async ({ data: d})=>{
		// 	if(d && d.user ) {
		// 		const { data:userData, error }= await data.supabase.from("user_data").select();
		// 		// $authUserData = userData?.[0];
		// 		console.log({ userData, error })
		// 	} else {
		// 		$authUserData = null;
		// 	}

		// })
		handleScreenResize();
	});

	function handleScreenResize() {
		const width = window.innerWidth;
		screenWindowSizePx.set(width);
	}
</script>

<svelte:window onresize={handleScreenResize} />
{#if $page.url.pathname.includes('/record-view')}
	<slot />
{:else}
	<RootLayout>
		<slot></slot>
	</RootLayout>
{/if}

<style lang="postcss">
</style>
