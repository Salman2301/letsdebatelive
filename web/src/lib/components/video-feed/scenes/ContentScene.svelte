<script lang="ts">
	import ScreenCard from './component/content/ScreenCard.svelte';
	import ProfileVideoCard from './component/content/ProfileVideoCard.svelte';
	import SceneLayout from './component/SceneLayout.svelte';
	import type { LayerIdContent, ScenePayloadContent } from '../video-feed.types';
	import type { Tables } from '$lib/schema/database.types';
	import type { ParticipantsWithUserData } from '$src/lib/types';
	// import { lastScreenPayloadContent } from './store/scente.store';

	interface Props {
		payload: ScenePayloadContent;
		participantsList: ParticipantsWithUserData[];
	}

	let { payload, participantsList }: Props = $props();
	// let layoutId: LayoutContentType = "profile_multiple";
	// let participantsList: Tables<'live_feed_participants'>[] = [ ];

	function filterParticipants(layoutId: LayerIdContent): ParticipantsWithUserData[] {
		return participantsList;
	}

	function filterScreen(): Tables<'live_feed_participants'> | null {
		// Find the active screen id from live feed setting
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
			{#each filterParticipants(payload.layerId) as participant (participant.participant_id)}
				<ProfileVideoCard {participant} />
			{/each}
		{:else if payload.layerId === 'profile_main'}
			<div class="layer">
				{#each filterParticipants(payload.layerId) as participant (participant.participant_id)}
					<ProfileVideoCard {participant} />
				{/each}
			</div>
		{:else if payload.layerId === 'screen'}
			<div class="w-full h-full">
				<ScreenCard screen={filterScreen()} />
			</div>
		{:else if payload.layerId === 'screen_profile'}
			<div class="m-4 flex items-center justify-between">
				<div class="flex flex-col h-full">
					{#each filterParticipants(payload.layerId) as participant (participant.participant_id)}
						<ProfileVideoCard {participant} />
					{/each}
				</div>
				<div class="w-[70%] h-full">
					<ScreenCard screen={filterScreen()} />
				</div>
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
