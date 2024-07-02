<script lang="ts">
	import Label from '$src/lib/components/form/input/Label.svelte';
	import WidgetContainer from './WidgetContainer.svelte';
</script>

<WidgetContainer
	title="Running Text"
	desc="This widget shows the running text of the current session."
	expand={true}
>
	<textarea class="w-full h-full" placeholder="Type a running text here and use ✨ as you please."
	></textarea>

	<div class="footer-container">
		<div class="in-colors">
			<div class="background-color">
				<Label label="Background">
					<input type="color" value="#ffffff" />
				</Label>
			</div>
			<div class="text-color">
				<Label label="Text">
					<input type="color" value="#000000" />
				</Label>
			</div>
		</div>
		<Label label="Position">
			<select placeholder="Position">
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
