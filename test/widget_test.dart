// Test básico de humo para verificar que la app puede instanciarse.
//
// Para ejecutar: flutter test

import 'package:flutter_test/flutter_test.dart';

import 'package:wasistudent/providers/theme_provider.dart';
import 'package:wasistudent/providers/role_provider.dart';

void main() {
  test('ThemeProvider puede ser instanciado y toggled', () {
    final provider = ThemeProvider();
    expect(provider.isDark, false);
    provider.toggleTheme();
    expect(provider.isDark, true);
  });

  test('RoleProvider puede ser instanciado y cambiado', () {
    final provider = RoleProvider();
    expect(provider.activeRole, UserRole.student);
    expect(provider.isOwner, false);
    expect(provider.isOwnerEnabled, false);

    provider.enableOwnerRole();
    expect(provider.isOwnerEnabled, true);

    provider.switchRole(UserRole.owner);
    expect(provider.activeRole, UserRole.owner);
    expect(provider.isOwner, true);

    provider.disableOwnerRole();
    expect(provider.isOwnerEnabled, false);
    expect(provider.activeRole, UserRole.student);
  });
}
