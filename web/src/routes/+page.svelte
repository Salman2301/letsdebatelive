<script lang="ts">
  export let data;
  let { supabase } = data;
  $: ({ supabase } = data);

  
</script>


{#await supabase.auth.getSession()}
{:then sess}
<!-- {@debug sess} -->
{JSON.stringify(sess,null, 4)}
{/await}

<style lang="postcss">

</style>
