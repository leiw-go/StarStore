# Liquid-glass visual system

## Contents

1. Design intent
2. Background strategy
3. Surface hierarchy
4. Typography and color
5. Edge light and depth
6. Motion
7. Common failure modes

## 1. Design intent

Aim for quiet precision rather than maximum transparency. A premium liquid-glass interface feels light because it uses fewer strong effects, not because every object is translucent.

Use three tests:

- **Silhouette:** the surface remains understandable when viewed as a shape.
- **Legibility:** text is readable without waiting for the background to change.
- **Material:** tint, edge light, blur, and shadow agree on one light direction.

## 2. Background strategy

Glass needs something behind it to reveal depth. Favor:

- large gradients or photographic tonal fields;
- one or two focal objects;
- a darker or quieter navigation zone;
- slow color transitions;
- enough contrast variation to make refraction visible.

Avoid:

- dense foliage, text, or tiny highlights behind navigation;
- evenly flat backgrounds that make glass look like transparent gray;
- strong faces or product details directly under blur;
- unrelated decorative blobs added only to prove transparency.

When using imagery, place the focal subject away from primary navigation or add a subtle local wash. Crop responsively rather than forcing one `background-position` at every size.

## 3. Surface hierarchy

Use no more than three material levels:

| Level | Typical use | Tint | Blur | Shadow |
| --- | --- | --- | --- | --- |
| Air | chips, small icon buttons | low | 12–18 px | minimal |
| Glass | navigation, cards, dropdowns | medium | 18–28 px | soft |
| Dense glass | mobile drawer, modal, critical menu | stronger | 24–36 px | clear |

Dropdowns may be denser than the parent navigation because they must remain readable over unpredictable content. Keep their radius visually related to the parent, usually parent radius minus 4–10 px.

## 4. Typography and color

Use the system font stack unless the product already has a type system:

```css
font-family: ui-sans-serif, -apple-system, BlinkMacSystemFont, "SF Pro Display",
  "Segoe UI", sans-serif;
```

Do not ship Apple proprietary font files. On Apple devices the system stack resolves naturally; elsewhere it uses an appropriate local fallback.

Prefer near-black or white text chosen from the actual background. Secondary text should still meet contrast needs. Avoid thin font weights over moving imagery.

## 5. Edge light and depth

Choose one implied light source, normally upper-left. Build depth from:

- a brighter top/left border or pseudo-element;
- a weaker lower/right edge;
- a broad low-opacity outer shadow;
- a very subtle inner shadow.

Do not use uniform white outlines at high opacity; they make the surface look plastic. Edge highlights should be directional and should fade.

Example highlight:

```css
.liquid-glass::before {
  content: "";
  position: absolute;
  inset: 1px;
  border-radius: inherit;
  background:
    linear-gradient(135deg, rgb(255 255 255 / 0.42), transparent 38%),
    radial-gradient(circle at 85% 110%, rgb(255 255 255 / 0.16), transparent 44%);
  pointer-events: none;
  mask: linear-gradient(#000, #000) content-box, linear-gradient(#000, #000);
  padding: 1px;
  mask-composite: exclude;
}
```

## 6. Motion

Make motion explain state:

- a caret rotates when a menu opens;
- the surface expands from its trigger;
- content fades slightly after the container begins moving;
- hover increases tint or edge light by a small amount.

Recommended timing:

- hover feedback: 120–180 ms;
- menu open: 220–300 ms;
- menu close: 160–220 ms;
- mobile panel: 260–360 ms.

Use easing close to `cubic-bezier(.2,.8,.2,1)`. Avoid spring overshoot on navigation unless the broader product language uses it.

## 7. Common failure modes

- **Fogged glass:** blur is high but tint and contrast are weak.
- **Plastic card:** opaque fill plus bright uniform border.
- **Dirty layering:** multiple translucent surfaces overlap without a hierarchy.
- **Wallpaper UI:** the background is more visually active than the product.
- **Hover trap:** a gap between trigger and dropdown closes the menu.
- **Mobile shrink:** desktop hover menus are merely compressed rather than redesigned for touch.
- **Performance shimmer:** large animated filters repaint continuously.

