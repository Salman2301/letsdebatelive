<script lang="ts">
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import Input from '$lib/components/form/input/Input.svelte';
	import Textarea from '$lib/components/form/textarea/Textarea.svelte';
	import Button from '$lib/components/button/Button.svelte';
	import SocialLink from './component/SocialLink.svelte';
	import UpdatePassword from './component/UpdatePassword.svelte';
	import { authUserData } from '$lib/stores/auth.store';
	import { getSupabase } from '$lib/supabase';
	import { getContext } from 'svelte';
	import { newToast } from '$lib/components/toast/Toast.svelte';
	import { goto } from '$app/navigation';

	const supabase = getSupabase(getContext);
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
				<Button label="Submit" width={180} onclick={submit} fillType="solid-white" />
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
			{#if false}
			{:else}
				<img
					src="/images/NO_PROFILE_DEFAULT.svg"
					alt="default no user profile"
				/>
			{/if}
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
	}
</style>
