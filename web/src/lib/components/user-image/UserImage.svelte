<script lang="ts">
	import { NO_PROFILE_DEFAULT } from '$src/lib/constatnt/file';
	import { authUserData } from '$src/lib/stores/auth.store';
	import { getSupabase } from '$src/lib/supabase';
	import { getContext } from 'svelte';

	import type { Tables } from '$src/lib/schema/database.types';

  interface Props {
    user: Tables<"user_data"> | null;
  }

  let { user }: Props = $props();

	const supabase = getSupabase(getContext);

	function getProfileImage(): string {
		if (!user?.profile_image) return NO_PROFILE_DEFAULT;

		const url = supabase.storage.from('profile_image').getPublicUrl(user?.profile_image!, {
			transform: {
				height: 200,
				width: 200,
				resize: 'cover'
			}
		}).data.publicUrl;

		return url || NO_PROFILE_DEFAULT;
	}
</script>


{#if user?.profile_image}
  <img src={getProfileImage()} alt="user profile" />
{:else}
  <span class="img">
    {user?.displayName?.[0]?.toUpperCase() || "A"}
  </span>
{/if}

<style lang="postcss">
  img {
		width: 40px;
		height: 40px;
		border-radius: 100%;
		@apply bg-light-gray;
		overflow: hidden;
  }

  .img {
    width: 40px;
    height: 40px;
    user-select: none;
    @apply cursor-pointer;
    background-color: rgb(103, 103, 103);
    @apply flex items-center justify-center;
    @apply rounded-full;
  }
</style>
