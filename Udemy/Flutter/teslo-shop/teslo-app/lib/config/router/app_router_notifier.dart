import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/providers/auth_provider.dart';

final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authNotifier);
});

class GoRouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  // En todo mometo de la app se debe estar pendiente de los cambios de authoNofitier, por lo que se le coloca addListener
  GoRouterNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }
}
