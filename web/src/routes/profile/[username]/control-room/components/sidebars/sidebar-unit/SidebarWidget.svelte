<script lang="ts">
	import Heading2 from "$src/lib/components/form/Heading2.svelte";
	import BackgroundWidgets from "./Widgets/BackgroundWidgets.svelte";
	import LogoWidgets from "./Widgets/LogoWidgets.svelte";
</script>

<div class="heading">
  <Heading2 content="Widgets" />
</div>

<div class="widgets">
	
	<BackgroundWidgets />

	<LogoWidgets />
</div>

<!-- <p>Background</p>
<p>Content</p>
<p>Logo</p>
<p>Water mark</p> Can be a text or image
<p>Running text</p>
<p>Freeform Overlays</p>
<p>Banner</p> -->

<style lang="postcss">
	.heading {
		@apply flex items-center my-4 justify-between;
		@apply px-4;
	}
	.widgets {
		@apply flex flex-col gap-4;
	}
</style>