export function bindHCaptchToken(callback) {
  return () => {
    window.addEventListener("message", (e) => {
      if (typeof e.data === 'object' && "hCaptchaToken" in e.data) {
        callback(e.data.hCaptchaToken)();
      }
    })
  }
}
