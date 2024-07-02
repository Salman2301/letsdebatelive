<script lang="ts">
	import Loader from '$src/lib/components/icon/Loader.svelte';
	import WidgetContainer from './WidgetContainer.svelte';
	import UploadSlot, { type OnSucess } from '$src/lib/components/slots/UploadSlot.svelte';

	import { newToast } from '$src/lib/components/toast/Toast.svelte';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { getSupabase } from '$src/lib/supabase';
	import { v4 as uuid } from 'uuid';
	import { CloseX } from '$src/lib/components/icon';
	import { newPrompt } from '$src/lib/components/prompt/Prompt.svelte';

	import type { Tables } from '$src/lib/schema/database.types';
	import PositionalBox from './components/PositionalBox.svelte';
	import Fav from '$src/lib/components/icon/Fav.svelte';
	import UnFav from '$src/lib/components/icon/UnFav.svelte';

	type Props = {
		selectedId?: string;
	};

	let { selectedId }: Props = $props();

	const supabase = getSupabase();

	$effect(() => {
		refreshBackgrounAsset();
	});

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
		await supabase.from("user_asset").update({
			fav: isFav
		}).eq("id", itemId)
	}
</script>

<WidgetContainer
	title="Watermark"
	desc="Upload / Select a your watermark that suites your brand!"
>
	<div class="content-container">
		{#each assetBg as asset}
			<div class="image-container">
				<button class="image-btn" class:selected={selectedId === asset.id}>
					{#await getPublicUrl(asset.path)}
						<Loader />
					{:then src}
						<img {src} alt="asset" />
					{/await}
				</button>
				<div class="bg-overlay">
				</div>
				<button class="image-action" onclick={() => handleDeleteImage(asset.id)}>
					<CloseX />
				</button>
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

	<PositionalBox setInitBox={{ colIndex: 2, rowIndex: 1}} onBoxChange={console.log}	/>
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
			@apply border border-secondary;
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
		@apply top-1 left-1;
		scale: 0.7;
		right:unset;
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
</style>
