import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MenuItemData {
  final String label;
  final IconData icon;
  final Color tint;

  const MenuItemData({
    required this.label,
    required this.icon,
    this.tint = const Color(0xFFE0E5EC), // Default frosted whitish tint
  });
}

enum PetalStyle {
  glassmorphism,
  solidFlat,
  neonGlow,
  wireframe,
  neumorphic,
}

enum PetalShape {
  roundedPie,
  sharpPie,
  squircle,
  chamferedRect,
  circle,
}

class HudRadialMenu extends StatefulWidget {
  final List<MenuItemData> items;
  final double menuSize;
  final double centerButtonSize;
  final double innerRadius;
  final double outerRadius;
  final double gapAngle;
  final double blurSigma;
  final PetalStyle petalStyle;
  final PetalShape petalShape;
  final Color? hoverColor;
  final Color? borderColor;
  final bool showCenterButton;
  final bool showCenterGlow;
  final Color centerGlowColor;
  final Color? centerButtonColor;
  final Color? centerIconColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? hoverTextColor;
  final Color? hoverIconColor;
  final ValueChanged<int>? onItemSelected;

  const HudRadialMenu({
    super.key,
    this.items = const [
      MenuItemData(label: 'Settings', icon: Icons.settings_outlined),
      MenuItemData(label: 'Help', icon: Icons.help_outline_rounded),
      MenuItemData(label: 'Open files', icon: Icons.folder_open_outlined),
      MenuItemData(
          label: 'Queue',
          icon: Icons.queue_music_rounded,
          tint: Color(0xFFFF9E9E)), // Reddish tint as in the image
      MenuItemData(label: 'Properties', icon: Icons.info_outline_rounded),
      MenuItemData(label: 'Equalizer', icon: Icons.tune_rounded),
      MenuItemData(label: 'Cast', icon: Icons.cast_rounded),
      MenuItemData(label: 'Speed', icon: Icons.speed_rounded),
    ],
    this.menuSize = 360.0,
    this.centerButtonSize = 52.0,
    this.innerRadius = 45.0,
    this.outerRadius = 160.0,
    this.gapAngle = 0.05,
    this.blurSigma = 12.0,
    this.petalStyle = PetalStyle.glassmorphism,
    this.petalShape = PetalShape.roundedPie,
    this.hoverColor,
    this.borderColor,
    this.showCenterButton = true,
    this.showCenterGlow = true,
    this.centerGlowColor = const Color(0xFF4A9EF5),
    this.centerButtonColor,
    this.centerIconColor,
    this.textColor,
    this.iconColor,
    this.hoverTextColor,
    this.hoverIconColor,
    this.onItemSelected,
  });

  @override
  State<HudRadialMenu> createState() => _HudRadialMenuState();
}

class _HudRadialMenuState extends State<HudRadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;
  int _hoveredIndex = -1;
  int _pressedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    if (!widget.showCenterButton) {
      _isOpen = true;
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(HudRadialMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showCenterButton != oldWidget.showCenterButton) {
      if (!widget.showCenterButton && !_isOpen) {
        _isOpen = true;
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _onItemTap(int index) {
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(index);
    } else {
      debugPrint('Tapped: ${widget.items[index].label}');
    }
    _toggle();
  }

  /// Creates a petal shaped path mimicking the reference image
  Path _createPetalPath(
    Offset center,
    double midAngle,
    double innerR,
    double outerR,
    double halfSweep,
  ) {
    final adjustedHalf = halfSweep - widget.gapAngle;

    // Helper to get a point on the circle
    Offset p(double r, double a) =>
        Offset(center.dx + r * cos(a), center.dy + r * sin(a));

    if (widget.petalShape == PetalShape.sharpPie) {
      final path = Path();
      path.moveTo(p(innerR, midAngle - adjustedHalf).dx, p(innerR, midAngle - adjustedHalf).dy);
      path.arcToPoint(p(innerR, midAngle + adjustedHalf), radius: Radius.circular(innerR), clockwise: true);
      path.lineTo(p(outerR, midAngle + adjustedHalf).dx, p(outerR, midAngle + adjustedHalf).dy);
      path.arcToPoint(p(outerR, midAngle - adjustedHalf), radius: Radius.circular(outerR), clockwise: false);
      path.close();
      return path;
    }

    final contentRadius = innerR + (outerR - innerR) * 0.5;
    final contentPos = p(contentRadius, midAngle);

    if (widget.petalShape == PetalShape.circle) {
      final radius = (outerR - innerR) * 0.38;
      return Path()..addOval(Rect.fromCircle(center: contentPos, radius: radius));
    }

    if (widget.petalShape == PetalShape.squircle || widget.petalShape == PetalShape.chamferedRect) {
      final actualH = (outerR - innerR) * 0.75;
      final actualW = contentRadius * adjustedHalf * 1.6;

      final localPath = Path();
      if (widget.petalShape == PetalShape.squircle) {
        localPath.addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: actualW, height: actualH),
          Radius.circular(actualW * 0.25),
        ));
      } else {
        final cut = actualW * 0.2;
        localPath
          ..moveTo(-actualW / 2 + cut, -actualH / 2)
          ..lineTo(actualW / 2, -actualH / 2)
          ..lineTo(actualW / 2, actualH / 2 - cut)
          ..lineTo(actualW / 2 - cut, actualH / 2)
          ..lineTo(-actualW / 2, actualH / 2)
          ..lineTo(-actualW / 2, -actualH / 2 + cut)
          ..close();
      }

      final matrix = Matrix4.identity()
        ..setTranslationRaw(contentPos.dx, contentPos.dy, 0.0)
        ..rotateZ(midAngle + pi / 2);
      return localPath.transform(matrix.storage);
    }

    // Default: roundedPie
    // We approximate the rounded pie slice using a continuous path.
    // The image shows petals with straight diverging sides and rounded corners.
    const cornerRadiusOuter = 16.0;

    final path = Path();

    // 1. Inner left corner
    final innerLeft = p(innerR, midAngle - adjustedHalf + 0.1);
    path.moveTo(innerLeft.dx, innerLeft.dy);

    // 2. Inner arc to inner right
    final innerRight = p(innerR, midAngle + adjustedHalf - 0.1);
    path.arcToPoint(
      innerRight,
      radius: Radius.circular(innerR),
      clockwise: true,
    );

    // 3. Line/curve to outer right
    final outerRightBlend = p(outerR - cornerRadiusOuter, midAngle + adjustedHalf);
    final ctrlRight = p(innerR + (outerR - innerR) * 0.5, midAngle + adjustedHalf);
    path.quadraticBezierTo(
      ctrlRight.dx,
      ctrlRight.dy,
      outerRightBlend.dx,
      outerRightBlend.dy,
    );

    // 4. Outer right rounded corner
    final outerRightArcEnd = p(outerR, midAngle + adjustedHalf - 0.15);
    path.arcToPoint(
      outerRightArcEnd,
      radius: const Radius.circular(cornerRadiusOuter),
      clockwise: true,
    );

    // 5. Outer arc to outer left
    final outerLeftArcStart = p(outerR, midAngle - adjustedHalf + 0.15);
    path.arcToPoint(
      outerLeftArcStart,
      radius: Radius.circular(outerR),
      clockwise: false,
    );

    // 6. Outer left rounded corner
    final outerLeftBlend = p(outerR - cornerRadiusOuter, midAngle - adjustedHalf);
    path.arcToPoint(
      outerLeftBlend,
      radius: const Radius.circular(cornerRadiusOuter),
      clockwise: true,
    );

    // 7. Line/curve back to inner left
    final ctrlLeft = p(innerR + (outerR - innerR) * 0.5, midAngle - adjustedHalf);
    path.quadraticBezierTo(
      ctrlLeft.dx,
      ctrlLeft.dy,
      innerLeft.dx,
      innerLeft.dy,
    );

    path.close();
    return path;
  }

  Offset _polar(Offset center, double r, double angle) {
    return Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.menuSize,
      height: widget.menuSize,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Center button rotation/glow progress
          final progress = Curves.easeOutCubic.transform(
            _controller.value.clamp(0.0, 1.0),
          );
          final center = Offset(widget.menuSize / 2, widget.menuSize / 2);

          return Stack(
            children: [
              // Petal segments
              ...List.generate(widget.items.length, (i) {
                // Staggered entrance animation
                final staggerDelay = i * 0.03;
                final petalProgress = Curves.easeOutBack.transform(
                  ((_controller.value - staggerDelay) / (1.0 - staggerDelay))
                      .clamp(0.0, 1.0),
                );

                if (petalProgress <= 0) return const SizedBox.shrink();

                final midAngle = -pi / 2 + (2 * pi / widget.items.length) * i;
                final halfSweep = pi / widget.items.length;

                final petalPath = _createPetalPath(
                  center,
                  midAngle,
                  widget.innerRadius,
                  widget.outerRadius,
                  halfSweep,
                );

                // Calculate icon and label positions
                final contentRadius = widget.innerRadius +
                    (widget.outerRadius - widget.innerRadius) * 0.5;
                final contentPos = _polar(center, contentRadius, midAngle);

                final isHovered = _hoveredIndex == i;
                final isPressed = _pressedIndex == i;
                
                // Emil's design principles: responsive buttons, scale on active
                final scaleFactor = isPressed
                    ? 0.96
                    : isHovered
                        ? 1.03
                        : 1.0;

                // Entry animation: scale from 0.85 to 1.0, fade from 0 to 1
                final currentScale = 0.85 + (0.15 * petalProgress) * scaleFactor;

                return Opacity(
                  opacity: (petalProgress * (isHovered ? 1.0 : 0.9)).clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: currentScale,
                    alignment: Alignment.center,
                    child: ClipPath(
                      clipper: _PetalClipper(petalPath),
                      child: GestureDetector(
                        onTapDown: (_) => setState(() => _pressedIndex = i),
                        onTapUp: (_) {
                          setState(() => _pressedIndex = -1);
                          _onItemTap(i);
                        },
                        onTapCancel: () => setState(() => _pressedIndex = -1),
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = i),
                          onExit: (_) => setState(() => _hoveredIndex = -1),
                          child: _buildStyleContainer(
                            petalPath: petalPath,
                            tint: widget.items[i].tint,
                            isHovered: isHovered,
                            isPressed: isPressed,
                            contentPos: contentPos,
                            icon: widget.items[i].icon,
                            label: widget.items[i].label,
                            menuSize: widget.menuSize,
                            blurSigma: widget.blurSigma,
                            petalStyle: widget.petalStyle,
                            hoverColor: widget.hoverColor,
                            borderColor: widget.borderColor,
                            textColor: widget.textColor,
                            iconColor: widget.iconColor,
                            hoverTextColor: widget.hoverTextColor,
                            hoverIconColor: widget.hoverIconColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Center button glow
              if (widget.showCenterGlow && _controller.value > 0)
                Positioned(
                  left: center.dx - 40,
                  top: center.dy - 40,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: progress.clamp(0.0, 1.0) * 0.3,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.centerGlowColor,
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Center toggle button
              if (widget.showCenterButton)
                Positioned(
                  left: center.dx - widget.centerButtonSize / 2,
                  top: center.dy - widget.centerButtonSize / 2,
                  child: GestureDetector(
                    onTap: _toggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: widget.centerButtonSize,
                      height: widget.centerButtonSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.centerButtonColor ?? const Color(0xFF232D42),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.centerGlowColor.withValues(alpha: 0.2),
                            blurRadius: _isOpen ? 12 : 4,
                            spreadRadius: _isOpen ? 1 : 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: AnimatedRotation(
                        turns: _isOpen ? 0.25 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        child: Icon(
                          Icons.more_horiz_rounded,
                          color: widget.centerIconColor ?? Colors.white.withValues(alpha: 0.9),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStyleContainer({
    required Path petalPath,
    required Color tint,
    required bool isHovered,
    required bool isPressed,
    required Offset contentPos,
    required IconData icon,
    required String label,
    required double menuSize,
    required double blurSigma,
    required PetalStyle petalStyle,
    required Color? hoverColor,
    required Color? borderColor,
    required Color? textColor,
    required Color? iconColor,
    required Color? hoverTextColor,
    required Color? hoverIconColor,
  }) {
    final customPaint = CustomPaint(
      size: Size(menuSize, menuSize),
      painter: _PetalPainter(
        path: petalPath,
        tint: tint,
        isHovered: isHovered,
        isPressed: isPressed,
        style: petalStyle,
        hoverColor: hoverColor,
        borderColor: borderColor,
      ),
      child: Stack(
        children: [
          Positioned(
            left: contentPos.dx - 40,
            top: contentPos.dy - 24,
            child: SizedBox(
              width: 80,
              height: 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: isHovered
                        ? (hoverIconColor ?? iconColor ?? Colors.white.withValues(alpha: 1.0))
                        : (iconColor ?? Colors.white.withValues(alpha: 0.85)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
                      color: isHovered
                          ? (hoverTextColor ?? textColor ?? Colors.white.withValues(alpha: 1.0))
                          : (textColor ?? Colors.white.withValues(alpha: 0.75)),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (petalStyle == PetalStyle.glassmorphism) {
      return BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: customPaint,
      );
    }
    return customPaint;
  }
}

class _PetalClipper extends CustomClipper<Path> {
  final Path petalPath;

  _PetalClipper(this.petalPath);

  @override
  Path getClip(Size size) => petalPath;

  @override
  bool shouldReclip(covariant _PetalClipper oldClipper) => true;
}

class _PetalPainter extends CustomPainter {
  final Path path;
  final Color tint;
  final bool isHovered;
  final bool isPressed;
  final PetalStyle style;
  final Color? hoverColor;
  final Color? borderColor;

  _PetalPainter({
    required this.path,
    required this.tint,
    required this.isHovered,
    required this.isPressed,
    required this.style,
    this.hoverColor,
    this.borderColor,
  });

  Color get _activeTint => (isHovered && hoverColor != null) ? hoverColor! : tint;
  Color get _activeBorder => borderColor ?? _activeTint;

  @override
  void paint(Canvas canvas, Size size) {
    switch (style) {
      case PetalStyle.glassmorphism:
        _paintGlassmorphism(canvas, size);
        break;
      case PetalStyle.solidFlat:
        _paintSolidFlat(canvas, size);
        break;
      case PetalStyle.neonGlow:
        _paintNeonGlow(canvas, size);
        break;
      case PetalStyle.wireframe:
        _paintWireframe(canvas, size);
        break;
      case PetalStyle.neumorphic:
        _paintNeumorphic(canvas, size);
        break;
    }
  }

  void _paintGlassmorphism(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Glassmorphism base fill
    final baseAlpha = isHovered ? 0.35 : (isPressed ? 0.20 : 0.25);
    final fillPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        size.width / 2,
        [
          _activeTint.withValues(alpha: baseAlpha + 0.1),
          _activeTint.withValues(alpha: baseAlpha * 0.7),
          _activeTint.withValues(alpha: baseAlpha * 0.4),
        ],
        [0.2, 0.7, 1.0],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // Inner highlight (top-left light source for 3D bevel effect)
    final highlightPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(center.dx - 100, center.dy - 100),
        Offset(center.dx + 100, center.dy + 100),
        [
          Colors.white.withValues(alpha: isHovered ? 0.25 : 0.15),
          Colors.white.withValues(alpha: 0.0),
          Colors.black.withValues(alpha: 0.1),
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, highlightPaint);

    // Subtle 3D border stroke
    final bColor = borderColor ?? Colors.white;
    final borderPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(center.dx - 100, center.dy - 100),
        Offset(center.dx + 100, center.dy + 100),
        [
          bColor.withValues(alpha: isHovered ? 0.5 : 0.3),
          bColor.withValues(alpha: 0.05),
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, borderPaint);
  }

  void _paintSolidFlat(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = isPressed
          ? _activeTint.withValues(alpha: 0.6)
          : (isHovered ? _activeTint : _activeTint.withValues(alpha: 0.8))
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = _activeBorder.withValues(alpha: isHovered ? 1.0 : 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, borderPaint);
  }

  void _paintNeonGlow(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    final borderPaint = Paint()
      ..color = _activeBorder.withValues(alpha: isHovered ? 1.0 : 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final glowPaint = Paint()
      ..color = _activeBorder.withValues(alpha: isHovered ? 0.8 : 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHovered ? 8.0 : 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, borderPaint);
  }

  void _paintWireframe(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = _activeBorder.withValues(alpha: isHovered ? 1.0 : 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(path, borderPaint);

    if (isHovered) {
      final fillPaint = Paint()
        ..color = _activeTint.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }
  }

  void _paintNeumorphic(Canvas canvas, Size size) {
    const baseColor = Color(0xFF131D31);
    final blendedColor = Color.lerp(baseColor, _activeTint, 0.2)!;
    
    final fillPaint = Paint()
      ..color = blendedColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    if (isPressed) {
      final innerShadowPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(size.width / 2 - 50, size.height / 2 - 50),
          Offset(size.width / 2 + 50, size.height / 2 + 50),
          [Colors.black.withValues(alpha: 0.8), Colors.transparent],
        )
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, innerShadowPaint);
    } else {
      final lightPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(size.width / 2 - 80, size.height / 2 - 80),
          Offset(size.width / 2, size.height / 2),
          [Colors.white.withValues(alpha: 0.12), Colors.transparent],
        )
        ..style = PaintingStyle.fill;

      final darkPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(size.width / 2, size.height / 2),
          Offset(size.width / 2 + 80, size.height / 2 + 80),
          [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
        )
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, lightPaint);
      canvas.drawPath(path, darkPaint);
    }

    if (borderColor != null) {
      final borderPaint = Paint()
        ..color = borderColor!.withValues(alpha: isHovered ? 0.5 : 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawPath(path, borderPaint);
    }

    if (isHovered && hoverColor != null) {
      final hoverPaint = Paint()
        ..color = hoverColor!.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, hoverPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PetalPainter oldDelegate) {
    return oldDelegate.isHovered != isHovered ||
        oldDelegate.isPressed != isPressed ||
        oldDelegate.tint != tint ||
        oldDelegate.style != style ||
        oldDelegate.hoverColor != hoverColor ||
        oldDelegate.borderColor != borderColor;
  }

  @override
  bool hitTest(Offset position) {
    return path.contains(position);
  }
}
