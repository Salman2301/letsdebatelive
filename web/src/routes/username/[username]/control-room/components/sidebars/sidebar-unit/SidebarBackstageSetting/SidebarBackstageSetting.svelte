<script lang="ts">
	import SettingIcon from './../../../../../../../../lib/components/icon/SettingIcon.svelte';
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import BackstagerCard from './BackstagerCard.svelte';
	import { backstage_participants } from '$lib/dummy/backstage';

	import type { Tables } from '$lib/schema/database.types';

	let backstagers: Tables<'live_debate_participants'>[] = backstage_participants;
</script>

<div class="heading">
	<Heading2 content="Backstage" />
	<div class="right-content">
		<button></button>
		<div class="icon-container">
			<SettingIcon />
		</div>
	</div>
</div>

<div class="flex flex-wrap justify-between gap-2">
	{#each backstagers as backstager}
		<BackstagerCard {backstager} />
	{/each}
</div>

<style lang="postcss">
	.heading {
		@apply flex items-center my-4 justify-between;
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
</style>
