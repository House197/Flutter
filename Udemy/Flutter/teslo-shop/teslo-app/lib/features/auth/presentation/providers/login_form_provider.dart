// 1. State del provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/inputs/email.dart';
import 'package:teslo_shop/features/shared/inputs/password.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final Email email;
  final bool isValid;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.email = const Email.pure(),
    this.isValid = false,
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    Email? email,
    bool? isValid,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        email: email ?? this.email,
        isValid: isValid ?? this.isValid,
        password: password ?? this.password,
      );

  // Se le hace override para hacer la evaluación del estado más rápida.
  @override
  String toString() {
    return ''' 
    LoginFormState:
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      email: $email
      isValid: $isValid
      password: $password
    ''';
  }
}

// 2. Implementación de notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;
    //  Print llama al método toString que se le hizo override.
    print(state);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    );
  }
}

// 3. StateNotifierProvider - consume afuera
final loginFormNotifier = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});
