<script lang="ts">
	import ScreenCard from './component/content/ScreenCard.svelte';
	import ProfileVideoCard from './component/content/ProfileVideoCard.svelte';
	import SceneLayout from './component/SceneLayout.svelte';
	import type { LayerIdContent, ScenePayloadContent } from '../video-feed.types';
	import type { Tables } from '$lib/schema/database.types';
	// import { lastScreenPayloadContent } from './store/scente.store';

	interface Props {
		payload: ScenePayloadContent
		participantsList: Tables<'live_debate_participants'>[];
	}

	let { payload, participantsList }: Props  = $props();
	// let layoutId: LayoutContentType = "profile_multiple";
	// let participantsList: Tables<'live_debate_participants'>[] = [ ];

	function filterParticipants(layoutId: LayerIdContent): Tables<'live_debate_participants'>[] {
		return participantsList;
	}

	function filterScreen(): Tables<'live_debate_participants'> | null {
		// Find the active screen id from live debate setting
		// Filter the screen id based on the participant list
		if (participantsList[0].screenshare_available) {
			participantsList[0];
		}
		return null;
	}
</script>

<SceneLayout>
	<div class="layer">
		<!-- {payload.layerId} -->
		{#if payload.layerId === 'profile_multiple'}
			{#each filterParticipants(payload.layerId) as participant}
				<ProfileVideoCard {participant} />
			{/each}
		{:else if payload.layerId === 'profile_main'}
			<div class="layer">
				{#each filterParticipants(payload.layerId) as participant}
					<ProfileVideoCard {participant} />
				{/each}
			</div>
		{:else if payload.layerId === 'screen'}
			{#each filterParticipants(payload.layerId) as participant}
				<ProfileVideoCard {participant} />
			{/each}
			<ScreenCard screen={filterScreen()} />
		{:else if payload.layerId === 'screen_profile'}
			<div class="m-4">
				<ScreenCard screen={filterScreen()} />
			</div>
		{:else if payload.layerId === 'profile_chat'}
			<ScreenCard screen={filterScreen()} />

			<!-- {:else if payload.layerId === "audio_only"}
      {#each filterParticipants(payload.layerId) as participant}
        <ProfileVideoCard {participant} type="audio" />
      {/each}

    {:else if payload.layerId === "audio_profile"}
      {#each filterParticipants(payload.layerId) as participant}
        <ProfileVideoCard {participant} type="audio" />
      {/each} -->
		{/if}
	</div>
</SceneLayout>

<style lang="postcss">
	.layer {
		@apply flex items-center justify-center;
		@apply w-full h-full;
	}
</style>
