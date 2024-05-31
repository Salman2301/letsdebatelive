<script lang="ts">
	import Button from '$lib/components/button/Button.svelte';
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import StageNumber from './components/StageNumber.svelte';
	import StageTestingFeeds from './stages/StageTestingFeeds.svelte';
	import StageTeam from './stages/StageTeam.svelte';
	import StageDebate from './stages/StageDebate.svelte';
	import StageBroadcast from './stages/StageBroadcast.svelte';
	import StageStudio from './stages/StageStudio.svelte';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { PageCtx } from '$src/lib/context';

	let currentState: number = 1;
	// @ts-expect-error
	let stageInstance: [StageTestingFeeds, StageTeam, StageDebate, StageStudio, StageBroadcast] = [];

	const pageCtx = new PageCtx("new-debate");

	const title = pageCtx.get("title");
	const liveDebate = pageCtx.get("liveDebate");
	const hostParticipant = pageCtx.get("hostParticipant");

	async function handleNext() {
		await stageInstance[currentState - 1].beforeOnNext();
		if (currentState === 5) {
			// redirect to control room
			if (!$liveDebate) {
				newToast({
					type: 'error',
					message: 'Something went wrong!'
				});
				throw new Error('Failed to get the live debate');
			}

			$liveDebate.published = true;
			$liveDebate.published_tz = new Date().toISOString();

			goto(`/profile/${$page.params.username}/control-room`);
		}
		currentState += 1;
	}

	function handlePrev() {
		currentState -= 1;
	}
</script>


<div class="stage-margin">
	<StageNumber active={currentState} />
</div>

<Heading2 content={$title as string} textAlign="center" />


{#if currentState === 1}
	<StageTestingFeeds bind:this={stageInstance[0]} />
{:else if currentState === 2}
	<StageTeam bind:this={stageInstance[1]} />
{:else if currentState === 3}
	<StageDebate bind:this={stageInstance[2]} />
{:else if currentState === 4}
	<StageDebate bind:this={stageInstance[3]} />
{:else if currentState === 5}
	<StageBroadcast bind:this={stageInstance[4]} />
{/if}

<div class="action-btn">
	<div class:invisible={currentState === 1}>
		<Button
			label="Prev"
			color="secondary"
			fillType="outline-solid"
			width={120}
			onclick={handlePrev}
		/>
	</div>

	<Button label="Next" color="secondary" width={120} onclick={handleNext} />
</div>

<style lang="postcss">
	.stage-margin {
		@apply my-8;
	}
	.action-btn {
		width: 700px;
		margin: 10px auto;

		@apply flex justify-between;
	}
</style>
