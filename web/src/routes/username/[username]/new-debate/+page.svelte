<script lang="ts">
	import Button from '$lib/components/button/Button.svelte';
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import StageNumber from './components/StageNumber.svelte';
	import StageTestingFeeds from './stages/StageTestingFeeds.svelte';
	import StageTeam from "./stages/StageTeam.svelte";

	let currentState: number = 1;
	const stageInstance: StageTestingFeeds[] = [];

	async function handleNext() {
		await stageInstance[currentState-1].beforeOnNext()
		if( currentState === 4 ) {
			// redirect to control room
		}
		currentState += 1;
	}

	function handlePrev() {
		currentState -= 1;
	}
</script>

<Heading2 content="New debate" textAlign="center" />

<div class="stage-margin">
	<StageNumber active={currentState} />
</div>

{#if currentState === 1}
	<StageTestingFeeds bind:this={stageInstance[0]} />
{:else if currentState === 2}
	<StageTeam />
{/if}

<div class="action-btn">
	<div class:invisible={currentState==1} >
		<Button label="Prev" color="secondary" fillType="outline-solid" width={120} on:click={handlePrev} />
	</div>
	
	<Button label="Next" color="secondary" width={120} on:click={handleNext} />
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
