/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],

  theme: {
    extend: {},
    colors: {
      primary: "var(--color-primary)",
      secondary: "var(--color-secondary)",
      "accent-red": "var(--color-accent-red)",
      "accent-red-dark": "var(--color-accent-red-dark)",
      "accent-gray": "var(--color-accent-gray)",
      "primary-dark": "var(--color-primary-dark)",
      "secondary-dark": "var(--color-secondary-dark)",
      black: "var(--color-black)",
      white: "var(--color-white)",
      "light-gray": "var(--color-light-gray)",
    }
  },
  plugins: [],
}

