<script lang="ts">
	import { closeModal, currentModal, openModal } from '$lib/components/modal/modal.store';
	import { newToast } from '$src/lib/components/toast/Toast.svelte';

	import { authUserData } from '$src/lib/stores/auth.store';
	import { getSupabase } from '$src/lib/supabase';
	import { getContext } from 'svelte';

	import type { Tables } from '$src/lib/schema/database.types';
	import { PageCtx } from '$src/lib/context';

	const supabase = getSupabase();
	const pageCtx = new PageCtx('live');

	const ctx = pageCtx.get('pageDataProps');
	const myBackstageInfo = pageCtx.get('myBackstageInfo');
	let teamId: string = $state('');

	$effect(() => {
		getTeamId();
	});

	function handleOpenTeamSelect() {
		if (!ctx) {
			return newToast({
				type: 'error',
				message: 'Failed to get the ctx'
			});
		}
		openModal({
			key: 'team-select',
			data: {
				teams: ctx.teams,
				onSelect: (team) => handleSelectTeam(team)
			}
		});
	}

	async function handleSelectTeam(team: Tables<'live_debate_team'>) {
		if (!$authUserData?.id || !ctx.live_debate) {
			return newToast({
				type: 'error',
				message: 'Error failed to get the current user info'
			});
		}

		const [{ data, error }, { data: participantUpdate, error: errorUpdate }] = await Promise.all([
			supabase
				.from('live_debate_user_team')
				.upsert({
					live_debate: ctx.live_debate.id,
					team: team.id,
					user_id: $authUserData?.id
				})
				.eq('live_debate', ctx.live_debate.id)
				.eq('user_id', $authUserData.id),

			// Update team if the user is in backstage
			supabase
				.from('live_debate_participants')
				.update({
					team: team.id
				})
				.eq('live_debate', ctx.live_debate.id)
				.eq('participant_id', $authUserData.id)
		]);

		teamId = team.id;

		if (error) {
			console.error(error);
			return newToast({
				type: 'error',
				message: 'Failed to update the team for the participant!'
			});
		}

		closeModal();
	}

	async function getTeamId() {
		if (!ctx?.live_debate || !$authUserData) return;

		const { data, error } = await supabase
			.from('live_debate_user_team')
			.select()
			.eq('live_debate', ctx.live_debate.id)
			.eq('user_id', $authUserData?.id);

		if (data?.[0]?.team) teamId = data?.[0]?.team;
		return;
	}
</script>

<div class="chat-container">
	<div class="chat-items">
		<div class="chat-item">
			<span class="chat-item-username">username</span><span class="chat-item-content"
				>This is a content of the chat user</span
			>
		</div>
		<div class="chat-input-container">
			<textarea class="chat-text"></textarea>
			<div class="chat-footer">
				<div class="left">
					<button class="team-circle" onclick={() => handleOpenTeamSelect()}>
						<div
							class="circle-icon"
							style="background-color:{teamId ? ctx.teamMapColor[teamId] : ''}"
						></div>
						<span>Change team?</span>
					</button>
				</div>
				<button class="btn-submit" style="background-color:{teamId ? ctx.teamMapColor[teamId] : ''}"
					>Submit</button
				>
			</div>
		</div>
	</div>
</div>

<style lang="postcss">
	.chat-container {
		@apply flex-grow;
		@apply overflow-auto;
		@apply flex flex-col justify-between;
	}

	.left {
		@apply flex justify-between items-center;
	}

	.chat-items {
		@apply w-full;
		@apply px-2;
	}
	button {
		@apply flex justify-center items-center gap-1;
		&:hover span {
			opacity: 1;
		}
	}

	button span {
		@apply text-xs;
		opacity: 0;
	}
	.circle-icon {
		width: 15px;
		height: 15px;
		border-radius: 100%;
		@apply bg-team-a;
	}
	.chat-input-container {
		@apply flex flex-col justify-end;
		height: calc(100vh - 76px - 70px);
	}
	.chat-text {
		@apply rounded;
		@apply border border-light-gray;
		@apply bg-transparent text-white;
		field-sizing: content;
		min-height: 40px;
		max-height: 120px;
	}
	.chat-footer {
		@apply flex justify-between;
		@apply my-1;
	}
	.btn-submit {
		@apply text-xs;
		@apply bg-primary;
		@apply px-2 py-1;
		@apply my-1;
		@apply rounded;
		@apply text-black;
		/* @apply border border-primary; */
	}

	.chat-item {
		@apply py-1;
		@apply text-xs;
	}
	.chat-item-username {
		@apply text-team-a;
		@apply font-bold;
		@apply pr-2;
	}
</style>
