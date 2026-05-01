import 'package:flutter_test/flutter_test.dart';
import 'package:hud_radial_menu/hud_radial_menu.dart';

void main() {
  test('HudRadialMenu can be instantiated', () {
    const menu = HudRadialMenu(items: []);
    expect(menu.items, isEmpty);
  });
}
