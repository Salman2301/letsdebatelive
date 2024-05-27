/** @type {import('tailwindcss').Config} */
export default {
	content: ['./src/**/*.{html,js,svelte,ts}'],

	theme: {
		extend: {
			colors: {
				primary: 'rgba(var(--color-primary) / <alpha-value>)',
				secondary: 'rgba(var(--color-secondary) / <alpha-value>)',
				'accent-red': 'rgba(var(--color-accent-red) / <alpha-value>)',
				'accent-red-dark': 'rgba(var(--color-accent-red-dark) / <alpha-value>)',
				'accent-gray': 'rgba(var(--color-accent-gray) / <alpha-value>)',
				'primary-dark': 'rgba(var(--color-primary-dark) / <alpha-value>)',
				'secondary-dark': 'rgba(var(--color-secondary-dark) / <alpha-value>)',
				'team-a': 'rgba(var(--color-team-a) / <alpha-value>)',
				'team-b': 'rgba(var(--color-team-b) / <alpha-value>)',
				'team-c': 'rgba(var(--color-team-c) / <alpha-value>)',
				black: 'rgba(var(--color-black) / <alpha-value>)',
				white: 'rgba(var(--color-white) / <alpha-value>)',
				'light-gray': 'var(--color-light-gray)'
			}
		}
	},
	plugins: []
};
