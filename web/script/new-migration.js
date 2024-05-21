import { spawn } from 'child_process';
import * as readline from 'readline';

const dryRunProcess = spawn('supabase', ['db', 'diff']);

	dryRunProcess.stdout.on('data', (data) => {
		process.stdout.write(data.toString());
	});

	dryRunProcess.stderr.on('data', (data) => {
		process.stderr.write(data.toString());
	});

	dryRunProcess.on('close', () => {
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

	supabaseProcess.on('close', (code) => {
		console.log(`Supabase process exited with code ${code}`);
		rl.close();
	});
}
