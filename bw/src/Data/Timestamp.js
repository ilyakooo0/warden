export function toLocalDateTimeString(str) {
  const x = new Date(str);
  return x.toLocaleDateString() + " " + x.toLocaleTimeString();
}
