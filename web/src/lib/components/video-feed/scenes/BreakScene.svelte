<script lang="ts">
	import { onDestroy } from 'svelte';
	import SceneLayout from './component/SceneLayout.svelte';
	import type { OnSceneChangeProps } from '../video-feed.types';

	let { payload }: OnSceneChangeProps = $props();

	let timerStr = $state('00:00:00');
	let timeoutInterval: NodeJS.Timeout;

	$effect(() => {
		if (timeoutInterval) clearInterval(timeoutInterval);

		const endTime = new Date(payload.metadata.breakEndAt);

		timeoutInterval = setInterval(() => {
			let now = Date.now();
			let diff = endTime.getTime() - now;
			if (diff <= 0) {
				timerStr = '00:00:00';
				clearInterval(timeoutInterval);
				return;
			}
			let hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
			let minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
			let seconds = Math.floor((diff % (1000 * 60)) / 1000);

			const padZero = (num: number) => (num <= 9 ? `0${num}` : num);
			timerStr = padZero(hours) + ':' + padZero(minutes) + ':' + padZero(seconds);
		}, 100);
	});

	onDestroy(() => {
		clearInterval(timeoutInterval);
	});
</script>

<SceneLayout>
	<div class="flex flex-col">
		<p class="text-center">Taking a break</p>
		<p class="text-center timer">{timerStr}</p>
	</div>
</SceneLayout>

<style lang="postcss">
	.text-center {
		font-size: 24px;
	}

	.timer {
		@apply px-4;
		border-radius: 24px;
		font-size: 32px;
		border: 1px solid white;
		@apply bg-white text-black;
		@apply mt-2;
	}
</style>
