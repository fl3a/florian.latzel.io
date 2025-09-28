document.querySelectorAll('.accordion').forEach((el) => {
  el.addEventListener('click', () => {
    document.querySelectorAll('.accordion').forEach((otherEl) => {
      if (otherEl !== el) {
        otherEl.removeAttribute('open');
      }
    });
  });
});
