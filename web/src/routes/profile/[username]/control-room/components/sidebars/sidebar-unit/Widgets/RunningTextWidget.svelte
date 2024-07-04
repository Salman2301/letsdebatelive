<script lang="ts">
	import Label from '$src/lib/components/form/input/Label.svelte';
	import WidgetContainer from './WidgetContainer.svelte';

	import { PageCtx } from '$src/lib/context';
	import { onMount } from 'svelte';
	import { newToast } from '$src/lib/components/toast/Toast.svelte';
	import { getSupabase } from '$src/lib/supabase';

	let textRunning = $state('');
	let colorBackground = $state('#ffffff');
	let colorText = $state('#000000');
	let position = $state('bottom');

	let pageCtx = new PageCtx('control-room');
	const live_feed = pageCtx.get('ctx_table$live_feed');

	const supabase = getSupabase();

	onMount(()=>{
		if(!$live_feed?.id) return;

		supabase.channel('running_text:update')
		.on('postgres_changes', {
			event: '*',
			schema: 'public',
			table: 'live_widget_running_text',
			filter: `live_feed=eq.${$live_feed?.id}`
		}, ()=>{
			liveWidgetRunningTextUpdate();
		}).subscribe();
		liveWidgetRunningTextUpdate();
	});

	async function liveWidgetRunningTextUpdate() {
		if(!$live_feed?.id) return;
		const { data, error } = await supabase.from("live_widget_running_text").select().eq("live_feed", $live_feed.id);
		if (error) {
			newToast({
				type: 'error',
				message: 'Failed to get the running text assets'
			});
			return;
		}
		textRunning = data?.[0]?.text || '';
		colorBackground = data?.[0]?.color_background || '#ffffff';
		colorText = data?.[0]?.color_text || '#000000';
		position = data?.[0]?.position || 'bottom';
	}

	async function handleSaveRunningText() {
		if(!$live_feed?.id) return;
		await supabase.from("live_widget_running_text").upsert({
			live_feed: $live_feed.id,
			text: textRunning,
			color_background: colorBackground,
			color_text: colorText,
			position: position
		});
	}

</script>

<WidgetContainer
	title="Running Text"
	desc="This widget shows the running text of the current session."
	expand={false}
>
	<textarea class="w-full h-full" placeholder="Type a running text here and use ✨ as you please." bind:value={textRunning} onblur={handleSaveRunningText}></textarea>

	<div class="footer-container">
		<div class="in-colors">
			<div class="background-color">
				<Label label="Background">
					<input type="color" bind:value={colorBackground} onchange={handleSaveRunningText} />
				</Label>
			</div>
			<div class="text-color">
				<Label label="Text">
					<input type="color" bind:value={colorText} onchange={handleSaveRunningText}/>
				</Label>
			</div>
		</div>
		<Label label="Position">
			<select placeholder="Position" bind:value={position} onchange={handleSaveRunningText}>
				<option value="top">Top</option>
				<option value="bottom">Bottom</option>
				<option value="none">None</option>
			</select>
		</Label>
	</div>
</WidgetContainer>

<style lang="postcss">
	textarea {
		@apply border border-light-gray rounded;
		@apply bg-primary-dark;
		@apply p-2;
		@apply mt-2;
	}

	select {
		@apply border border-light-gray rounded;
		@apply bg-primary-dark;
		@apply py-2;
		width: 180px;
	}
	.footer-container {
		@apply flex flex-row justify-between;
	}
  .in-colors {
    @apply flex flex-row justify-between gap-4;
    input {
      width: 90px;
      height: 40px;
    }
  }
</style>
