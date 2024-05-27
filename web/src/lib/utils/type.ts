export function hasErrorParse<T extends Record<string, any>>(
	formZodSafeParse: any
): Record<keyof T, boolean> {
	return Object.keys(formZodSafeParse.error?.formErrors?.fieldErrors || []).reduce(
		(obj, key: any) => {
			return {
				...obj,
				[key]: !!formZodSafeParse.error?.formErrors?.fieldErrors?.[key]?.length
			};
		},
		{}
	) as unknown as Record<keyof T, boolean>;
}
