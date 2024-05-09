<script lang="ts">
</script>

<span>
	LETSDEBATE
	<span class="live">
		<svg width="10" height="10" viewBox="0 0 10 10" fill="none" xmlns="http://www.w3.org/2000/svg">
			<circle cx="5" cy="5" r="5" fill="#F81F1F" />
		</svg>
		LIVE
	</span>
</span>

<style lang="postcss">
	span {
		font-size: 24px;
		display: flex;
		align-items: center;
		gap: 2px;
	}

	.live {
		color: var(--color-accent-red);
		opacity: 1;
		animation: blink 1.2s infinite ease-in-out;
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
</style>
