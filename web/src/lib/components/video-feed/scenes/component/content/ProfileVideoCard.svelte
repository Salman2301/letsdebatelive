<script lang="ts">
	import type { Tables } from '$lib/schema/database.types';

	let profileImage: string;

	interface Props {
		type?: 'audio' | 'video';
		participant: Tables<'live_feed_participants'>;
	}
	let { type, participant }: Props = $props();
</script>

<div class="card">
	<div class="image-container">
		<div class="circle-icon">
			{participant.display_name?.[0].toUpperCase() || 'A'}
		</div>
	</div>
	<div class="profile-name">
		{participant?.display_name}
	</div>
</div>

<style lang="postcss">
	.card {
		border: 1px solid white;
		@apply flex flex-col items-center justify-center;
		@apply m-1 p-1;
	}
	.image-container {
		aspect-ratio: 4 / 3;
		width: 200px;
		@apply flex items-center justify-center;
	}
	.circle-icon {
		width: 60px;
		height: 60px;
		@apply my-2;
		@apply rounded-full;
		@apply flex items-center justify-center;
		@apply text-center;
		font-size: 32px;
		background-color: white;
		@apply text-secondary-dark;
	}
</style>
