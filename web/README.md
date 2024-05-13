
### Tech:
  - SvelteKit
  - TailwindCSS
  - Supabase



### Supabase
- Install supabase locally
- Run `supabase link` to link the project with the remote supabase db

## Migration

This will generate a migration file based on the local and remote DB
```sh
 supbase db diff --file migration-name
```

Push the migration changes to the remote db
```sh
suapabse db push
```
