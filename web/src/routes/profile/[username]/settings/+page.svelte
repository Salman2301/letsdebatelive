<script lang="ts">
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import Input from '$lib/components/form/input/Input.svelte';
	import Textarea from '$lib/components/form/textarea/Textarea.svelte';
	import Button from '$lib/components/button/Button.svelte';
	import SocialLink from './component/SocialLink.svelte';
	import Loader from "$lib/components/icon/Loader.svelte";
	import UpdatePassword from './component/UpdatePassword.svelte';
	import UserImage from '$src/lib/components/user-image/UserImage.svelte';

	import { v4 as uuid } from 'uuid';
	import { authUserData } from '$lib/stores/auth.store';
	import { getSupabase } from '$lib/supabase';
	import { getContext } from 'svelte';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	import { goto } from '$app/navigation';
	import { NO_PROFILE_DEFAULT } from '$src/lib/constatnt/file';

	const supabase = getSupabase(getContext);
	let isUploading = $state(false);
	let basicForm = $derived({
		initials: $authUserData?.initials || 'Mr.',
		firstName: $authUserData?.firstName || '',
		lastName: $authUserData?.lastName || '',
		displayName: $authUserData?.displayName || '',
		oneLineDesc: $authUserData?.oneLineDesc || '',
		username: $authUserData?.username || '',
		email: $authUserData?.email || ''
	});

	async function submit() {
		if (!$authUserData || !$authUserData?.id) {
			return newToast({
				type: 'error',
				message: 'Failed to update user basic info'
			});
		}

		const { data, error } = await supabase
			.from('user_data')
			.update({
				...basicForm
			})
			.eq('id', $authUserData?.id)
			.select();

		if (data) $authUserData = data[0];

		if (error) {
			return newToast({
				type: 'error',
				message: 'Failed to update user basic info'
			});
		}

		goto(`/profile/${$authUserData?.username}/settings`);

		newToast({
			type: 'success',
			message: 'Basic info updated successfully'
		});
	
	}

	async function handleFileUpload(event: any) {
		isUploading = true;
		if(!$authUserData?.id) {
			isUploading = false;
			console.error("Failed to get the user id")
			return;
		}
		const file = event.target.files[0];
		let location = `${uuid()}.${file.ext || 'png'}`;
		if (file) {
			const { data: fileUploaded, error: fileError } = await supabase.storage
				.from("profile_image")
				.upload(location, file, {
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

			const { data, error } = await supabase.from('user_data').update({
				profile_image: location,
			}).eq("id", $authUserData.id).select();

			if(data) $authUserData = data[0];

			setTimeout(()=>{
				isUploading = false;
			}, 1000)
		}
	}

	function getProfileImage(): string {
		if(!$authUserData?.profile_image) return NO_PROFILE_DEFAULT;
		
		return supabase.storage.from("profile_image").getPublicUrl($authUserData?.profile_image!, {
			transform: {
				height: 400,
				width: 400,
				format: "origin"
			}
		}).data.publicUrl || NO_PROFILE_DEFAULT;
	}
</script>

<div class="page-setting">
	<div class="left-content">
		<Heading2 content="Basic info" />
		<div class="basic-form">
			<div class="row-container">
				<select bind:value={basicForm.initials}>
					<option value="Mr.">Mr.</option>
					<option value="Mrs.">Mrs.</option>
					<option value="Ms.">Ms.</option>
				</select>
				<Input
					width="200px"
					ariaLabel="First name"
					name="firstName"
					rounded="sm"
					value={basicForm?.firstName || ''}
				/>

				<Input
					name="lastName"
					title="Last Name"
					width="200px"
					rounded="sm"
					bind:value={basicForm.lastName}
				/>
			</div>
			<div class="row-container">
				<Input
					name="name"
					title="Display Name"
					width="230px"
					rounded="sm"
					bind:value={basicForm.displayName}
				/>
				<Input
					name="email"
					title="Email"
					type="email"
					disabled={true}
					width="230px"
					rounded="sm"
					bind:value={basicForm.email!}
				/>
			</div>
			<div class="row-container">
				<Textarea title="Description" bind:value={basicForm.oneLineDesc} />
			</div>

			<div class="w-full flex justify-end items-center gap-4 mt-4 mb-6">
				<Button label="Update" width={180} onclick={submit} fillType="solid-white" />
			</div>
		</div>

		<form class="phone-container">
			<!-- Phone number with country code -->
			<!-- OnState change, ask for OTP -->
		</form>

		<UpdatePassword />
		<SocialLink />

		<!-- Account sync -->
		<!-- Connect with Google -->
		<!-- Connect with facebook -->
		<!-- Connect with twitter -->
		<!-- Connect with twitch -->

		<!-- Stream location dropdown -->
	</div>
	<div class="right-content">
		<div class="profile-img">
			<img src={getProfileImage()} alt="user image"/>
			<label
				for="file-upload"
				class="upload-icon"
				class:uploading={isUploading}
			>
				{#if isUploading}
					<Loader />
				{:else}
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-cloud-arrow-up-fill" viewBox="0 0 16 16">
						<path d="M8 2a5.53 5.53 0 0 0-3.594 1.342c-.766.66-1.321 1.52-1.464 2.383C1.266 6.095 0 7.555 0 9.318 0 11.366 1.708 13 3.781 13h8.906C14.502 13 16 11.57 16 9.773c0-1.636-1.242-2.969-2.834-3.194C12.923 3.999 10.69 2 8 2m2.354 5.146a.5.5 0 0 1-.708.708L8.5 6.707V10.5a.5.5 0 0 1-1 0V6.707L6.354 7.854a.5.5 0 1 1-.708-.708l2-2a.5.5 0 0 1 .708 0z"/>
					</svg>
				{/if}
			</label>

			<input
				type="file"
				id="file-upload"
				class="hidden"
				accept="image/*"
				onchange={handleFileUpload}
				disabled={isUploading}
			/>
		</div>
		<Input
			placeholder="@Username"
			width="250px"
			rounded="sm"
			title="@Username"
			bind:value={basicForm.username}
		/>
	</div>
</div>

<!-- Community -->
<!-- Chat rules -->
<!-- Recording Location -->

<!-- Upload custom backgrounds -->
<!-- Select a brand theme -->
<!-- Select a style -->
<!-- Screen resolution output -->

<style lang="postcss">
	.page-setting {
		@apply flex justify-between;
		@apply mx-auto;
		width: 780px;
		@apply mb-4;
	}
	.left-content {
		width: 480px;
	}

	.right-content {
		width: 280px;
	}
	.basic-form {
		@apply mb-8;
	}
	.row-container {
		@apply flex w-full justify-between;
		@apply my-4;
	}

	select {
		@apply bg-primary-dark;
		@apply border border-light-gray;
		@apply rounded;
		@apply my-2;
		height: 46px;
		font-size: 14px;
		@apply flex items-center my-auto;
	}

	select:hover {
		@apply border-white;
	}
	select:focus {
		@apply bg-secondary-dark/80  border-white;
	}

	.profile-img {
		width: 250px;
		height: 250px;
		min-width: 250px;
		min-height: 250px;
		@apply bg-light-gray;
		@apply rounded;
		@apply mb-4 mt-16;
		@apply border border-light-gray;
		@apply relative;

		.upload-icon.uploading {
			opacity: 1;
		}
		&:hover .upload-icon {
			opacity: 1;
		}
	}

	.upload-icon {
		@apply absolute;
		@apply w-full;
		@apply h-full;
		@apply bg-secondary-dark/40;
		top: 0;
		left: 0;
		opacity: 0;
		cursor: pointer;

		@apply flex items-center justify-center;

		svg {
			scale: 2;
		}
	}

</style>
