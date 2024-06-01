<script lang="ts">

	export function beforeOnNext() {
		// Set the button to start broad cast
		// oAuth sign in to multiple platform
		// oAuth enable or disable
	}
</script>


<div class="slide-container">

<div class="items">
		<div class="item youtube">
			YouTube
		</div>
		<div class="item twitch">
			Twitch
		</div>
		<div class="item facebook">
			Facebook
			<span>Live
		</span></div>
		<div class="item twitter-x">
			X (Twitter)
		</div>
		<div class="item instagram">
			Instagram
		</div>
		<div class="item linkedin">
			LinkedIn
		</div>
		<div class="item custom">
			Custom RTMP
		</div>
	</div>
</div>

<style lang="postcss">
	.slide-container {
		@apply flex justify-center;
	}

	.items {
		@apply flex justify-between flex-wrap gap-4;
		width: 700px;
	}
	.item {
		width: 200px;
		height: 120px;
		@apply border border-light-gray;
		@apply rounded;
		@apply flex items-center justify-center;

		font-size: 22px;

		color: white;
	}
	.youtube {
		background-color: red;
	}
	.facebook {
		background-color: #1877F2;
	}
	.facebook span {
		background-color: red;
		font-weight: semibold;
		@apply ml-1 px-1;
		@apply rounded;
	}
	.twitch {
		background-color: #6441a5;
	}
	.linkedin {
		background-color: #0077B5;
	}
	.instagram {
		background: radial-gradient(circle at 30% 107%, #fdf497 0%, #fdf497 5%, #fd5949 45%, #d6249f 60%, #285AEB 90%);
	}
	.twitter-x {
		background-color: black;
	}
</style>
