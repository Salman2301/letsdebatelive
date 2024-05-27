import { exec, spawn } from 'child_process';
import * as readline from 'readline';

console.log(`> supabase db diff`);
const dryRunProcess = spawn('supabase', ['db', 'diff']);
let noSchemChangeText = 'No schema changes found';
let noSchemChange = false;

dryRunProcess.stdout.on('data', (data) => {
	process.stdout.write(data.toString());
});

dryRunProcess.stderr.on('data', (data) => {
	let text = data.toString();
	if (text.trim() === noSchemChangeText) noSchemChange = true;
	process.stderr.write(text);
});

dryRunProcess.on('close', () => {
	if (noSchemChange) return process.exit(0);
	const rl = readline.createInterface({
		input: process.stdin,
		output: process.stdout
	});

	rl.question('Enter the migration name: ', (migrationName) => {
		executeMigration(migrationName, rl);
	});
});

function executeMigration(migrationName, rl) {
	console.log(`> supabase db diff --file ${migrationName}`);
	const supabaseProcess = spawn('supabase', ['db', 'diff', '--file', migrationName]);

	supabaseProcess.stdout.on('data', (data) => {
		console.log(data.toString());
	});

	supabaseProcess.stderr.on('data', (data) => {
		console.error(data.toString());
	});

	supabaseProcess.on('close', () => {
		console.log('Migration successfully executed\n');
		console.log('Updating types based on current migration:');
		console.log('> npm run db:types');
		exec('npm run db:types', (err, stdout) => {
			console.log('> supabase migration list');
			exec('supabase migration list', (err, stdout) => {
				if (err) return console.error(err);

				console.log(stdout);
				console.log('Run below code to sync to remote db:');
				console.log('supabase db push');
			});
			rl.close();
		});
	});
}
