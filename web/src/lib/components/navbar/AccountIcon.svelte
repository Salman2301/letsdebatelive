<script lang="ts">
	import { goto } from "$app/navigation";
	import { clickOutside } from "$lib/action/clickOutside";
	import { authUserData, isLoggedIn } from "../auth/auth.store";
	import { currentModal } from "../modal/modal.store";
	import { getContext } from "svelte";
	import { getSupabase } from "$lib/supabase";

  let showPopup = $state(false);

	const supabase = getSupabase(getContext);

  async function handleCreateDebate() {
    if( !$authUserData ) return;
    goto(`/profile/${$authUserData.username}/new-debate`);    
  }

  function gotoClosePopup(link: string) {
    showPopup = false;
    goto(link);
  }
</script>

<div class="icon-container" use:clickOutside={()=>(showPopup = false)}>
	<button onclick={() => (showPopup = !showPopup)}>
    <svg
    width="34"
    height="34"
    viewBox="0 0 34 34"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
		<path
			fill-rule="evenodd"
			clip-rule="evenodd"
			d="M0 17C0 12.4913 1.79107 8.1673 4.97918 4.97918C8.1673 1.79107 12.4913 0 17 0C21.5087 0 25.8327 1.79107 29.0208 4.97918C32.2089 8.1673 34 12.4913 34 17C34 21.5087 32.2089 25.8327 29.0208 29.0208C25.8327 32.2089 21.5087 34 17 34C12.4913 34 8.1673 32.2089 4.97918 29.0208C1.79107 25.8327 0 21.5087 0 17ZM23.596 22.9126C24.7418 23.5552 25.7788 24.3576 26.6832 25.2926C25.4876 26.6917 24.0027 27.8148 22.3309 28.5843C20.6592 29.3539 18.8404 29.7516 17 29.75C13.124 29.75 9.656 28.0228 7.3168 25.296C9.38623 23.1557 12.1062 21.7611 15.052 21.3299C17.9977 20.8987 21 21.4552 23.596 22.9126ZM17 17.7854C17.6697 17.7854 18.3329 17.6535 18.9517 17.3972C19.5704 17.1409 20.1327 16.7652 20.6062 16.2916C21.0798 15.8181 21.4555 15.2558 21.7118 14.6371C21.9681 14.0183 22.1 13.3551 22.1 12.6854C22.1 12.0157 21.9681 11.3525 21.7118 10.7337C21.4555 10.115 21.0798 9.55273 20.6062 9.07916C20.1327 8.60558 19.5704 8.22991 18.9517 7.97361C18.3329 7.71732 17.6697 7.5854 17 7.5854C15.6474 7.5854 14.3502 8.12272 13.3938 9.07916C12.4373 10.0356 11.9 11.3328 11.9 12.6854C11.9 14.038 12.4373 15.3352 13.3938 16.2916C14.3502 17.2481 15.6474 17.7854 17 17.7854Z"
			fill="white"
		/>
  </svg>
  </button>

  {#if showPopup}
    <div class="popup">
      <button
        class="btn-popup"
        onclick={handleCreateDebate}
      >
        Create Debate
      </button>
      <button
        class="btn-popup"
        onclick={()=>($currentModal="login")}
        class:hidden={$isLoggedIn}
      >
        Login
      </button>
      <button
        class="btn-popup"
        onclick={()=>($currentModal="register")}
        class:hidden={$isLoggedIn}
      >
        Create account
      </button>
      <button
        class="btn-popup"
        onclick={()=>(gotoClosePopup(`/profile/${$authUserData?.username}/control-room`))}
        class:hidden={!$isLoggedIn}
      >
        Control room
      </button>
      <button
        class="btn-popup"
        onclick={()=>(gotoClosePopup(`/u/${$authUserData?.username}`))}
        class:hidden={!$isLoggedIn}
      >
        Live page
      </button>
      <button
        class="btn-popup logout"
        onclick={()=>{
          supabase.auth.signOut();
          $authUserData = null;
          gotoClosePopup(`/profile/logout?${Date.now()}`);
        }}
        class:hidden={!$isLoggedIn}
      >
        Logout
      </button>
    </div>
  {/if}
</div>

<style lang="postcss">
  .icon-container {
    position: relative;
  }
  .popup {
    position: absolute;
    width: 200px;
    right: 0px;
    margin-top: 10px;
    @apply bg-accent-gray;
    border-radius: 4px;
    overflow: hidden;
    z-index: 1000;
  }

  .btn-popup {
    font-size: 14px;
    text-align: center;
    width: 100%;
    padding: 10px 0px;
    border-bottom: 1px solid var(--color-light-gray);
  }
  .btn-popup:hover {
    @apply text-white;
    @apply bg-primary;
  }
  .logout:hover {
    @apply bg-accent-red;
  }
  .btn-popup.hidden {
    display: none;
  }
  .btn-popup:last-child {
    border-bottom: 0px;
  }
</style>
