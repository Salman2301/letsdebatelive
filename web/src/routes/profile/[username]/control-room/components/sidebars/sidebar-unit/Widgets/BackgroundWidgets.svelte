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
	import Fav from '$src/lib/components/icon/Fav.svelte';
	import UnFav from '$src/lib/components/icon/UnFav.svelte';

	type Props = {
		selectedId?: string;
	};

	// show extensiom

	let { selectedId }: Props = $props();

	const supabase = getSupabase();

	$effect(() => {
		refreshBackgrounAsset();
	});

	const handleSucess: OnSucess = async ({ bucket, path, ext, mime }) => {
		const { data, error } = await supabase.from('user_asset').insert({
			path,
			mime,
			type: 'background',
			user_id: $authUserData?.id!,
			ext
		});

		refreshBackgrounAsset();
	};

	let assetBg: Tables<'user_asset'>[] = $state([]);
	async function refreshBackgrounAsset() {
		const { data, error } = await supabase.from('user_asset')
			.select()
			.eq('type', 'background')
			.order('fav', { ascending: false });

		if (error) {
			newToast({
				type: 'error',
				message: 'Failed to get the background assets'
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
				question: 'Are you sure you want to delete the background?',
				yesLabel: 'Delete',
				type: 'danger',
				onYes: () => handleDeleteBg(itemId, true)
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
	title="Background"
	desc="Upload / Select a background image / video that suites your brand!."
	expand={false}
>
	<div class="content-container">
		{#each assetBg as asset}
			<div class="bg-container">
				<div class="bg-overlay">
				</div>
				<button class="bg-btn" class:selected={selectedId === asset.id}>
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
				<button class="bg-pos action-delete" onclick={() => handleDeleteBg(asset.id)}>
					<CloseX />
				</button>
				<button
					class="bg-pos action-fav"
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
					<div class="bg-pos bg-type">{asset.ext}</div>
				{/if}
			</div>
		{/each}
	</div>

	<div class="footer-container">
		{#if $authUserData}
			<UploadSlot
				bucket="user_asset"
				path="{$authUserData!.id}/background/{uuid()}"
				isUploading={false}
				accept="image/*,video/*"
				onSuccess={handleSucess}
			>
				<div class="add-item">Upload a background</div>
			</UploadSlot>
		{/if}
	</div>
</WidgetContainer>

<style lang="postcss">
	.bg-btn {
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
	.bg-pos {
		@apply absolute;
		@apply top-1 right-1;
		z-index: 1;
		width: 20px;
		@apply hidden;
	}
	.bg-overlay {
		@apply absolute;
		@apply top-0 right-0 left-0 bottom-0;
	}
	.bg-type {
		@apply bottom-1 right-2;
		top: unset;
		width: unset;
		@apply outline-none;
		@apply bg-white text-black rounded;
		@apply px-1;
		@apply text-xs;
		height: 20px;
	}
	.action-delete {
		@apply top-1 right-1;
		scale: 0.7;
		&:hover {
			@apply text-red-700;
		}
	}
	.action-fav {
		@apply top-1 left-1;
		scale: 0.7;
		&.is-fav {
			@apply block;
		}
		&:hover {
			@apply text-yellow-400;
		}
	}
	.bg-container {
		@apply relative;
		&:hover {
			.bg-pos {
				@apply block;
			}
			.bg-overlay {
				@apply bg-black/40;
			}
		}
	}
</style>
