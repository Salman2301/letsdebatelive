<script lang="ts">
	import Loader from '$src/lib/components/icon/Loader.svelte';
	import WidgetContainer from './WidgetContainer.svelte';
	import UploadSlot, { type OnSucess } from '$src/lib/components/slots/UploadSlot.svelte';
	import CheckMark from '$src/lib/components/icon/CheckMark.svelte';
	import Label from '$src/lib/components/form/input/Label.svelte';
	import Fav from '$src/lib/components/icon/Fav.svelte';
	import UnFav from '$src/lib/components/icon/UnFav.svelte';

	import { PageCtx } from '$src/lib/context';
	import { newToast } from '$src/lib/components/toast/Toast.svelte';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { getSupabase } from '$src/lib/supabase';
	import { v4 as uuid } from 'uuid';
	import { CloseX } from '$src/lib/components/icon';
	import { newPrompt } from '$src/lib/components/prompt/Prompt.svelte';

	import type { Tables } from '$src/lib/schema/database.types';
	
	let selectedId: string | undefined = $state();

  let posX: number = $state(0);
  let posY: number = $state(0);

	const pageCtx = new PageCtx('control-room');
	const live_feed = pageCtx.get('ctx_table$live_feed');

	const supabase = getSupabase();

	refreshOverlayAsset();

	supabase.channel("overlay:update")
	.on("postgres_changes", { 
		event: "*",
		schema: 'public',
		table: 'live_widget_overlay',
		filter: `live_feed=eq.${$live_feed?.id}`
	}, ()=>{
		liveWidgetOverlayUpdate();
	}).subscribe();

	liveWidgetOverlayUpdate();

	async function liveWidgetOverlayUpdate() {
		if(!$live_feed?.id) return;
		const { data, error } = await supabase.from("live_widget_overlay").select().eq("live_feed", $live_feed.id);
		if (error) {
			newToast({
				type: 'error',
				message: 'Failed to get the overlay assets'
			});
		}
		selectedId = data?.[0]?.asset;
    posX = Number(data?.[0]?.pos_x || 0);
    posY = Number(data?.[0]?.pos_y || 0);
	}

	const handleSucess: OnSucess = async ({ bucket, path, ext, mime }) => {
		const { data, error } = await supabase.from('user_asset').insert({
			path,
			mime,
			type: "overlay",
			user_id: $authUserData?.id!,
			ext
		});

		refreshOverlayAsset();
	};

	let assetBg: Tables<'user_asset'>[] = $state([]);
	async function refreshOverlayAsset() {
		const { data, error } = await supabase.from('user_asset')
			.select()
			.eq('type', 'overlay')
			.order('fav', { ascending: false });

		if (error) {
			newToast({
				type: 'error',
				message: 'Failed to get the overlay assets'
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

	async function handleDeleteBg(itemId: string, confirmed?: boolean) {
		// Open user prompt and ask if the user want to delete the image
		// on User prompt close check if t
		if (!confirmed) {
			newPrompt({
				question: 'Are you sure you want to delete the overlay?',
				yesLabel: 'Delete',
				type: 'danger',
				onYes: () => handleDeleteBg(itemId, true)
			});
			return;
		}

		await supabase.from('user_asset').delete().eq('id', itemId);

		refreshOverlayAsset();
	}

	async function handleFavBg(itemId: string, isFav?: boolean) {
		await supabase.from("user_asset").update({
			fav: isFav
		}).eq("id", itemId)
	}

  async function handleSaveOverlay() {
    if(!$live_feed?.id) return;
		console.log({ posX, posY, selectedId });
    await supabase.from("live_widget_overlay").upsert({
      live_feed: $live_feed?.id!,
      widget_type: "overlay",
      asset: selectedId!,
      pos_x: Number(posX),
      pos_y: Number(posY)
    });
  }
</script>

<WidgetContainer
	title="Overlay"
	desc="Add an image / video that will be shown on top of the live feed."
	expand={false}
>
	<div class="content-container">
		{#each assetBg as asset}
			<div class="overlay-container">
				<div class="overlay-overlay">
				</div>
				<button
					class="overlay-btn"
					class:selected={selectedId === asset.id}
					onclick={()=>{
            selectedId = asset.id;
            handleSaveOverlay()
          }}
				>
					{#await getPublicUrl(asset.path)}
						<Loader />
					{:then src}
						{#if asset.mime && asset.mime.includes('video')}
							<video {src} muted>
								<track kind="captions" />
							</video>
						{:else}
							<img {src} alt="asset" />
						{/if}
					{/await}
				</button>
				<button class="overlay-pos action-delete" onclick={() => handleDeleteBg(asset.id)}>
					<CloseX />
				</button>
				<button
					class="overlay-pos action-fav"
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
				{#if asset.ext}
					<div class="overlay-pos overlay-type">{asset.ext}</div>
				{/if}
				{#if asset.id === selectedId}
					<div class="overlay-pos overlay-selected">
						<CheckMark />
					</div>
				{/if}
			</div>
		{/each}
	</div>

	<div class="footer-container">
		{#if $authUserData}
			<UploadSlot
				bucket="user_asset"
				path="{$authUserData!.id}/overlay/{uuid()}"
				isUploading={false}
				accept="image/*,video/*"
				onSuccess={handleSucess}
			>
				<div class="add-item">Upload a overlay</div>
			</UploadSlot>
		{/if}
	</div>

  <div class="pos-container">
    <Label label="Position X"  >
      <input type="text" class="in-pos" bind:value={posX} onblur={handleSaveOverlay} />
    </Label>
    <Label label="Position Y" >
      <input type="text" class="in-pos" bind:value={posY} onblur={handleSaveOverlay} />
    </Label>
  </div>
</WidgetContainer>

<style lang="postcss">
	.overlay-btn {
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
	.overlay-pos {
		@apply absolute;
		@apply top-1 right-1;
		z-index: 1;
		width: 20px;
		@apply hidden;
	}
	.overlay-overlay {
		@apply absolute;
		@apply top-0 right-0 left-0 bottom-0;
		@apply pointer-events-none;
	}
	.overlay-type {
		@apply bottom-1 right-2;
		top: unset;
		width: unset;
		@apply outline-none;
		@apply bg-white text-black rounded;
		@apply px-1;
		@apply text-xs;
		height: 20px;
	}
	.overlay-selected {
		@apply block;
		@apply top-0 left-0;
		scale: 0.7;
		@apply p-1;
	}
	.action-delete {
		@apply top-1 right-1;
		scale: 0.7;
		&:hover {
			@apply text-red-700;
		}
	}
	.action-fav {
		@apply bottom-1 left-1;
		top: unset;
		scale: 0.7;
		&.is-fav {
			@apply block;
		}
		&:hover {
			@apply text-yellow-400;
		}
	}
	.overlay-container {
		@apply relative;
		&:hover {
			.overlay-pos {
				@apply block;
			}
			.overlay-overlay {
				@apply bg-black/40;
			}
		}
	}

  .pos-container {
    @apply flex flex-row justify-start gap-4;
    @apply mt-2;
  }

  .in-pos {
    @apply w-24 h-10 rounded;
    @apply px-2;
    @apply text-center;
  }
</style>
