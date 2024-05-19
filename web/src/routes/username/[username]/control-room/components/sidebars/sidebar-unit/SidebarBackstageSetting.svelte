<script lang="ts">
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import { backstage_participants } from '$lib/dummy/backstage';
	import type { Tables } from '$lib/schema/database.types';

	let backstagers: Tables<'live_debate_participants'>[] = backstage_participants;
</script>

<div class="heading">
	<Heading2 content="Backstage" />
	<div class="icon-container">
		<svg width="25" height="25" viewBox="0 0 25 25" fill="none" xmlns="http://www.w3.org/2000/svg">
			<g clip-path="url(#clip0_551_1117)">
				<path
					d="M4.5824 21.8076V14.8076"
					stroke="currentcolor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
				<path
					d="M4.5824 10.8076V3.80762"
					stroke="currentcolor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
				<path
					d="M12.5824 21.8076V12.8076"
					stroke="currentcolor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
				<path
					d="M12.5824 8.80762V3.80762"
					stroke="currentcolor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
				<path
					d="M20.5824 21.8076V16.8076"
					stroke="currentcolor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
				<path
					d="M20.5824 12.8076V3.80762"
					stroke="currentcolor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
				<path
					d="M1.5824 14.8076H7.5824"
					stroke="currentcolor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
				<path
					d="M9.5824 8.80762H15.5824"
					stroke="currentcolor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
				<path
					d="M17.5824 16.8076H23.5824"
					stroke="currentcolor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
			</g>
			<defs>
				<clipPath id="clip0_551_1117">
					<rect
						width="24"
						height="24"
						fill="currentcolor"
						transform="translate(0.582397 0.807617)"
					/>
				</clipPath>
			</defs>
		</svg>
	</div>
</div>

<div class="flex flex-wrap justify-evenly gap-2">
	{#each backstagers as backstager}
		<div class="card-container">
			<div class="username-img-default">
				<div class="circle-icon">
					{backstager.display_name?.[0].toUpperCase() || 'A'}
				</div>
			</div>
			<div class="username-text">{backstager.display_name}</div>
		</div>
	{/each}
</div>

<style lang="postcss">
	.heading {
		@apply flex items-center my-4 justify-between;
	}
	.card-container {
		@apply bg-secondary-dark;
		@apply rounded border border-light-gray;
		width: 140px;
	}
	.username-img-default {
		width: 100%;
		aspect-ratio: 4 / 3;
		@apply rounded overflow-clip;
		@apply flex items-center justify-center;
	}
  .icon-container {
    padding: 4px;
    cursor: pointer;
  }
	.icon-container:hover {
		background-color: white;
		color: rgb(var(--color-primary-dark));
		border-radius: 100%;
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

	.username-text {
		@apply text-center;
		height: 30px;
		@apply flex items-center justify-center;
	}
</style>
