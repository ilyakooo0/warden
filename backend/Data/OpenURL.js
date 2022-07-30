export function openURL(url) {
  return () => window.open(url, '_blank')
}
