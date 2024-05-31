<script lang="ts">
	import Button from '$lib/components/button/Button.svelte';
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import {
		Stage1Init,
		Stage2Host,
		Stage3CoHost,
		Stage4Setting,
		Stage5Broadcast
	} from './components/stages';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { PageCtx } from '$src/lib/context';
	import { getSupabase } from '$src/lib/supabase';
	import { getContext } from 'svelte';

	let currentState: number = $state(1);
	// @ts-expect-error
	let stageInstance: [Stage1Init, Stage2Host, Stage3CoHost, Stage4Setting, Stage5Broadcast] = [];

	const supabase = getSupabase(getContext);
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

			sessionStorage.removeItem("store$liveDebateId");
			await supabase.from("live_debate").update({...$liveDebate}).eq("id", $liveDebate.id)
			
			goto(`/profile/${$page.params.username}/control-room`);
		}
		currentState += 1;
	}

	function handlePrev() {
		currentState -= 1;
	}

	let stages = [
		'New Debate (1 / 5)',
		'My (Host) Setup (2 / 5)',
		'Invite Co-host (3 / 5)',
		'Setting (4 / 5)',
		'Broadcast'
	];

	$effect(() => {
		$title = stages[currentState - 1];
	});
</script>


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
	
	<Heading2 content={$title as string} textAlign="center" />

	<Button label="{currentState === 5 ? "Publish": "Next"}" color="secondary" width={120} onclick={handleNext} />
</div>

{#if currentState === 1}
	<Stage1Init bind:this={stageInstance[0]} />
{:else if currentState === 2}
	<Stage2Host bind:this={stageInstance[1]} />
{:else if currentState === 3}
	<Stage3CoHost bind:this={stageInstance[2]} />
{:else if currentState === 4}
	<Stage4Setting bind:this={stageInstance[3]} />
{:else if currentState === 5}
	<Stage5Broadcast bind:this={stageInstance[4]} />
{/if}


<style lang="postcss">
	.action-btn {
		width: 700px;
		margin: 10px auto;
		@apply mb-8;

		@apply flex justify-between;
	}
</style>
