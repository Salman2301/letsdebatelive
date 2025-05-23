# Intro

Video-conference platform to organize debates and live stream to audience at ease.

We are also trying to solve OBS in browsers and make it more accessible to everyone.

- **Audience** get a chance to participate in the live feed and
- **Host** will seemlessly host different live feed to multiple platform with less hassel.
  Since we will be taking care of the setup, OBS, streams, recording, add / removing participants, adding moderators and co-host with a link and login.
- **Moderator/Participant** of the live feed will get portion of earning based on the host custmoization how much percent will be split between them.

It's useful for:

- Different community, that wants to take down different radical views/ideas and live feed it live
- Will have an engaging poll / live chat for audience to act on it

## Tech

- SvelteKit
- TailwindCSS
- Supabase
- PostgreSQL
- NodeJS
- Typescript

### Supabase

- Install supabase locally,
- Run `supabase link` to link the project with the remote supabase db

## Migration

### This will generate a migration file based on the local and remote DB

```sh
 supabase db diff --file migration-name
```

### To delete a migration run

```sh
supabase migration list
```

To get the list of migration and get the $id

Use the $id to delete the record

```sh
supabase migration repair $id --status reverted --local
```

### Push the migration changes to the remote db

```sh
suapabse db push
```

## Seed

User A
email: <TeamUser1-A@example.com>
password: TeamUser1-A

> Dump the current data from local database to seed `.sql` file

npm run db:seed:dump

Missing seeds:

- Supabase real time
