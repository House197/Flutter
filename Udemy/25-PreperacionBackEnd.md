# Sección 25. Preparación backend
## Temas
1. Docker
2. Docker compose
3. Imágenes de docker
4. Conectarse a postgres usando TablePlus
5. Probar el backend configurado
6. Llenar la base de datos
7. Leer la documentación del backend
8. Generar JWTs y probarlos
9. Uso de bearer tokens en los headers de autenticación
10. Trabajar las pruebas con Postman

## Backend - Nest - Postgres - Docker
https://github.com/Klerith/flutter-backend-teslo

## Sección 26. Autenticación - JWT - Rivepod
## Temas
1. Realizar el POST HTTP
2. Obtener las credenciales del usuario
3. Manejo de errores personalizados
4. Manejo del estado del formulario con Riverpod
5. Comunicación entre providers
6. Entre otras cosas

## 1. Inicio de aplicación

## 2. Riverpod - Inputs y LoginState
1. Instalar:
    1. formz
    2. flutter_riverpod
2. features -> shared -> infrastructure -> inputs -> email.dart
3. features -> shared -> infrastructure -> inputs -> password.dart
4. Riverpod
    1. features -> auth -> presentation -> providers -> login_form_provider.dart
        1. State del provider.
        2. Implementación de notifier.
        3. StateNotifierProvider - consume afuera.
            - Se usa autoDispose para que al cerrar la ventana se eliminen los datos que se hayan quedado en el formulario.
    2. Envolver MainApp en main.dart con ProviderScope.

``` dart
void main() {
  runApp(
    const ProviderScope(child: MainApp()),
  );
}
```

``` dart
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

```

5. Conectar formulario con Provider
    1. features -> presentation -> screens -> login_screen.dart
    2. Convertir Widget en ConsumerWidget.
    3. Definir WidgetRef en función build.
    4. Usar ref.watch para escuchar al provider deseado.
    5. Mostrar errores cuando el usuario haga submit del formulario, por lo que se debe colocar una condicional en errorMessage con el campo isFormPosted del estado.

## 3. Variables de entorno
1. Instalar flutter_dotenv
2. Crear archivos en raíz de proyecto:
  1. .env
  2. .env.template
3. config -> const -> evironment.dart
  - Se crea método para inicializar variables de entorno en main.dart
``` dart
class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: ".env");
  }

  static String apuUrl = dotenv.env['API_URL'] ?? 'No hay API';
}

```
4. Configurar variables de entorno en pubspec.yaml, en assets.

``` yml
flutter:
  uses-material-design: true

  assets:
    - assets/loaders/
    - assets/images/
    - google_fonts/montserrat_alternates/
    - .env
```

5. Inicializar variables de entorno en main.dart

``` dart
void main() async {
  await Environment.initEnvironment();
  runApp(
    const ProviderScope(child: MainApp()),
  );
}
```

## 4. Auth - Repositorio y Datasource
1. features -> auth -> domain -> entities -> user.dart
1. features -> auth -> domain -> datasources -> auth_datasource.dart
1. features -> auth -> domain -> repositories -> auth_repository.dart
1. features -> auth -> infrastructure -> mapper -> user_mapper.dart

## 5. Implementación Login
1. Instalar dio
2. Crear errores personalizado features -> auth -> infrastructure -> errors -> auth_errors.dart

## 6. Auth Provider
1. features -> auth -> providers -> auth_provider.dart