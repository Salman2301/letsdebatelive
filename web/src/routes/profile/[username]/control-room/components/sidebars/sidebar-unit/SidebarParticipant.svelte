<script lang="ts">
	import SidebarParticipantSlot from './SidebarBackstage/SidebarParticipantSlot.svelte';

	let showSetting = $state(false);
	let type: 'backstage' | 'stage' = $state('stage');
</script>

<SidebarParticipantSlot {type} bind:showSetting title="Stage"></SidebarParticipantSlot>
