<script lang="ts">
  interface Props {
    content?: string;
  }

  let { content = '' }: Props = $props();
</script>

<h1>{content}</h1>

<style lang="postcss">
  h1 {
    font-size: 54px;
  }
</style>