<script lang="ts">
</script>

<a href="/">
	<span>
		VISTA
		<span class="live">
			<svg
				width="10"
				height="10"
				viewBox="0 0 10 10"
				fill="none"
				xmlns="http://www.w3.org/2000/svg"
			>
				<circle cx="5" cy="5" r="5" fill="#F81F1F" />
			</svg>
			LIVE
		</span>
	</span>
</a>

<style lang="postcss">
	span {
		font-size: 24px;
		display: flex;
		align-items: center;
		gap: 2px;
		color: white;
	}

	.live {
		@apply text-accent-red;
		opacity: 1;
		animation: blink 1.2s infinite ease-in-out;
	}

	.live svg {
		animation: shrink 1.2s infinite ease-in-out;
	}

	@keyframes blink {
		from {
			opacity: 0.8;
		}
		50% {
			opacity: 1;
		}
		to {
			opacity: 0.8;
		}
	}
	@keyframes shrink {
		from {
			scale: 0.9;
		}
		50% {
			scale: 1;
		}
		to {
			scale: 0.9;
		}
	}
</style>
