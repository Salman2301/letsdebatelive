import { exec, spawn } from 'child_process';
import * as readline from 'readline';

const dryRunProcess = spawn('supabase', ['db', 'diff']);
	let noSchemChangeText = "No schema changes found";
	let noSchemChange = false;
	
	dryRunProcess.stdout.on('data', (data) => {
		process.stdout.write(data.toString());
	});

	dryRunProcess.stderr.on('data', (data) => {
		let text = data.toString();
		if( text.trim() ===noSchemChangeText ) noSchemChange = true
		process.stderr.write(text);

	});

	dryRunProcess.on('close', () => {
		if (noSchemChange) return process.exit(0);
		const rl = readline.createInterface({
			input: process.stdin,
			output: process.stdout
		});

		rl.question('Enter the migration name: ', (migrationName) => {
			executeMigration(migrationName, rl)
		});

	});
	
function executeMigration(migrationName, rl) {
	const supabaseProcess = spawn('supabase', ['db', 'diff', '--file', migrationName]);

	supabaseProcess.stdout.on('data', (data) => {
		console.log(data.toString());
	});

	supabaseProcess.stderr.on('data', (data) => {
		console.error(data.toString());
	});

	supabaseProcess.on('close', () => {
		console.log("Migration successfully executed");

		exec('supabase migration list', (err, stdout) => {
			if (err) {
				console.error(err);
				return;
			}
			console.log(stdout);
		});
		console.log("Run 'supabase db push' to sync to remote db")
		rl.close();
	});
}
