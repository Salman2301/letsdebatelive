<script context="module" lang="ts">
	export type OnSucess = ({ path, bucket }: { path: string, bucket: string})=>void;
</script>

<script lang="ts">
	import { getSupabase } from "$src/lib/supabase";
	import { genId } from "$src/lib/utils/gen.utils";
	import { get } from "svelte/store";
	import { newToast } from "../toast/Toast.svelte";
	import { authUserData } from "$src/lib/stores/auth.store";

  type Props = {
    path: string;
    isUploading: boolean;
    bucket: string;
		onSuccess: OnSucess;
    children: any;
  }

  let { children, isUploading = $bindable(), bucket, path, onSuccess }: Props = $props();

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

			onSuccess({
				bucket,
				path
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
  accept="image/*"
  onchange={handleFileUpload}
  disabled={isUploading}
/>

<style lang="postcss">

</style>