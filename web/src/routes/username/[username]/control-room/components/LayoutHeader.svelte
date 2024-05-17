<script lang="ts">
	import TakeABreak from './TakeABreak.svelte';
	import LayoutProfileMain from './layout-setting-icon/LayoutProfileMain.svelte';
	import LayoutScreenProfile from './layout-setting-icon/LayoutScreenProfile.svelte';
	import LayoutScreen from './layout-setting-icon/LayoutScreen.svelte';
	import LayoutProfileTwo from './layout-setting-icon/LayoutProfileTwo.svelte';
	import LayoutProfileChat from './layout-setting-icon/LayoutProfileChat.svelte';

	type LayoutStyle = 'profileTwo' | 'screen' | 'screenProfile' | 'profileMain' | 'profileChat';
	export let currentLayoutStyle: LayoutStyle = 'profileTwo';
</script>

<div class="layout-setting-container">
	<div class="layout-icons">
		<button
			class="layout-icon"
			class:active={currentLayoutStyle === 'profileTwo'}
			on:click={() => (currentLayoutStyle = 'profileTwo')}
		>
			<LayoutProfileTwo />
		</button>
		<button
			class="layout-icon"
			class:active={currentLayoutStyle === 'screen'}
			on:click={() => (currentLayoutStyle = 'screen')}
			disabled
		>
			<LayoutScreen />
		</button>
		<button
			class="layout-icon"
			class:active={currentLayoutStyle === 'screenProfile'}
			on:click={() => (currentLayoutStyle = 'screenProfile')}
		>
			<LayoutScreenProfile />
		</button>
		<button
			class="layout-icon"
			class:active={currentLayoutStyle === 'profileMain'}
			on:click={() => (currentLayoutStyle = 'profileMain')}
		>
			<LayoutProfileMain />
		</button>
		<button
			class="layout-icon"
			class:active={currentLayoutStyle === 'profileChat'}
			on:click={() => (currentLayoutStyle = 'profileChat')}
		>
			<LayoutProfileChat />
		</button>
	</div>
	<div class="layout-break-end">
		<TakeABreak />
		<button class="btn-stop" on:click={() => console.log('stop broadcast')}>
			Stop Broadcast
		</button>
	</div>
</div>

<style lang="postcss">
	.layout-setting-container {
		height: 48px;
		width: 100%;
		@apply flex justify-between;
	}

	.layout-setting-container {
		@apply flex items-center;
	}

	.layout-icons {
		@apply flex gap-2;
	}

	.layout-icon {
		@apply text-secondary-dark;
	}

	.layout-icon:disabled {
		@apply text-light-gray;
		@apply cursor-not-allowed;
	}

	.layout-icon.active {
		@apply text-secondary;
	}

	.layout-break-end {
		@apply flex gap-2 items-center justify-end;
	}
	.btn-stop {
		@apply h-full;
		width: 140px;
		@apply bg-accent-red rounded;
		height: 40px;
		font-size: 14px;
	}

	.btn-stop:hover {
		@apply bg-accent-red-dark;
	}
</style>
