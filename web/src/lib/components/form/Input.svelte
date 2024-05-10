<script lang="ts">

  interface Props {
    value?: string;
    placeholder?: string;
    disabled?: boolean;
    type?: string;
  }
  let { value, placeholder, disabled, type }: Props = $props();

</script>

<input bind:value placeholder={placeholder} disabled={disabled} type={type}/>

<style lang="postcss">
  input {
    width: 280px;
    min-width: 40px;
    border: 1px solid var(--color-light-gray);
    @apply bg-primary-dark;
    border-radius: 40px;
    padding: 10px 20px;
  }

  input:disabled {
    @apply bg-light-gray;
    @apply cursor-not-allowed;
  }
</style>