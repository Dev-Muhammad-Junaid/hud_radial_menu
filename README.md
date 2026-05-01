# hud_radial_menu

[![pub package](https://img.shields.io/pub/v/hud_radial_menu.svg)](https://pub.dev/packages/hud_radial_menu)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A high-fidelity, interactive HUD radial menu for Flutter. Designed with premium aesthetics — featuring glassmorphism, neon glow, neumorphic depth, staggered entrance animations, and responsive hover/tap states.

---

## Features

- **5 Petal Styles** — Glassmorphism, Neon Glow, Solid Flat, Wireframe, Neumorphic
- **5 Petal Shapes** — Rounded Pie, Sharp Pie, Squircle, Chamfered Rectangle, Circle
- **Staggered animations** — each petal fans in with an `easeOutBack` bounce
- **Hover & press states** — scale + opacity feedback on desktop/web
- **Full theming** — control colors, radii, blur, gaps, text, icons, and more
- **Zero dependencies** — only requires Flutter SDK

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  hud_radial_menu: ^0.1.0
```

Then run:

```sh
flutter pub get
```

---

## Try the interactive example

- **Live (web):** [GitHub Pages demo](https://dev-muhammad-junaid.github.io/hud_radial_menu/) — enable **Settings → Pages → GitHub Actions** in this repo on first use; the **Deploy example (web)** workflow must succeed once.
- **In the package:** the published tarball includes the [`example/`](example/) Flutter project (interactive “lab” for every API option).
- On **pub.dev**, open the package’s repository link to browse `example/` online, or use your pub cache after `dart pub get`.


## Usage

### Minimal

```dart
import 'package:hud_radial_menu/hud_radial_menu.dart';

HudRadialMenu(
  items: const [
    MenuItemData(label: 'Settings', icon: Icons.settings_outlined),
    MenuItemData(label: 'Help',     icon: Icons.help_outline_rounded),
    MenuItemData(label: 'Files',    icon: Icons.folder_open_outlined),
  ],
  onItemSelected: (index) => debugPrint('Selected: $index'),
)
```

### Custom style & shape

```dart
HudRadialMenu(
  items: const [
    MenuItemData(label: 'Play',   icon: Icons.play_arrow_rounded,  tint: Color(0xFF69F0AE)),
    MenuItemData(label: 'Stop',   icon: Icons.stop_rounded,        tint: Color(0xFFFF9E9E)),
    MenuItemData(label: 'Share',  icon: Icons.share_rounded,       tint: Color(0xFF4A9EF5)),
    MenuItemData(label: 'Mute',   icon: Icons.volume_off_rounded,  tint: Color(0xFFFFD180)),
  ],
  petalStyle: PetalStyle.neonGlow,
  petalShape: PetalShape.roundedPie,
  innerRadius: 50,
  outerRadius: 150,
  menuSize: 340,
  onItemSelected: (index) { /* handle */ },
)
```

### Always-open (no center button)

```dart
HudRadialMenu(
  items: myItems,
  showCenterButton: false,
)
```

---

## API Reference

### `MenuItemData`

| Property | Type      | Default              | Description                          |
|----------|-----------|----------------------|--------------------------------------|
| `label`  | `String`  | required             | Text shown below the icon            |
| `icon`   | `IconData`| required             | Icon shown in the petal              |
| `tint`   | `Color`   | `Color(0xFFE0E5EC)`  | Petal background tint color          |

### `HudRadialMenu`

| Property            | Type                  | Default                  | Description                                        |
|---------------------|-----------------------|--------------------------|----------------------------------------------------|
| `items`             | `List<MenuItemData>`  | 8 default items          | Petal items                                        |
| `menuSize`          | `double`              | `360.0`                  | Widget bounding box size                           |
| `centerButtonSize`  | `double`              | `52.0`                   | Center button diameter                             |
| `innerRadius`       | `double`              | `45.0`                   | Inner ring radius                                  |
| `outerRadius`       | `double`              | `160.0`                  | Outer ring radius                                  |
| `gapAngle`          | `double`              | `0.05`                   | Gap between petals (radians)                       |
| `blurSigma`         | `double`              | `12.0`                   | Blur for glassmorphism style                       |
| `petalStyle`        | `PetalStyle`          | `glassmorphism`          | Visual style of petals                             |
| `petalShape`        | `PetalShape`          | `roundedPie`             | Geometric shape of petals                          |
| `hoverColor`        | `Color?`              | `null`                   | Petal fill on hover                                |
| `borderColor`       | `Color?`              | `null`                   | Petal border color override                        |
| `showCenterButton`  | `bool`                | `true`                   | Show / hide the center toggle button               |
| `showCenterGlow`    | `bool`                | `true`                   | Show glow behind center button                     |
| `centerGlowColor`   | `Color`               | `Color(0xFF4A9EF5)`      | Color of the center glow                           |
| `centerButtonColor` | `Color?`              | `null`                   | Center button background color                     |
| `centerIconColor`   | `Color?`              | `null`                   | Center button icon color                           |
| `textColor`         | `Color?`              | `null`                   | Petal label text color                             |
| `iconColor`         | `Color?`              | `null`                   | Petal icon color                                   |
| `hoverTextColor`    | `Color?`              | `null`                   | Label text color on hover                          |
| `hoverIconColor`    | `Color?`              | `null`                   | Icon color on hover                                |
| `onItemSelected`    | `ValueChanged<int>?`  | `null`                   | Callback with selected item index; menu auto-closes|

### `PetalStyle`

| Value            | Description                                         |
|------------------|-----------------------------------------------------|
| `glassmorphism`  | Frosted glass with radial gradient and backdrop blur |
| `solidFlat`      | Solid opaque fill with clean border                 |
| `neonGlow`       | Dark fill with glowing colored border               |
| `wireframe`      | Border-only; fills on hover                         |
| `neumorphic`     | Soft light/shadow depth effect                      |

### `PetalShape`

| Value           | Description                                    |
|-----------------|------------------------------------------------|
| `roundedPie`    | Pie slice with rounded outer corners (default) |
| `sharpPie`      | Standard sharp-edged pie slice                 |
| `squircle`      | Rounded rectangle at midpoint                  |
| `chamferedRect` | Clipped-corner rectangle at midpoint           |
| `circle`        | Circle at midpoint                             |

---

## Example

A full interactive demo with a live customizer is included in the [`example/`](example/) directory. Run it with:

```sh
cd example
flutter run
```

---

## License

MIT — see [LICENSE](LICENSE).
