# Implementation recipes

## Contents

1. Baseline CSS primitive
2. Browser fallback
3. Navigation behavior
4. Real refraction enhancement
5. Responsive strategy
6. Performance

## 1. Baseline CSS primitive

```css
.liquid-glass {
  position: relative;
  isolation: isolate;
  overflow: hidden;
  border: 1px solid var(--lg-border);
  border-radius: var(--lg-radius);
  background: var(--lg-tint);
  box-shadow:
    var(--lg-shadow),
    inset 0 1px 0 rgb(255 255 255 / 0.28);
  -webkit-backdrop-filter:
    blur(var(--lg-blur))
    saturate(var(--lg-saturation));
  backdrop-filter:
    blur(var(--lg-blur))
    saturate(var(--lg-saturation));
}

.liquid-glass::after {
  content: "";
  position: absolute;
  inset: 0;
  z-index: -1;
  border-radius: inherit;
  background: linear-gradient(
    135deg,
    rgb(255 255 255 / 0.24),
    transparent 42%,
    rgb(255 255 255 / 0.08)
  );
  pointer-events: none;
}
```

Keep content in a normal foreground stacking layer. Test pseudo-elements carefully when `overflow: hidden` and nested dropdowns interact.

## 2. Browser fallback

Provide an opaque fallback first, then enhance:

```css
.liquid-glass {
  background: rgb(238 244 250 / 0.94);
}

@supports ((backdrop-filter: blur(1px)) or (-webkit-backdrop-filter: blur(1px))) {
  .liquid-glass {
    background: var(--lg-tint);
  }
}
```

Do not hide important controls when blur is unsupported. In high-contrast modes, remove decorative gradients and expose a clear border.

```css
@media (forced-colors: active) {
  .liquid-glass {
    border: 1px solid CanvasText;
    background: Canvas;
    color: CanvasText;
  }
}
```

## 3. Navigation behavior

For desktop dropdowns:

- keep trigger and panel inside one parent hit area;
- add invisible padding or overlap to bridge the visual gap;
- control open state in JavaScript so hover, focus, click, Escape, and outside-click agree;
- set `aria-expanded` on the trigger;
- keep the menu in DOM when animating opacity, but remove pointer events and visibility when closed.

For mobile:

- use one explicit menu toggle;
- prefer a full-width dense-glass panel or sheet;
- group links with clear labels;
- close after navigation and on Escape;
- prevent background scroll only for modal drawers, not small inline panels.

## 4. Real refraction enhancement

SVG displacement can create visible distortion:

```html
<svg aria-hidden="true" width="0" height="0">
  <filter id="liquid-refraction">
    <feTurbulence
      type="fractalNoise"
      baseFrequency="0.012 0.018"
      numOctaves="2"
      seed="7"
      result="noise"
    />
    <feDisplacementMap
      in="SourceGraphic"
      in2="noise"
      scale="10"
      xChannelSelector="R"
      yChannelSelector="B"
    />
  </filter>
</svg>
```

Treat this as progressive enhancement. Browser behavior differs when SVG filters are combined with backdrop rendering. Use it on a duplicated background layer or a compact decorative layer, never on text.

Prefer a static displacement texture over continuously changing turbulence. If the surface follows the pointer, update CSS variables through `requestAnimationFrame` and cap movement.

## 5. Responsive strategy

At narrow widths:

- reduce blur slightly if the surface covers most of the viewport;
- strengthen tint because mobile backgrounds often crop unpredictably;
- increase vertical spacing and touch target size;
- replace multi-column dropdowns with grouped rows or an accordion;
- honor safe-area insets for top and bottom bars.

Useful variables:

```css
padding-top: max(16px, env(safe-area-inset-top));
padding-bottom: max(16px, env(safe-area-inset-bottom));
```

## 6. Performance

- Avoid fixed, full-screen elements with animated `backdrop-filter`.
- Keep the blurred area as small as the design allows.
- Animate transforms and opacity, not blur radius.
- Use `will-change` temporarily or only on elements that actually animate.
- Test scroll and menu opening on a real mobile viewport.
- Remove redundant blur from child surfaces when the parent already provides it.
- Use `contain: paint` only after checking that it does not clip menus or shadows.

