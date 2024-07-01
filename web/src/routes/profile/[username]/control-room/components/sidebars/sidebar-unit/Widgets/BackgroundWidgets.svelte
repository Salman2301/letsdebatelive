<script lang="ts">
	import UploadSlot, { type OnSucess } from '$src/lib/components/slots/UploadSlot.svelte';
	import { newToast } from '$src/lib/components/toast/Toast.svelte';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { getSupabase } from '$src/lib/supabase';
	import WidgetContainer from './WidgetContainer.svelte';
	import { v4 as uuid } from 'uuid';
	import type { Tables } from '$src/lib/schema/database.types';
	import { CloseX } from '$src/lib/components/icon';
	import { newPrompt } from '$src/lib/components/prompt/Prompt.svelte';
	import Loader from '$src/lib/components/icon/Loader.svelte';

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
			type: 'background',
			user_id: $authUserData?.id!
		});

		refreshBackgrounAsset();
	};

	let assetBg: Tables<'user_asset'>[] = $state([]);
	async function refreshBackgrounAsset() {
		const { data, error } = await supabase.from('user_asset').select().eq('type', 'background');

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

	async function handleDeleteImage(itemId: string, confirmed?: boolean) {
		// Open user prompt and ask if the user want to delete the image
		// on User prompt close check if t
		if (!confirmed) {
			newPrompt({
				question: 'Are you sure you want to delete the background Image?',
				yesLabel: 'Delete',
				type: 'danger',
				onYes: () => handleDeleteImage(itemId, true)
			});
			return;
		}

		await supabase.from('user_asset').delete().eq('id', itemId);

		refreshBackgrounAsset();
	}
</script>

<WidgetContainer
	title="Background"
	desc="Upload / Select a background image that suites your brand!."
>
	<div class="content-container">
		<UploadSlot
			bucket="user_asset"
			path="{$authUserData!.id}/background/{uuid()}"
			isUploading={false}
			onSuccess={handleSucess}
		>
			<div class="image-btn add-item">+</div>
		</UploadSlot>

		{#each assetBg as asset}
			<div class="image-container">
				<button class="image-btn" class:selected={selectedId === asset.id}>
					{#await getPublicUrl(asset.path)}
						<Loader />
					{:then src}
						<img {src} alt="asset" />
					{/await}
				</button>
				<button class="image-delete" onclick={() => handleDeleteImage(asset.id)}>
					<CloseX />
				</button>
			</div>
		{/each}
	</div>
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
		font-size: 40px;
		font-weight: 100;
		@apply text-white/70;
		&:hover {
			@apply text-white;
		}
	}
	.content-container {
		@apply flex flex-wrap justify-start gap-5;
		@apply mt-2;
	}
	.image-delete {
		@apply absolute;
		@apply top-1 right-1;
		z-index: 1;
		@apply hidden;
		scale: 0.7;
		&:hover {
			@apply text-red-700;
		}
	}
	.image-container {
		@apply relative;
		&:hover .image-delete {
			@apply block;
		}
	}
</style>
