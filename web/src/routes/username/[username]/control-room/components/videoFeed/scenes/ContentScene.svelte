<script lang="ts">
	import type { OnSceneChangeProps } from "../video-feed.types";
	import SceneLayout from "./component/SceneLayout.svelte";

  let { payload }: OnSceneChangeProps= $props();
</script>

<SceneLayout>
  <div class="text-center">{payload.metadata.text}</div>
</SceneLayout>

<style lang="postcss">
  .text-center {
    font-size: 24px;
  }
</style>