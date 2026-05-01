import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:hud_radial_menu/hud_radial_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUD Radial Menu Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      home: const HudMenuDemo(),
    );
  }
}

class HudMenuDemo extends StatefulWidget {
  const HudMenuDemo({super.key});

  @override
  State<HudMenuDemo> createState() => _HudMenuDemoState();
}

class _HudMenuDemoState extends State<HudMenuDemo> {
  // Configurable properties
  double _menuSize = 360.0;
  double _innerRadius = 45.0;
  double _outerRadius = 160.0;
  double _gapAngle = 0.05;
  double _blurSigma = 12.0;
  PetalStyle _petalStyle = PetalStyle.glassmorphism;
  PetalShape _petalShape = PetalShape.roundedPie;
  
  int _itemCount = 8;
  Color? _baseColor;
  Color? _hoverColor;
  Color? _borderColor;
  bool _showCenterButton = true;
  bool _showCenterGlow = true;
  Color? _centerGlowColor;
  Color? _centerButtonColor;
  Color? _centerIconColor;
  Color? _textColor;
  Color? _iconColor;
  Color? _hoverTextColor;
  Color? _hoverIconColor;

  List<MenuItemData> get _currentItems {
    final allItems = [
      const MenuItemData(label: 'Settings', icon: Icons.settings_outlined),
      const MenuItemData(label: 'Help', icon: Icons.help_outline_rounded),
      const MenuItemData(label: 'Open files', icon: Icons.folder_open_outlined),
      const MenuItemData(label: 'Queue', icon: Icons.queue_music_rounded),
      const MenuItemData(label: 'Properties', icon: Icons.info_outline_rounded),
      const MenuItemData(label: 'Equalizer', icon: Icons.tune_rounded),
      const MenuItemData(label: 'Cast', icon: Icons.cast_rounded),
      const MenuItemData(label: 'Speed', icon: Icons.speed_rounded),
      const MenuItemData(label: 'Share', icon: Icons.share_rounded),
      const MenuItemData(label: 'Favorite', icon: Icons.favorite_border_rounded),
      const MenuItemData(label: 'Lock', icon: Icons.lock_outline_rounded),
      const MenuItemData(label: 'Sync', icon: Icons.sync_rounded),
    ];
    
    return allItems.take(_itemCount).map((item) {
      if (_baseColor != null) {
        return MenuItemData(label: item.label, icon: item.icon, tint: _baseColor!);
      }
      return item;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar Customizer
          Container(
            width: 320,
            decoration: BoxDecoration(
              color: const Color(0xFF151923),
              border: Border(
                right: BorderSide(
                  color: Colors.white.withAlpha(25),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withAlpha(12),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.tune_rounded, color: Color(0xFF4A9EF5)),
                      SizedBox(width: 12),
                      Text(
                        'HUD Customizer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildDropdown<PetalStyle>(
                        'Menu Style',
                        _petalStyle,
                        PetalStyle.values,
                        _formatStyleName,
                        (v) => setState(() => _petalStyle = v!),
                      ),
                      const SizedBox(height: 12),
                      _buildDropdown<PetalShape>(
                        'Button Shape',
                        _petalShape,
                        PetalShape.values,
                        _formatShapeName,
                        (v) => setState(() => _petalShape = v!),
                      ),
                      const SizedBox(height: 12),
                      _buildSlider('Item Count', _itemCount.toDouble(), 3, 12, (v) => setState(() => _itemCount = v.toInt()), isInt: true),
                      const SizedBox(height: 12),
                      _buildSlider('Menu Size', _menuSize, 250, 600, (v) => setState(() => _menuSize = v)),
                      _buildSlider('Inner Radius', _innerRadius, 20, 100, (v) => setState(() => _innerRadius = v)),
                      _buildSlider('Outer Radius', _outerRadius, 100, 280, (v) => setState(() => _outerRadius = v)),
                      _buildSlider('Gap Angle', _gapAngle, 0.0, 0.15, (v) => setState(() => _gapAngle = v)),
                      _buildSlider('Blur Sigma (Glass)', _blurSigma, 0.0, 30.0, (v) => setState(() => _blurSigma = v)),
                      const SizedBox(height: 12),
                      _buildColorPicker('Base Color (Tint)', _baseColor, (v) => setState(() => _baseColor = v)),
                      _buildColorPicker('Hover Color', _hoverColor, (v) => setState(() => _hoverColor = v)),
                      _buildColorPicker('Border Color', _borderColor, (v) => setState(() => _borderColor = v)),
                      _buildColorPicker('Text Color', _textColor, (v) => setState(() => _textColor = v)),
                      _buildColorPicker('Hover Text Color', _hoverTextColor, (v) => setState(() => _hoverTextColor = v)),
                      _buildColorPicker('Icon Color', _iconColor, (v) => setState(() => _iconColor = v)),
                      _buildColorPicker('Hover Icon Color', _hoverIconColor, (v) => setState(() => _hoverIconColor = v)),
                      
                      const SizedBox(height: 12),
                      _buildSwitch('Show Center Button', _showCenterButton, (v) => setState(() => _showCenterButton = v)),
                      if (_showCenterButton) ...[
                        _buildColorPicker('Center Button Color', _centerButtonColor, (v) => setState(() => _centerButtonColor = v)),
                        _buildColorPicker('Center Icon Color', _centerIconColor, (v) => setState(() => _centerIconColor = v)),
                      ],
                      _buildSwitch('Show Center Glow', _showCenterGlow, (v) => setState(() => _showCenterGlow = v)),
                      if (_showCenterGlow)
                        _buildColorPicker('Center Glow Color', _centerGlowColor, (v) => setState(() => _centerGlowColor = v)),

                      const SizedBox(height: 24),
                      const Text(
                        'Note: Tap the center button in the preview to toggle the menu open/closed and see the entrance animations.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Right Preview Area
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A1628),
                    Color(0xFF0D1B3E),
                    Color(0xFF0A1628),
                  ],
                ),
              ),
              child: Center(
                child: HudRadialMenu(
                  items: _currentItems,
                  menuSize: _menuSize,
                  innerRadius: _innerRadius,
                  outerRadius: _outerRadius,
                  gapAngle: _gapAngle,
                  blurSigma: _blurSigma,
                  petalStyle: _petalStyle,
                  petalShape: _petalShape,
                  hoverColor: _hoverColor,
                  borderColor: _borderColor,
                  textColor: _textColor,
                  iconColor: _iconColor,
                  hoverTextColor: _hoverTextColor,
                  hoverIconColor: _hoverIconColor,
                  showCenterButton: _showCenterButton,
                  centerButtonColor: _centerButtonColor,
                  centerIconColor: _centerIconColor,
                  showCenterGlow: _showCenterGlow,
                  centerGlowColor: _centerGlowColor ?? const Color(0xFF4A9EF5),
                  onItemSelected: (index) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected: ${_currentItems[index].label}')),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged, {bool isInt = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
            Text(
              isInt ? value.toInt().toString() : value.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFeatures: [ui.FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF4A9EF5),
            inactiveTrackColor: Colors.white.withAlpha(25),
            thumbColor: Colors.white,
            overlayColor: const Color(0xFF4A9EF5).withAlpha(51),
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _formatStyleName(PetalStyle style) {
    switch (style) {
      case PetalStyle.glassmorphism: return 'Glassmorphism';
      case PetalStyle.solidFlat: return 'Solid Flat';
      case PetalStyle.neonGlow: return 'Neon Glow';
      case PetalStyle.wireframe: return 'Wireframe';
      case PetalStyle.neumorphic: return 'Neumorphic';
    }
  }

  String _formatShapeName(PetalShape shape) {
    switch (shape) {
      case PetalShape.roundedPie: return 'Rounded Pie (Default)';
      case PetalShape.sharpPie: return 'Sharp Pie';
      case PetalShape.squircle: return 'Squircle';
      case PetalShape.chamferedRect: return 'Chamfered Rectangle';
      case PetalShape.circle: return 'Circle';
    }
  }

  Widget _buildDropdown<T>(
    String label,
    T currentValue,
    List<T> values,
    String Function(T) formatter,
    ValueChanged<T?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withAlpha(25)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: currentValue,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E2532),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
              items: values.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    formatter(item),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildColorPicker(String label, Color? currentValue, ValueChanged<Color?> onChanged) {
    final colors = <Color?>[
      null,
      Colors.white,
      const Color(0xFF1E2532),
      const Color(0xFF4A9EF5),
      const Color(0xFFFF9E9E),
      const Color(0xFF69F0AE),
      const Color(0xFFB388FF),
      const Color(0xFFFFD180),
      Colors.transparent,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((c) {
            final isSelected = currentValue == c;
            final isTransparent = c == Colors.transparent;
            return GestureDetector(
              onTap: () => onChanged(c),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isTransparent ? Colors.transparent : c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.white24,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: c == null
                    ? const Icon(Icons.auto_awesome, size: 14, color: Colors.white70)
                    : isTransparent
                        ? const Icon(Icons.format_color_reset, size: 16, color: Colors.white54)
                        : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF4A9EF5),
            activeTrackColor: const Color(0xFF4A9EF5).withAlpha(76),
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: Colors.white.withAlpha(25),
          ),
        ],
      ),
    );
  }
}
