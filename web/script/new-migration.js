import { spawn } from 'child_process';
import * as readline from 'readline';

const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout
});

rl.question('Enter the migration name: ', (migrationName) => {
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
});
