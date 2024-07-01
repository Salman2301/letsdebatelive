<script lang="ts">
	import Prompt from '$lib/components/prompt/Prompt.svelte';
	import Toast from '$lib/components/toast/Toast.svelte';
	import Header from '$lib/components/navbar/NavBar.svelte';
	import ModalAll from '$lib/components/modal/ModalAll.svelte';
	import SidePanelAll from '$lib/components/side-panel/SidePanelAll.svelte';

	import { getContext, onMount } from 'svelte';
	import { authUserData } from '$lib/stores/auth.store';
	import { getSupabase } from '$lib/supabase';

	const supabase = getSupabase();

	onMount(async () => {
		const {
			data: { session }
		} = await supabase.auth.getSession();
		if (!session) return;

		// Create an account for new user! Should be handled somewhere backend? without RLS
		const res = await supabase.auth.getUser();
		if (res.error || !res.data || !res.data.user || !res.data.user.id)
			throw new Error('Failed to retrived user');

		const { data: userData } = await supabase.from('user_data').select().eq('id', res.data.user.id);
		if (userData && userData.length > 0) {
			authUserData.set(userData[0]);
		}
	});
</script>

<ModalAll />
<SidePanelAll />
<Toast />
<Prompt />
<Header />

<div class="page">
	<slot />
</div>

<style lang="postcss">
	.page {
		@apply bg-primary-dark;
		min-height: calc(100vh - 76px);
		overflow: scroll;
	}
</style>
