# HUD Radial Menu

A high-fidelity, interactive HUD radial menu for Flutter. Designed with premium aesthetics in mind, featuring glassmorphism, neon glow, and smooth animations inspired by modern UI design principles.

## Features

- **Multiple Styles**: Glassmorphism, Neon Glow, Solid Flat, Wireframe, and Neumorphic.
- **Customizable Shapes**: Rounded Pie, Sharp Pie, Squircle, Chamfered Rectangle, and Circle.
- **Smooth Animations**: Staggered entrance animations and responsive hover/tap effects.
- **Highly Configurable**: Control radii, gap angles, colors, blur sigma, and more.
- **Premium Aesthetics**: Built to wow users with a modern, high-tech look.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  hud_radial_menu: ^0.0.1
```

## Usage

```dart
import 'package:hud_radial_menu/hud_radial_menu.dart';

HudRadialMenu(
  items: [
    MenuItemData(label: 'Settings', icon: Icons.settings_outlined),
    MenuItemData(label: 'Help', icon: Icons.help_outline_rounded),
    // ...
  ],
  petalStyle: PetalStyle.glassmorphism,
  onItemSelected: (index) {
    print('Selected index: $index');
  },
)
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
