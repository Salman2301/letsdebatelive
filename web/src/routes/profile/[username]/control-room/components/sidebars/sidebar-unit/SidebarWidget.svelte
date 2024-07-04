<script lang="ts">
	import Heading2 from "$src/lib/components/form/Heading2.svelte";
	import AlertWidget from "./Widgets/AlertWidget.svelte";
	import BackgroundWidgets from "./Widgets/BackgroundWidgets.svelte";
	import LogoWidgets from "./Widgets/LogoWidgets.svelte";
	import OverlayWidget from "./Widgets/OverlayWidget.svelte";
	import RunningTextWidget from "./Widgets/RunningTextWidget.svelte";
	import SoundBoardWidget from "./Widgets/SoundBoardWidget.svelte";
	import WatermarkWidget from "./Widgets/WatermarkWidget.svelte";
	
</script>

<div class="heading">
  <Heading2 content="Widgets" />
	<p>Each widget stack up on top of each other starting from background widgets</p>
</div>

<div class="widgets">
	<BackgroundWidgets />
	<LogoWidgets />
	<WatermarkWidget />
	<OverlayWidget />
	<RunningTextWidget />
	<AlertWidget />
	<SoundBoardWidget />
	<!--
		Chat Widget
		User able to change different theme for the chat message 
	-->
</div>

<!--
<p>Content</p>
<p>Banner</p> -->

<style lang="postcss">
	.heading {
		@apply flex flex-col justify-start my-4;
		@apply px-4;
		p {
			@apply text-sm font-semibold;
			@apply text-white/50;
		}
	}
	.widgets {
		@apply flex flex-col gap-4 px-2;
	}

</style>