
### Tech:
  - SvelteKit
  - TailwindCSS
  - Supabase



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
email: TeamUser1-A@example.com
password: TeamUser1-A

> Dump the current data from local database to seed `.sql` file

npm run db:seed:dump
