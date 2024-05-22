<script lang="ts">
	import SidebarBackstageSetting from "./SidebarBackstage/SidebarBackstageSetting.svelte";
	import SidebarParticipantSlot from "./SidebarBackstage/SidebarParticipantSlot.svelte";

	let showSetting = $state(false);
	let type: "backstage" | "stage" = $state("backstage");
</script>

<SidebarParticipantSlot {type} bind:showSetting={showSetting} title="Backstage" >
	<SidebarBackstageSetting slot="setting" onclose={() => (showSetting = false)} />
</SidebarParticipantSlot>
