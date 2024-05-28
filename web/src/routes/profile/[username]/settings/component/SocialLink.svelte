<script lang="ts">
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import { CheckMark, CloseX } from '$lib/components/icon';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	import { getSupabase } from '$lib/supabase';
	import { getContext, onMount, tick } from 'svelte';
	import { getSocialIcon } from '$lib/components/icon/socials/index.svelte';

	import type { Tables } from '$lib/schema/database.types';

	let newSocialLink: string = $state('');
	let showSubmitBtn: boolean = $derived(!!newSocialLink);
	let isNotValid: boolean = $derived(showSubmitBtn && !newSocialLink.startsWith('https://'));
	let socialLinks: Tables<'social_links'>[] = $state([]);

	const supabase = getSupabase(getContext);

	async function onKeydownChange(event: KeyboardEvent) {
		await tick();
		if (event.key === 'Escape') {
			newSocialLink = '';
			(event.target as HTMLInputElement).blur?.();
			return;
		}
		if (event.key === 'Enter') {
			submit();
			(event.target as HTMLInputElement).blur?.();
			return;
		}
	}

	onMount(() => {
		fetchSocialLinks();
	});

	async function fetchSocialLinks() {
		const { data, error } = await supabase.from('social_links').select();
		socialLinks = data || [];
	}

	async function submit() {
		try {
			new URL(newSocialLink); // throws error

			const { data, error } = await supabase.from('social_links').insert({
				link: newSocialLink
			});

			if (error) {
				return newToast({
					type: 'error',
					message: 'Failed to add new social link'
				});
			}

			newSocialLink = '';
			fetchSocialLinks();
		} catch (e) {
			console.error(e);
			newToast({
				type: 'error',
				message: 'Failed to add social link'
			});
		}
	}

	async function deleteItem(id: string) {
		const { data, error } = await supabase.from('social_links').delete().eq('id', id);

		if (error) {
			return newToast({
				type: 'error',
				message: 'Failed to delete social link'
			});
		}

		fetchSocialLinks();
	}
</script>

<div class="my-2 mb-4">
	<Heading2 content="Social Links"></Heading2>
</div>

{#if socialLinks.length > 0}
	<div class="social-link-items">
		{#each socialLinks as socialLink}
			<div class="social-link-item">
				<div class="social-link-icon">
					<div class="icon">
						<svelte:component this={getSocialIcon(socialLink.link)} />
					</div>
				</div>
				<div class="social-link-url"><a href={socialLink.link}>{socialLink.link}</a></div>
				<button onclick={() => deleteItem(socialLink.id)} class="social-link-close">
					<CloseX />
				</button>
			</div>
		{/each}
	</div>
{/if}

<div class="new-social-container">
	<input
		class="social-new-input"
		placeholder="+ Add a social link  (https://facebook.com/username)"
		bind:value={newSocialLink}
		onkeydown={onKeydownChange}
		class:has-error={isNotValid}
	/>

	<button class="btn-new-social" onclick={submit} class:hidden={!showSubmitBtn}>
		<CheckMark />
	</button>
</div>

{#if isNotValid}
	<p class="text-accent-red font-semibold">
		Enter a valid url like https://facebook.com/your_username
	</p>
{/if}

<style lang="postcss">
	.new-social-container {
		@apply relative;
	}
	.social-new-input {
		height: 40px;
		@apply w-full;
		@apply px-2 mt-2;
		@apply outline-none border-0 bg-transparent;
		@apply border-b border-b-light-gray;
		@apply mb-4;

		&:hover {
			@apply border-white;
		}

		&.has-error {
			@apply border-accent-red;
		}
	}

	.btn-new-social {
		@apply absolute;
		right: 10px;
		top: 20px;
	}

	.btn-new-social.hidden {
		visibility: hidden;
	}

	.social-link-items {
		@apply border border-light-gray;
		@apply rounded;
	}
	.social-link-item {
		@apply flex justify-between items-center;
		@apply border-b border-light-gray;
		height: 40px;
		@apply px-2;
	}

	.social-link-icon {
		@apply border-r border-light-gray;
		@apply pr-2;
		height: 40px;
		@apply flex items-center;
	}
	.social-link-close {
		&:hover {
			@apply text-accent-red;
		}
	}

	.icon {
		scale: 1.2;
	}
	.social-link-item:last-child {
		@apply border-none;
	}

	.social-link-url {
		@apply text-left pl-2 w-full;
	}
</style>
