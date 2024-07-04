<script lang="ts">
	import Loader from '$src/lib/components/icon/Loader.svelte';
	import WidgetContainer from './WidgetContainer.svelte';
	import UploadSlot, { type OnSucess } from '$src/lib/components/slots/UploadSlot.svelte';
	import PositionalBox from './components/PositionalBox.svelte';
	import Fav from '$src/lib/components/icon/Fav.svelte';
	import UnFav from '$src/lib/components/icon/UnFav.svelte';

	import { PageCtx } from '$src/lib/context';
	import { newToast } from '$src/lib/components/toast/Toast.svelte';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { getSupabase } from '$src/lib/supabase';
	import { v4 as uuid } from 'uuid';
	import { CheckMark, CloseX } from '$src/lib/components/icon';
	import { newPrompt } from '$src/lib/components/prompt/Prompt.svelte';

	import type { Tables } from '$src/lib/schema/database.types';

	let selectedId: string | undefined = $state();
	const supabase = getSupabase();

	const pageCtx = new PageCtx('control-room');
	const live_feed = pageCtx.get('ctx_table$live_feed');

	let rowIndex = $state(0);
	let colIndex = $state(0);

	supabase.channel("logo:update")
	.on("postgres_changes", { 
		event: "*",
		schema: 'public',
		table: 'live_widget_background',
		filter: `live_feed=eq.${$live_feed?.id}`
	}, ()=>{
		liveWidgetLogoUpdate();
	}).subscribe();

	liveWidgetLogoUpdate();

	refreshBackgrounAsset();

	const handleSucess: OnSucess = async ({ bucket, path }) => {
		const { data, error } = await supabase.from('user_asset').insert({
			path,
			type: 'logo',
			user_id: $authUserData?.id!
		});

		refreshBackgrounAsset();
	};

	let assetBg: Tables<'user_asset'>[] = $state([]);
	async function refreshBackgrounAsset() {
		const { data, error } = await supabase.from('user_asset').select().eq('type', 'logo');

		if (error) {
			newToast({
				type: 'error',
				message: 'Failed to get the logo assets'
			});
		}
		assetBg = data || [];
	}

	async function getPublicUrl(path: string) {
		const { data, error } = await supabase.storage
			.from('user_asset')
			.createSignedUrl(path, 60 * 60 * 1);
		return data?.signedUrl;
	}

	async function handleDeleteImage(itemId: string, confirmed?: boolean) {
		// Open user prompt and ask if the user want to delete the image
		// on User prompt close check if t
		if (!confirmed) {
			newPrompt({
				question: 'Are you sure you want to delete the logo Image?',
				yesLabel: 'Delete',
				type: 'danger',
				onYes: () => handleDeleteImage(itemId, true)
			});
			return;
		}

		await supabase.from('user_asset').delete().eq('id', itemId);

		refreshBackgrounAsset();
	}

	async function handleFavBg(itemId: string, isFav?: boolean) {
		await supabase.from("user_asset").update({
			fav: isFav
		}).eq("id", itemId)
	}

	async function liveWidgetLogoUpdate() {
		if(!$live_feed?.id) return;
		const { data, error } = await supabase.from("live_widget_logo").select().eq("live_feed", $live_feed.id);
		if (error) {
			newToast({
				type: 'error',
				message: 'Failed to get the logo assets'
			});
		}
		let item = data?.[0];
		if( !item ) return;
		selectedId = item.asset;
		rowIndex = item.pos_row_index || 0;
		colIndex = item.pos_col_index || 0;
	}

	async function handleSelect(assetId: string) {
		const { data, error } =await supabase.from("live_widget_logo").upsert({
			live_feed: $live_feed?.id!,
			widget_type: "logo",
			asset: assetId,
			pos_row_index: rowIndex,
			pos_col_index: colIndex
		});
		selectedId = assetId;
	}
	
	async function updateWidgetPos() {
		const { data, error } = await supabase.from("live_widget_logo").update({
			pos_row_index: rowIndex,
			pos_col_index: colIndex
		})
		.eq("live_feed", $live_feed?.id!)
		.eq("widget_type", "logo");
	}
</script>

<WidgetContainer
	title="Logo"
	desc="Upload / Select a your logo that suites your brand!"
	expand={false}
>
	<div class="content-container">
		{#each assetBg as asset}
			<div class="image-container">
				<button
					class="image-btn"
					class:selected={selectedId === asset.id}
					onclick={()=>handleSelect(asset.id)}
				>
					{#await getPublicUrl(asset.path)}
						<Loader />
					{:then src}
						<img {src} alt="asset" />
					{/await}
				</button>
				<div class="bg-overlay">
				</div>
				<button class="pos-abs" onclick={() => handleDeleteImage(asset.id)}>
					<CloseX />
				</button>
				{#if asset.id === selectedId}
					<button class="pos-abs icon-selected">
						<CheckMark />
					</button>
				{/if}
				<button
					class="pos-abs action-fav"
					class:is-fav={asset.fav}
					onclick={() => {
						asset.fav = !asset.fav;
						handleFavBg(asset.id, !!asset.fav);
					}}
				>
					{#if asset.fav}
						<Fav />
					{:else}
						<UnFav />
					{/if}
				</button>
			</div>
		{/each}
	</div>

	<div class="footer-container">
		<UploadSlot
			bucket="user_asset"
			path="{$authUserData!.id}/logo/{uuid()}"
			isUploading={false}
			onSuccess={handleSucess}
		>
			<div class="add-item">Upload a logo</div>
		</UploadSlot>
	</div>
	<!-- setInitBox={{ colIndex: 2, rowIndex: 1}} -->

	<PositionalBox
		onBoxChange={updateWidgetPos}
		bind:rowIndex={rowIndex}
		bind:colIndex={colIndex}
	/>
</WidgetContainer>

<style lang="postcss">
	.image-btn {
		aspect-ratio: 16/9;
		@apply rounded;
		@apply border border-light-gray;
		width: 140px;
		overflow: hidden;
		@apply flex items-center justify-center;

		&.selected {
			@apply border border-white;
		}
	}

	.add-item {
		font-size: 14px;
		font-weight: 100;
		@apply bg-white/20;
		width: 180px;
		@apply mt-2;
		@apply text-center;
		@apply rounded;
		&:hover {
			@apply bg-primary/60;
		}
	}
	.content-container {
		@apply flex flex-wrap justify-start gap-5;
		@apply mt-2;
	}
	.pos-abs {
		@apply absolute;
		@apply top-1 right-1;
		z-index: 1;
		@apply outline-none;
		@applyw hidden;
		scale: 0.7;
		&:hover {
			@apply text-red-700;
		}
	}
	.bg-overlay {
		@apply absolute;
		@apply top-0 right-0 left-0 bottom-0;
		@apply pointer-events-none;
	}
	.action-fav {
		@apply bottom-1 left-1;
		top: unset;
		scale: 0.7;
		right:unset;
		&.is-fav {
			@apply block;
		}
		&:hover {
			@apply text-yellow-400;
		}
	}
	.icon-selected {
		@apply top-1 left-1;
		right: unset;
	}
	.image-container {
		@apply relative;
		&:hover {
			.bg-overlay {
				@apply bg-black/40;
			}
			.pos-abs {
				@apply block;
			}
		}
	}
</style>
