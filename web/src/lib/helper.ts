export type WithTarget<Event, Target> = Event & { currentTarget: Target };

export function isJson(str: string | null) {
  try {
    JSON.parse(str as string);
    return true
  }
  catch {
    return false
  }
}
