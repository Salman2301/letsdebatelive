<script lang="ts">
	import { setContext } from "svelte";
	import { writable, type Writable } from "svelte/store";
	import { CTX_KEY_NEW_DEBATE, CTX_KEY_HOST_PARTICIPANT, type CTX_KEY_NEW_DEBATE_TYPE, type CTX_KEY_HOST_PARTICIPANT_TYPE } from "./new-debate.constant";

  let newDebate: CTX_KEY_NEW_DEBATE_TYPE= writable({});
  let hostParticipant: CTX_KEY_HOST_PARTICIPANT_TYPE = writable({});
	
	setContext(CTX_KEY_NEW_DEBATE, newDebate);
	setContext(CTX_KEY_HOST_PARTICIPANT, hostParticipant);
</script>

<slot></slot>

<style lang="postcss">

</style>