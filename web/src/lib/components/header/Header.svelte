<script lang="ts">
	import AccountIcon from './AccountIcon.svelte';
	import Logo from './Logo.svelte';
</script>

<div class="header-container">
	<div class="logo-container">
		<Logo />
	</div>
	<div class="end-right">
		<div class="live-logo">
			<svg
				width="130"
				height="40"
				viewBox="0 0 130 40"
				fill="none"
				xmlns="http://www.w3.org/2000/svg"
			>
				<circle cx="95" cy="20" r="14" fill="white" stroke="#7D07E4" stroke-width="2" />
				<circle cx="75" cy="20" r="14" fill="white" stroke="#7D07E4" stroke-width="2" />
				<circle cx="55" cy="20" r="14" fill="white" stroke="#7D07E4" stroke-width="2" />
				<circle cx="35" cy="20" r="14" fill="white" stroke="#7D07E4" stroke-width="2" />
			</svg>
		</div>
		<div class="user-extra">$1000</div>
		<div class="user-profile">
			<AccountIcon />
		</div>
	</div>
</div>

<style lang="postcss">
	.header-container {
		height: 76px;
		display: flex;
		align-items: center;
		padding: 0px 10px;

		justify-content: space-between;
	}

	.end-right {
		display: flex;
		gap: 80px;
		align-items: center;
	}

	.user-extra {
		color: white;
	}
</style>
