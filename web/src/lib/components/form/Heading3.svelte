<script lang="ts">
  interface Props {
    content?: string;
  }

  let { content = '' }: Props = $props();
</script>

<h2>{content}</h2>

<style lang="postcss">
  h2 {
    font-size: 18px;
  }
</style>