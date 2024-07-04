<script lang="ts">
	import Loader from '$src/lib/components/icon/Loader.svelte';
	import WidgetContainer from './WidgetContainer.svelte';
	import UploadSlot, { type OnSucess } from '$src/lib/components/slots/UploadSlot.svelte';
	import PositionalBox from './components/PositionalBox.svelte';
	import Fav from '$src/lib/components/icon/Fav.svelte';
	import UnFav from '$src/lib/components/icon/UnFav.svelte';
	import Label from '$src/lib/components/form/input/Label.svelte';

	import { newToast } from '$src/lib/components/toast/Toast.svelte';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { getSupabase } from '$src/lib/supabase';
	import { onDestroy, onMount } from 'svelte';
	import { v4 as uuid } from 'uuid';
	import { CheckMark, CloseX } from '$src/lib/components/icon';
	import { newPrompt } from '$src/lib/components/prompt/Prompt.svelte';
	import { PageCtx } from '$src/lib/context';

	import type { Tables } from '$src/lib/schema/database.types';
	import type { RealtimeChannel } from '@supabase/supabase-js';

	let pageCtx = new PageCtx('control-room');
	const live_feed = pageCtx.get('ctx_table$live_feed');

	let selectedId: string | undefined = $state();
	let rowIndex = $state(0);
	let colIndex = $state(0);
	let textWatermark = $state('');

	const supabase = getSupabase();

	let watermarkType: 'text' | 'image' = $state('text');


	let supabaseChannel: RealtimeChannel = supabase.channel('watermark:update').on(
		'postgres_changes',
		{
			event: '*',
			schema: 'public',
			table: 'live_widget_watermark',
			filter: `live_feed=eq.${$live_feed?.id}`
		},
		() => liveWidgetWatermarkUpdate()
	);

	onMount(() => {
		if ($live_feed?.id) {
			supabaseChannel.subscribe();
			liveWidgetWatermarkUpdate();
		}
		refreshBackgrounAsset();
	});

	onDestroy(() => {
		supabaseChannel.unsubscribe();
	});

	async function liveWidgetWatermarkUpdate() {
		if (!$live_feed?.id) return;
		const { data, error } = await supabase
			.from('live_widget_watermark')
			.select()
			.eq('live_feed', $live_feed.id);
		if (error) {
			newToast({
				type: 'error',
				message: 'Failed to get the watermark assets'
			});
		}
		watermarkType = data?.[0]?.type === 'image' ? 'image' : 'text';
		selectedId = data?.[0]?.image_asset || undefined;
		textWatermark = data?.[0]?.text_value || '';
		rowIndex = data?.[0]?.pos_row_index || 0;
		colIndex = data?.[0]?.pos_col_index || 0;
	}

	const handleSucess: OnSucess = async ({ bucket, path }) => {
		const { data, error } = await supabase.from('user_asset').insert({
			path,
			type: 'watermark',
			user_id: $authUserData?.id!
		});

		refreshBackgrounAsset();
	};

	let assetBg: Tables<'user_asset'>[] = $state([]);
	async function refreshBackgrounAsset() {
		const { data, error } = await supabase.from('user_asset').select().eq('type', 'watermark');

		if (error) {
			newToast({
				type: 'error',
				message: 'Failed to get the watermark assets'
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
				question: 'Are you sure you want to delete the watermark Image?',
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
		await supabase
			.from('user_asset')
			.update({
				fav: isFav
			})
			.eq('id', itemId);
	}

	async function handleSaveWatermark() {
		if (!$live_feed?.id) return;

		await supabase.from('live_widget_watermark').upsert({
			live_feed: $live_feed.id,
			type: watermarkType,
			image_asset: watermarkType === 'image' ? selectedId : null,
			text_value: watermarkType === 'text' ? textWatermark : null,
			pos_row_index: rowIndex,
			pos_col_index: colIndex
		});
	}
</script>

<WidgetContainer
	title="Watermark"
	desc="Upload / Select a your watermark that suites your brand!"
	expand={false}
>
	<Label label="Type">
		<select name="watermark" class="drop-watermark" bind:value={watermarkType}>
			<option value="text">Text</option>
			<option value="image">Image</option>
		</select>
	</Label>

	{#if watermarkType === 'text'}
		<div class="text-container">
			<textarea
				class="w-full h-full"
				placeholder="Enter a watermark text here"
				bind:value={textWatermark}
				onblur={handleSaveWatermark}
			></textarea>
		</div>
	{:else if watermarkType === 'image'}
		<div class="content-container">
			{#each assetBg as asset}
				<div class="image-container">
					<button
						class="image-btn"
						class:selected={selectedId === asset.id}
						onclick={() => {
							selectedId = asset.id;
							handleSaveWatermark();
						}}
					>
						{#await getPublicUrl(asset.path)}
							<Loader />
						{:then src}
							<img {src} alt="asset" />
						{/await}
					</button>
					<div class="bg-overlay"></div>
					<button class="image-action" onclick={() => handleDeleteImage(asset.id)}>
						<CloseX />
					</button>
					{#if selectedId === asset.id}
						<button class="image-action image-selected">
							<CheckMark />
						</button>
					{/if}
					<button
						class="image-action action-fav"
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
				path="{$authUserData!.id}/watermark/{uuid()}"
				isUploading={false}
				onSuccess={handleSucess}
			>
				<div class="add-item">Upload a watermark</div>
			</UploadSlot>
		</div>
	{/if}

	<PositionalBox bind:rowIndex bind:colIndex onBoxChange={handleSaveWatermark} />
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

	.drop-watermark {
		@apply bg-primary-dark/50;
		width: 120px;
		@apply rounded border border-light-gray;
		@apply py-2 px-4;
	}

	textarea {
		@apply border border-light-gray rounded;
		@apply bg-primary-dark;
		@apply p-2;
		@apply mt-2;
	}

	.content-container {
		@apply flex flex-wrap justify-start gap-5;
		@apply mt-2;
	}
	.image-action {
		@apply absolute;
		@apply top-1 right-1;
		@apply outline-none;
		z-index: 1;
		@apply hidden;
		scale: 0.7;
		&:hover {
			@apply text-red-700;
		}
	}
	.action-fav {
		@apply bottom-1 left-1;
		scale: 0.7;
		top: unset;
		right: unset;
		&.is-fav {
			@apply block;
		}
		&:hover {
			@apply text-yellow-400;
		}
	}
	.bg-overlay {
		@apply absolute;
		@apply top-0 right-0 left-0 bottom-0;
		@apply pointer-events-none;
	}
	.image-container {
		@apply relative;
		&:hover {
			.image-action {
				@apply block;
			}
			.bg-overlay {
				@apply bg-black/40;
			}
		}
	}
	.image-selected {
		@apply top-1 left-1;
		right: unset;
		@apply block;
	}
</style>
