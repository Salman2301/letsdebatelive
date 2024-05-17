<script lang="ts">
</script>

<div class="container">
	<button> Take a break </button>
	<select>
		<option value="5min" selected >5 mins</option>
		<option value="10min">10 mins</option>
		<option value="15min">15 mins</option>
		<option value="20min">20 mins</option>
	</select>
</div>

<style lang="postcss">
  .container {
    @apply rounded overflow-hidden;
    @apply flex justify-center;
    height: 40px;
    width: fit-content;
  }
  button {
    @apply bg-secondary;
    @apply border-r border-light-gray;
    font-size: 12px;
    @apply h-full;
    width: 120px;
    @apply rounded-tl rounded-bl;
  }

  button:focus {
    outline: none;
  }
  select {
    @apply bg-secondary;
    @apply h-full;
    font-size: 12px;
    @apply rounded-tr rounded-br;
  }

  button:hover {
    @apply bg-secondary-dark;
  }
  select:hover {
    @apply bg-secondary-dark;
  }
</style>
