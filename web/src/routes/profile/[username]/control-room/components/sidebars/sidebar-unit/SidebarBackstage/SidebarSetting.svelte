<script lang="ts">
	import Button from '$lib/components/button/Button.svelte';
	import LiveFeedSetting, {
		type InstanceType
	} from '$lib/components/group/live-feed-setting/LiveFeedSetting.svelte';
	import TeamSetting from '$src/lib/components/group/team-setting/TeamSetting.svelte';

	import { GoBack } from '$lib/components/icon';
	import { PageCtx } from '$src/lib/context';

	interface Props {
		type: 'backstage' | 'stage';
		onclose?: () => void;
	}

	const pageCtx = new PageCtx('control-room');

	const live_feed = pageCtx.get('ctx_table$live_feed');
	const teams = pageCtx.get('ctx_table$live_feed_team');

	const { onclose, type }: Props = $props();

	let showSubmit: boolean = $state(false);

	let liveFeedInstance: InstanceType;

	function handleSubmit() {
		liveFeedInstance?.submit();
	}
</script>

<div class="px-4">
	<div class="flex justify-between mb-8">
		<Button
			label="Back to {type === 'stage' ? 'Stage' : 'Backstage'}"
			fillType="hover"
			onclick={onclose}
		>
			<GoBack slot="icon-left" />
		</Button>
		{#if showSubmit}
			<Button color="secondary" label="Save" width={120} onclick={handleSubmit} />
		{:else}
			<div></div>
		{/if}
	</div>

	<LiveFeedSetting {live_feed} {teams} bind:showSubmit bind:this={liveFeedInstance} />

	<div class="mt-12">
		<TeamSetting {live_feed} {teams} />
	</div>

	<!-- Show list of teams below and the user can change the color -->
	<!-- Show filter chat AUTO MODERATOR? -->
	<!-- Call for backroom? -->
</div>

<style lang="postcss">
</style>
