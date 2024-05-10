export function genId(maxLen?: number) {
  if (typeof maxLen === "undefined") maxLen = 6;
  
  const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let id = '';
  for (let i = 0; i < maxLen; i++) {
    id += charset.charAt(Math.floor(Math.random() * charset.length));
  }
  
  return id;
}
