<script lang="ts">
	import Button from '$lib/components/button/Button.svelte';
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import StageNumber from './components/StageNumber.svelte';
	import StageTestingFeeds from './stages/StageTestingFeeds.svelte';

</script>

<Heading2 content="New debate" textAlign="center" />

<div class="stage-margin">
	<StageNumber active={1}/>
</div>

<StageTestingFeeds />

<div class="action-btn">
	<Button label="Next" color="secondary" width={120} />
</div>


<style lang="postcss">
	.stage-margin {
		@apply my-8;
	}
	.action-btn {
		width: 700px;
		margin: 0 auto;
		display: flex;
		justify-content: flex-end;
	}
</style>
