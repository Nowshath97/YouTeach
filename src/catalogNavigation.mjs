// After React commits the filter, bring its results into view on small screens.
export function revealMobileResults(ref) {
  if (!window.matchMedia('(max-width: 760px)').matches) return;
  window.requestAnimationFrame(() => {
    const target = ref.current;
    if (!target) return;
    target.focus({ preventScroll: true });
    target.scrollIntoView({
      behavior: window.matchMedia('(prefers-reduced-motion: reduce)').matches ? 'auto' : 'smooth',
      block: 'start',
    });
  });
}
