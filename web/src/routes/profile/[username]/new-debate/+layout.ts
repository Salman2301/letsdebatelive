/** @type {import('./$types').LayoutLoad} */
export async function load({ parent }) {
	const data = await parent();
  return {
    data
  };
}