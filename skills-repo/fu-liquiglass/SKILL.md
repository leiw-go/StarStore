---
name: fu-liquiglass
description: Design, build, redesign, or refine websites and web applications with a polished Apple-inspired liquid-glass visual system. Use when Codex is asked to create or improve translucent navigation, glass menus, refractive surfaces, edge highlights, layered blur, hover expansion, premium Apple-like web styling, responsive glass UI, or to make an existing frontend feel clearer, calmer, more dimensional, and production-ready.
---

# FU—Liquiglass

Create restrained liquid-glass interfaces that stay readable, responsive, accessible, and fast. Treat glass as a system of background, tint, blur, border, highlight, shadow, and motion—not as a single CSS property.

## Workflow

1. Inspect the existing stack, layout, components, design tokens, breakpoints, and user-authored changes.
2. Play back the visual brief in one compact sentence. Infer missing details when the request is clear; ask only when a decision materially changes the product.
3. Preserve the current framework and content unless replacement is requested. Avoid adding a UI library for an effect that CSS can provide.
4. Establish a calm background before tuning glass. Use broad tonal regions, depth, and a clear focal area; avoid high-frequency detail directly behind text.
5. Define reusable liquid-glass tokens and one shared surface primitive.
6. Apply glass selectively to navigation, controls, cards, overlays, and focal actions. Keep ordinary content surfaces simpler.
7. Add pointer, keyboard, touch, reduced-motion, and browser fallbacks.
8. Run the project checks, inspect desktop and mobile screenshots, and iterate until text, edges, layering, and motion remain clear.

## Load references selectively

- Read [references/visual-system.md](references/visual-system.md) before choosing background, opacity, hierarchy, or motion.
- Read [references/implementation.md](references/implementation.md) when implementing CSS, SVG refraction, React behavior, or fallbacks.
- Read [references/qa-checklist.md](references/qa-checklist.md) before final verification.
- Reuse [assets/demo](assets/demo) when a lightweight standalone starter or visual reference is useful.
  Use `assets/demo/before-after.html` when a public before/after showcase is needed.
  Use `assets/demo/ai-slop.html` when an intentionally flawed AI-generated baseline is useful for optimization demos.
- Run `node scripts/liquiglass-audit.mjs <project-path>` for a static implementation audit. Add `--strict` when missing production safeguards should fail the command.

## Build the surface primitive

Use a shared class or component with these conceptual layers:

1. Translucent tint establishes local contrast.
2. `backdrop-filter` blurs and saturates content behind the surface.
3. A one-pixel translucent border separates the glass from similar tones.
4. A pseudo-element supplies a directional specular highlight.
5. A restrained outer shadow establishes elevation.
6. An optional inner shadow gives the edge physical thickness.

Start from tokens rather than hardcoded values:

```css
:root {
  --lg-tint: rgb(255 255 255 / 0.14);
  --lg-tint-strong: rgb(255 255 255 / 0.22);
  --lg-border: rgb(255 255 255 / 0.34);
  --lg-highlight: rgb(255 255 255 / 0.58);
  --lg-shadow: 0 18px 50px rgb(15 23 42 / 0.18);
  --lg-blur: 22px;
  --lg-saturation: 145%;
  --lg-radius: 24px;
}
```

Tune tokens against the actual background. Do not increase blur automatically when readability is poor; first simplify the background, strengthen tint, or adjust text color.

## Interaction rules

- Open desktop menus on pointer hover and keyboard focus; also support click.
- Open mobile menus by explicit tap. Never depend on hover below the mobile breakpoint.
- Keep movement short and quiet: typically 160–320 ms with deceleration.
- Animate opacity and transform when possible. Avoid animating blur continuously on large surfaces.
- Use `:focus-visible`, Escape-to-close, outside-click handling, correct ARIA state, and at least 44 px touch targets.
- Respect `prefers-reduced-motion`; remove expansion travel and decorative background motion.

## Refraction policy

Use ordinary backdrop blur as the baseline. Add SVG displacement, masks, or WebGL only when the request explicitly needs visible refraction and the page can afford the complexity.

For enhanced refraction:

- Restrict displacement to compact, high-value surfaces.
- Keep text in a non-displaced foreground layer.
- Provide a static glass fallback.
- Disable or simplify the effect on reduced-motion, low-power, and unsupported environments.

## Quality bar

- Preserve readable contrast over every background state.
- Keep glass opacity and blur consistent by elevation level.
- Avoid glass-on-glass stacks unless the hierarchy remains obvious.
- Prevent clipped dropdown shadows and backdrop filters.
- Verify Safari-compatible `-webkit-backdrop-filter`.
- Never copy Apple logos, product imagery, proprietary typefaces, or protected page content. Reproduce interaction and material principles with original assets.
- Do not call the result complete until the build passes and desktop/mobile visual checks show no overflow, illegible text, broken focus, or abrupt motion.
