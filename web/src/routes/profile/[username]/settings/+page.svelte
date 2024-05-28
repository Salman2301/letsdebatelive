<script lang="ts">
  import Heading2 from "$lib/components/form/Heading2.svelte";
  import Input from "$lib/components/form/input/Input.svelte";  

</script>

<div
  class="page-setting"
>
  <div class="left-content">
    <form
      action="?/profile-update"
      method="POST"
      class="basic-form"
    >
      <div class="row-container">
        <select>
          <option>Mr.</option>
          <option>Mrs.</option>
          <option>Ms.</option>
        </select>

        <Input
          width="200px"
          ariaLabel="First name"
          name="firstName"
          rounded="sm"
        />

        <Input
          name="lastName"
          title="Last Name"
          width="200px"
          rounded="sm"
        />
      </div>
      <div class="row-container">
        <Input
          name="name"
          title="Display Name"
          width="230px"
          rounded="sm"
          
        />
        <Input
          name="email"
          title="Email"
          type="email"
          disabled={true}
          width="230px"
          rounded="sm"
        />
      </div>
      <div class="row-container">
        
        <textarea
          placeholder="Tell us about yourself"
        ></textarea>
      </div>
    </form>
    
    <form class="phone-container">
      <!-- Phone number with country code -->
      <!-- OnState change, ask for OTP -->
    </form>
    <!-- Update password section -->
    <form class="password-container">
      <div class="mt-2 mb-1">      
        <Heading2 content="Update password"></Heading2>
      </div>
      <div class="password-left-input">
        
        <Input
          name="Old password"
          width="230px"
          rounded="sm"
        />
        
        <Input
          name="New password"
          width="230px"
          rounded="sm"
        />

        <Input
          name="Re-enter password"
          width="230px"
          rounded="sm"
        />
      </div>
      <div class="password-right-input">
        <div class="validity-fields">
          <!-- Must contain atleast one upper case -->
          <!-- Must contain atleast one lower case -->
          <!-- Must contain atleast one symbol -->
          <!-- Must contain atleast one number -->
        </div>
      </div>
    </form>

    <!-- Social links -->
    <!-- Enter a new link -->
    <!-- submit button -->

    <input
      type="text"
      value=""
      placeholder="Enter any social link URL"
      class="social-new-input"
    />


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

  .social-new-input {
    width: 230px;
    height: 40px;
    @apply bg-primary-dark;
    @apply border border-light-gray;
    @apply rounded;
    @apply pl-1;
    @apply my-2;
    font-size: 14px;
  }

  textarea {
    @apply bg-primary-dark;
    @apply border border-light-gray focus:border-white;
    @apply rounded;
    width: 100%;
    @apply px-4 py-2;
    @apply outline-none focus:outline-none;
    font-size: 16px;
    height: 120px;
  }
  textarea:hover {
    @apply border-white;
  }
  textarea:focus {
    @apply bg-secondary-dark/80;
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

</style>