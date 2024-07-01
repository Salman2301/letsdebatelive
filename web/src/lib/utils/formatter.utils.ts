export function formatNum(num: number) {
  return new Intl.NumberFormat("en", {
    notation: "compact",
    compactDisplay: "short",
    maximumFractionDigits: 1
  }).format(num);
}

export function roundNum(num: number, digits = 0) {
  return Math.round(num * Math.pow(10, digits)) / Math.pow(10, digits);
}
