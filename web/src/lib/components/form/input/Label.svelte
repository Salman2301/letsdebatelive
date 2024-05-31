<script lang="ts">

  interface Props {
    label?: string;
    left?: string;
  }

  let { label = "", left = "10px" }: Props = $props();
 
</script>

<!-- svelte-ignore slot_element_deprecated -->
<div>
	<label for="" style="left:{left}">
		{label}
	</label>
  <slot></slot>
</div>

<style lang="postcss">

  div {
		position: relative;
		margin: 10px 0px;
	}
  
	label {
		/* margin-bottom: -18px; */
		@apply bg-primary-dark;
		@apply font-bold;
		font-size: 10px;
		z-index: 2;
		padding: 0px 10px;
		position: absolute;
		top: -8px;
		text-transform: capitalize;
		border-radius: 10px;
	}
</style>