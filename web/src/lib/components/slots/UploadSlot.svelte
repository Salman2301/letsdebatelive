<script context="module" lang="ts">
	type Props = {
		path: string;
		bucket: string;
		mime: string;
		ext: string;
	}
	export type OnSucess = (props: Props )=>void;
</script>

<script lang="ts">
	import { getSupabase } from "$src/lib/supabase";
	import { genId } from "$src/lib/utils/gen.utils";
	import { get } from "svelte/store";
	import { newToast } from "../toast/Toast.svelte";
	import { authUserData } from "$src/lib/stores/auth.store";

  type Props = {
    path: string;
    isUploading?: boolean;
    bucket: string;
		accept?: string;
		onSuccess?: OnSucess;
    children: any;
  }

  let { children, isUploading = $bindable(), bucket, path, onSuccess, accept="image/*" }: Props = $props();

  const supabase = getSupabase();
  const id = genId(4);

  async function handleFileUpload(event: any) {
		isUploading = true;
		const $authUserData = get(authUserData);
		if (!$authUserData?.id) {
			isUploading = false;
			console.error('Failed to get the user id');
			return;
		}
		const file = event.target.files[0];
		console.log({ file });
		const mime = file.type;
		const ext = mime?.split('/')?.[1] || "";
		// let location = `${uuid()}.${file.ext || 'png'}`;
		if (file) {
			const { data: fileUploaded, error: fileError } = await supabase.storage
				.from(bucket)
				.upload(path, file, {
					cacheControl: '3600',
					upsert: true
				});

			if (fileError) {
				isUploading = false;
				console.error('Error uploading file:', fileError);
				return newToast({
					type: 'error',
					message: 'Failed to upload the image! Max. 12MB and image only'
				});
			}

			onSuccess?.({
				bucket,
				path,
				mime,
				ext
			})
			setTimeout(() => {
				isUploading = false;
			}, 1000);
		}
	}

</script>

<label for="file-upload-{id}">
  {@render children?.()}
</label>
<input
  type="file"
  id="file-upload-{id}"
  class="hidden"
  accept="{accept}"
  onchange={handleFileUpload}
  disabled={isUploading}
/>

<style lang="postcss">
	label {
		@apply cursor-pointer;
	}
</style>