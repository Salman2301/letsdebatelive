import type { PlaywrightTestConfig } from '@playwright/test';

const config: PlaywrightTestConfig = {
	webServer: {
		command: 'npm run build && npm run preview',
		port: 4173,
		reuseExistingServer: true
	},
	testDir: 'e2e',
	testMatch: /(.*).e2e.ts/,
	outputDir: 'e2e-results',
	snapshotDir: 'e2e-snapshot'
};

export default config;
