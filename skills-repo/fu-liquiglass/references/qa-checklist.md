# Liquid-glass QA checklist

## Visual

- Background has broad tonal structure and does not compete with navigation.
- Glass is visible over both the brightest and darkest background regions.
- Primary and secondary text remain legible in every open/closed state.
- Border, highlight, and shadow imply the same light direction.
- Dropdown density is stronger than or equal to its parent surface.
- No accidental double borders, clipped shadows, or rectangular pseudo-elements outside rounded corners.
- The design still works when decorative background motion is paused.

## Interaction

- Pointer hover opens and closes without crossing a dead gap.
- Click toggles predictably.
- Keyboard focus opens the relevant menu.
- Escape closes the current menu or drawer.
- Clicking outside closes non-modal menus.
- Focus rings are visible and not clipped.
- Mobile controls have at least 44 px targets.
- Mobile behavior does not rely on hover.

## Accessibility

- Trigger state uses `aria-expanded`.
- Menu or disclosure semantics match the actual interaction.
- Text contrast is checked over representative background states.
- `prefers-reduced-motion` disables decorative travel and continuous motion.
- Forced-colors mode has an opaque surface and visible boundary.
- Content order remains logical without CSS positioning.

## Responsive

- Check approximately 1440 × 900, 1024 × 768, 768 × 1024, and 390 × 844.
- No horizontal overflow at 320 px.
- Background crop keeps the navigation zone readable.
- Dropdowns remain within the viewport.
- Safe areas are respected on edge-mounted mobile controls.

## Performance and compatibility

- Build and lint commands pass.
- Safari enhancement includes `-webkit-backdrop-filter`.
- Unsupported browsers receive an opaque readable fallback.
- Large surfaces do not animate blur.
- Repeated glass nesting is minimized.
- Scroll and menu animation remain smooth under CPU throttling or on a mobile device.

## Delivery

- Summarize files changed and design decisions.
- Mention any deliberate fallback or unsupported enhancement.
- Provide a local preview or screenshot when the environment permits.

