<script lang="ts">
	import Heading2 from "$lib/components/form/Heading2.svelte";
  import Button from "$lib/components/button/Button.svelte";
	import InPassword from "$lib/components/form/input/InPassword.svelte";
	import { getSupabase } from "$lib/supabase";
	import { getContext } from "svelte";
	import { newToast } from "$lib/components/toast/Toast.svelte";


  let newPassword: string = $state("");
  let reEnterPassword: string = $state("");

  let isValid = $derived(checkAndUpdateValidty());
  let isAllValid = $derived(isValid.capLetter && isValid.smallLetter && isValid.number && isValid.symbol && isValid.match);

  let isAllEmpty = $derived(newPassword.length === 0 && reEnterPassword.length === 0)

  const supabase = getSupabase(getContext);

  function checkAndUpdateValidty() {
    return {
      capLetter: /[A-Z]/g.test(newPassword),
      smallLetter: /[a-z]/g.test(newPassword),
      number: /\d/g.test(newPassword),
      symbol: /[#?!@$%^&*-]/g.test(newPassword),
      match: newPassword.length > 0 && newPassword === reEnterPassword
    }
  }


  function getCheckMark(valid: boolean) {
    return valid ? "✓" : "✗"
  }

  async function submit() {
    try {
      const { data, error } = await supabase.auth.updateUser({ password: newPassword });
      if( error ) throw error;
      newToast({
        type: "success",
        message: "Password updated successfully!"
      });
    }
    catch(e) {
      console.error(e);
      newToast({
        type: "error",
        message: "Failed to update password"
      })
    }
  }
 
</script>


<div class="my-2 mb-4">
  <Heading2 content="Update password"></Heading2>
</div>

<div
  class="password-container"
>
  <div class="flex w-full justify-between my-2">
    <div class="password-left-input">
      <InPassword
        name="New password"
        bind:value={newPassword}
        rounded="sm"
        width="100%"
      />
      <InPassword
        name="Re-enter password"
        bind:value={reEnterPassword}
        rounded="sm"
        width="100%"
      />
    </div>
    <div class="password-right-input" class:hidden={isAllEmpty}>
      <div class="validity-fields">
        <p
          class="password-valid-text"
          class:is-valid={isValid.capLetter}
        >
          <span class="check-mark">{getCheckMark(isValid.capLetter)}</span>Atleast one capital letter
        </p>
        <p
          class="password-valid-text"
          class:is-valid={isValid.smallLetter}
        >
          <span class="check-mark">{getCheckMark(isValid.smallLetter)}</span>Atleast one small letter
        </p>
        <p
          class="password-valid-text"
          class:is-valid={isValid.number}
        >
          <span class="check-mark">{getCheckMark(isValid.number)}</span>Atleast one number
        </p>
        <p
          class="password-valid-text"
          class:is-valid={isValid.symbol}
        >
          <span class="check-mark">{getCheckMark(isValid.symbol)}</span>Atleast one symbol
        </p>
        <p
          class="password-valid-text"
          class:is-valid={isValid.match}
        >
          <span class="check-mark">{getCheckMark(isValid.match)}</span>Password must watch
        </p>
      </div>
    </div>
  </div>
  <div 
    class="w-full flex justify-end items-center gap-4 my-4"
    class:hidden={isAllEmpty}
  >
    <Button disabled={!isAllValid} label="Submit" width={180} onclick={submit}/>
  </div>
</div>

<style lang="postcss">

.password-container {
		@apply flex w-full flex-col;
	}

	.password-valid-text {
		@apply text-base;
		@apply font-semibold;
    @apply text-accent-red;

    &.is-valid {
		@apply text-white/60;

    }
	}
  
  .password-left-input {
    @apply mr-1;
    width: 240px;
    @apply flex flex-col gap-2;
  }

	.check-mark {
		@apply pr-2;
	}

	.validity-fields {
		@apply flex gap-2 flex-col;
	}

  .hidden {
    visibility: hidden;
  }

</style>