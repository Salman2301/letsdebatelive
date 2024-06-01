<script lang="ts">
	import Button from '$src/lib/components/button/Button.svelte';
	import Input from '$src/lib/components/form/input/Input.svelte';
	import CloseX from '$src/lib/components/icon/CloseX.svelte';

	import { newToast } from '$src/lib/components/toast/Toast.svelte';
	import { PageCtx } from '$src/lib/context';
	import { onMount } from 'svelte';
	import { z } from 'zod';
	import { getSupabase } from '$src/lib/supabase';
	
	import type { Tables } from '$src/lib/schema/database.types';

	const supabase = getSupabase();

	const pageCtx = new PageCtx('new-debate');
	const teams = pageCtx.get('teams');
	const host = pageCtx.get('hostParticipant');
	const cohosts = pageCtx.get('inviteCohost');

	export function beforeOnNext() {}

	// TODO:
	// If the user is registered, Show a profile pic
	// Show display name
	// Host able to add it via username
	// Host able to add it based on history of previous co-hosts
	// Host able to select from fav. team

	let email: string = $state('');
	let team: string = $state('');
	const emailSchema = z.string().email();

	onMount(refreshInviteCohost);

	async function handleSubmit() {
		try {
			if (!isValidEmail(email)) {
				newToast({
					type: 'error',
					message: 'Invalid email'
				});
				return;
			}

			const { data, error } = await supabase.from('live_debate_invite_co_host').insert({
				email: email,
				invited_by: $host?.participant_id!,
				live_debate: $host?.live_debate!,
				status: 'invited',
				team: team || null
			});

			if (!error || !data) {
				newToast({
					type: 'success',
					message: 'Co-host added successfully'
				});
			}
			email = "";

			refreshInviteCohost();
		} catch (e) {
			newToast({
				type: 'error',
				message: 'Failed to add co-host'
			});
		}
	}

	async function refreshInviteCohost() {
		const { data, error } = await supabase
			.from('live_debate_invite_co_host')
			.select()
			.eq('live_debate', $host?.live_debate!);

		$cohosts = data || [];
	}

	function isValidEmail(email: string): boolean {
		try {
			emailSchema.parse(email);
			return true;
		} catch {
			return false;
		}
	}

	async function removeCohost(cohost: Tables<"live_debate_invite_co_host">) {
		const { data, error } = await supabase.from('live_debate_invite_co_host').delete().eq('id', cohost.id);
		refreshInviteCohost();

	}
</script>

<div class="flex items-center flex-col mx-auto">
	<div class="w-[700px]">
		<div class="add-co-host">
			<div class="inputs-container">
				<Input
					rounded="sm"
					title="Co-host"
					type="email"
					width="440px"
					bind:value={email}
					placeholder="Enter email address"
				/>
				<select class="team-select" style="width: 240px" bind:value={team}>
					{#each $teams as team}
						<option value={team.id}>{team.title}</option>
					{/each}
				</select>
			</div>
			<div class="self-end">
				<Button label="Add Co-host" width={240} color="secondary" onclick={handleSubmit} />
			</div>
		</div>
		<div class="co-host-list">
			{#each $cohosts as cohost}
				<div class="item">
					<div class="flex gap-4 items-center">
						<button class="btn-remove" onclick={() => removeCohost(cohost)}>
							<CloseX />
						</button>
						<span>{cohost.email}</span>
					</div>
					<span class="text-light-gray">Status: <span class="status">{cohost.status}</span></span>
				</div>
			{:else}
				<p class="no-cohost">No Co-host invited, Can also be added later</p>
			{/each}
		</div>
	</div>
	<px></px>
</div>

<style lang="postcss">
	.team-select {
		@apply rounded;
		@apply border border-light-gray;
		width: 180px;
		height: 46px;
		@apply bg-primary-dark;
	}

	.team-select:hover {
		@apply border-white;
	}

	.add-co-host {
		@apply flex flex-col justify-between items-center gap-4;
		width: 700px;
	}

	.inputs-container {
		@apply flex justify-between items-center gap-2;
		@apply w-full;
	}

	.item {
		@apply h-14 rounded border border-light-gray my-2;
		@apply flex items-center justify-between px-2;
	}
	.status {
		text-transform: capitalize;
		font-weight: bold;
		@apply text-white;
	}

	.btn-remove {
		height: 40px;
		width: 40px;
		@apply flex items-center justify-center;
		@apply rounded;
		@apply text-white/50;
		&:hover {
			@apply text-accent-red;
		}
	}

	.no-cohost {
		@apply flex w-full justify-center text-center mt-5 text-white/80 text-lg;
	}
</style>
