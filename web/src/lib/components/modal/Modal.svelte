<script lang="ts">
	import Heading2 from "../form/Heading2.svelte";

	interface Props {
		showModal?: boolean;
		children?: any;
		title?: string;
	}

	let { showModal = false, children, title = '' }: Props = $props();

	let dialog: HTMLDialogElement;

	$effect(() => {
		if (dialog) dialog.showModal();
	});
</script>

<!-- svelte-ignore a11y_click_events_have_key_events -->
<!-- svelte-ignore a11y_no_noninteractive_element_interactions -->
<dialog bind:this={dialog} onclose={() => (showModal = false)}>
	<div>
		<div class="header">
			<div class="title"><Heading2 content={title}/></div>
			<button onclick={() => dialog.close()}>
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
</dialog>

<style>
	dialog {
		max-width: 100vw;
		width: 600px;
		height: 400px;

		border-radius: 0.2em;
		border: none;
		padding: 0;
		@apply bg-primary-dark;
		
		border: 1px solid var(--color-light-gray);
	}
	dialog::backdrop {
		background: rgba(0, 0, 0, 0.3);
	}
	dialog > div {
		padding: 1em;
	}
	dialog[open] {
		animation: zoom 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
	}
	dialog[open]::backdrop {
		animation: fade 0.2s ease-out;
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
	@keyframes fade {
		from {
			opacity: 0;
		}
		to {
			opacity: 1;
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
