<script lang="ts">
	import SidePanel from './SidePanel.svelte';
	import SidePanelEquip from './SidePanelEquip.svelte';
	import { sidePanelKey } from './side-panel.store';
</script>

<SidePanel>
	{#if $sidePanelKey === 'equip'}
		<SidePanelEquip />
	{/if}
</SidePanel>
