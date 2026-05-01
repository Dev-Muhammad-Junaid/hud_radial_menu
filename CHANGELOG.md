## 0.1.0

* **Breaking**: Bumped version to `0.1.0` to follow pub.dev versioning conventions.
* Targets Flutter `>=3.27.0` / Dart `>=3.6.0` (latest stable) — uses `Color.withValues(alpha:)` in place of the deprecated `withOpacity`.
* Added full dartdoc documentation to all public classes, enums, and properties.
* Fixed incorrect `homepage`, `repository`, and `issue_tracker` URLs in `pubspec.yaml`.
* Updated `pubspec.yaml` with `topics` and expanded description.
* Switched `_PetalPainter` switch-statement to exhaustive Dart 3 style (no `break`).
* Added GitHub Actions CI workflow (`analyze`, `format`, `test`, `publish --dry-run`).
* Added GitHub Pages deployment workflow for the live web example.
* Improved `README.md` with full API reference tables, code examples, and badges.

## 0.0.1

* Initial release.
* 5 petal styles: glassmorphism, neon glow, solid flat, wireframe, neumorphic.
* 5 petal shapes: rounded pie, sharp pie, squircle, chamfered rectangle, circle.
* Staggered entrance animations with `easeOutBack` bounce per petal.
* Hover and tap states with scale feedback (desktop/web).
* Fully customizable: colors, radii, blur sigma, gap angle, text, icons.
* Center toggle button with animated rotation and glow effect.
