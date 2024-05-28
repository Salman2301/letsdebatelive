<script lang="ts">
	import Heading2 from '$lib/components/form/Heading2.svelte';
	import Input from '$lib/components/form/input/Input.svelte';
	import Textarea from '$lib/components/form/textarea/Textarea.svelte';
	import Button from '$lib/components/button/Button.svelte';
	import SocialLink from './component/SocialLink.svelte';
</script>

<div class="page-setting">
	<div class="left-content">
		<Heading2 content="Basic info" />
		<form action="?/profile-update" method="POST" class="basic-form">
			<div class="row-container">
				<select>
					<option>Mr.</option>
					<option>Mrs.</option>
					<option>Ms.</option>
				</select>
				<Input width="200px" ariaLabel="First name" name="firstName" rounded="sm" />

				<Input name="lastName" title="Last Name" width="200px" rounded="sm" />
			</div>
			<div class="row-container">
				<Input name="name" title="Display Name" width="230px" rounded="sm" />
				<Input name="email" title="Email" type="email" disabled={true} width="230px" rounded="sm" />
			</div>
			<div class="row-container">
				<Textarea title="Description" />
			</div>

			<div class="w-full flex justify-end items-center gap-4 mt-4 mb-6">
				<p class="text-accent-red font-bold text-xs">Error</p>
				<Button label="Submit" width={180} />
			</div>
		</form>

		<form class="phone-container">
			<!-- Phone number with country code -->
			<!-- OnState change, ask for OTP -->
		</form>

		<div class="my-2 mb-4">
			<Heading2 content="Update password"></Heading2>
		</div>

		<form class="password-container">
			<div class="flex w-full justify-between">
				<div class="password-left-input">
					<Input name="Old password" width="230px" type="password" rounded="sm" />

					<Input name="New password" type="password" width="230px" rounded="sm" />

					<Input name="Re-enter password" type="password" width="230px" rounded="sm" />
				</div>
				<div class="password-right-input">
					<div class="validity-fields">
						<p class="password-valid-text">
							<span class="check-mark">✓</span>Atleast one capital letter
						</p>
						<p class="password-valid-text">
							<span class="check-mark">✗</span>Atleast one small letter
						</p>
						<p class="password-valid-text"><span class="check-mark">✓</span>Atleast one number</p>
						<p class="password-valid-text"><span class="check-mark">✓</span>Atleast one symbol</p>
						<p class="password-valid-text"><span class="check-mark">✓</span>Password must watch</p>
					</div>
				</div>
			</div>
			<div class="w-full flex justify-end items-center gap-4 mt-2 mb-4">
				<p class="text-accent-red font-bold text-xs">Error</p>
				<Button label="Submit" width={180} />
			</div>
		</form>

		<SocialLink />

		<!-- Account sync -->
		<!-- Connect with Google -->
		<!-- Connect with facebook -->
		<!-- Connect with twitter -->
		<!-- Connect with twitch -->

		<!-- Stream location dropdown -->
	</div>
	<div class="right-content">
		<!-- Show profile icon -->
		<!-- Show username input -->
		<div class="profile-img"></div>
		<Input placeholder="@Username" width="250px" rounded="sm" />
	</div>
</div>

<!-- Form -->

<!-- Initials -->
<!-- Display name -->
<!-- User can add first name / last name -->
<!-- User can update the password -->
<!-- User can upload the profile pic -->
<!-- Phone Number -->
<!-- Address -->
<!-- Description -->
<!-- Connect social links -->

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

	.password-container {
		@apply flex w-full flex-col;
	}

	.password-valid-text {
		@apply text-base;
		@apply text-white/60;
		@apply font-semibold;
	}

	.check-mark {
		@apply pr-2;
	}

	.validity-fields {
		@apply flex gap-2 flex-col;
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
