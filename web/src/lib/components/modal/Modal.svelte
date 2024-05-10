<script lang="ts">
	import Heading2 from "../form/Heading2.svelte";
	import { currentModal } from "./modal.store";

	interface Props {
		showModal?: boolean;
		children?: any;
		title?: string;
	}

	let { children, title = '' }: Props = $props();

</script>

<!-- svelte-ignore a11y_click_events_have_key_events -->
<!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
<div class="overlay">
	<div class="container">
		<div>
			<div class="header">
				<div class="title"><Heading2 content={title}/></div>
				<button onclick={() => ($currentModal = null)}>
					<svg
						width="30"
						height="30"
						viewBox="0 0 30 30"
						fill="none"
						xmlns="http://www.w3.org/2000/svg"
					>
						<path
							d="M22.5 7.5L7.5 22.5"
							stroke="white"
							stroke-width="1.4"
							stroke-linecap="round"
							stroke-linejoin="round"
						/>
						<path
							d="M7.5 7.5L22.5 22.5"
							stroke="white"
							stroke-width="1.4"
							stroke-linecap="round"
							stroke-linejoin="round"
						/>
					</svg>
				</button>
			</div>
	
			{@render children?.()}
		</div>
	</div>

	
</div>

<style>
	.overlay {
		position: absolute;
		width: 100vw;
		height: 100vh;
		background-color: rgba(0,0,0,0.25);
		z-index: 999;

		display: flex;
		justify-content: center;
		align-items: center;
	}
	.container {
		max-width: 100vw;
		width: 600px;
		height: 400px;

		max-height: 800px;

		border-radius: 0.2em;
		border: none;
		padding: 0;
		@apply bg-primary-dark;
		overflow: auto;
		border: 1px solid var(--color-light-gray);
		animation: zoom 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
	}
	.container::backdrop {
		background: rgba(0, 0, 0, 0.3);
	}
	.container > div {
		padding: 1em;
	}

	.header {
		@apply flex justify-between items-center;
	}

	.title {
		@apply w-full flex justify-center;
	}

	@keyframes zoom {
		from {
			transform: scale(0.95);
		}
		to {
			transform: scale(1);
		}
	}

	button {
		display: block;
	}

	button:hover {
		animation: spin 0.2s;
	}
	
	@keyframes spin {
		0% {
			transform: rotate(0deg);
		}
		100% {
			transform: rotate(90deg);
		}
	}

</style>
