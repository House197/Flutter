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
    - WrongCredentials se va a dar por estado 400, bad request, unauthorized
        - Cualquier otro error sería un error no controlador.
``` dart
class WrongCredentials implements Exception {}

class InvalidToken implements Exception {}

class ConnectionTimeot implements Exception {}

class CustomError implements Exception {
  final String message;
  final int errorCode;

  CustomError(
    this.message,
    this.errorCode,
  );
}


```

### Login y logout desde provider
``` dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infrastructure/repositories/auth_repository_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  AuthNotifier({required this.authRepository}) : super(AuthState());

  void loginUser(String email, String password) async {
    // Se coloca un delay intencional
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials catch (e) {
      logout('Credenciales no son correctas');
    } catch (e) {
      logout('Error no controlador');
    }
  }

  void registerUser(String email, String pssword) async {}

  void checkAuthStatus(String email, String pssword) async {}

  void _setLoggedUser(User user) {
    // TODO: guardar token físicamente
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout([String? errorMessage]) async {
    // TODO: limpiar token
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

```

## 6. Auth Provider
1. features -> auth -> providers -> auth_provider.dart

## 7. Obtener el Token de acceso
1. Quitar dependencia ocula en login_form_provider y mostrar que hay dependencia para obtener la función o método del login que se encuentra en AuthNotifier.

- Por el momento se va a tener un error de 'Connection refused', lo cual sucede con emuladores Android.
    - Esto sucede porque se llama localhost en el emulador de Android
    - Se debe apuntar al IP de la máquina donde corre el servicio, lo cual se hace en la dirección de la API colocada en .env.

## 8. Manejo de errores
1. En archivo auth_datasource_impl.dart
  - Se verifican las exepciones que pueden venir de dio, como por ejemplo credenciales incorrectas.

``` dart
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {'email': email, 'password': password});
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioExceptionType.connectionTimeout) throw ConnectionTimeot();
      throw CustomError('Something wrong happened', 500);
    } catch (e) {
      throw CustomError('Something wrong happened', 501);
    }
  }
```

2. Implementación de errores en auth_provider.dart

``` dart
  Future<void> loginUser(String email, String password) async {
    // Se coloca un delay intencional
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentials catch (e) {
      logout('Credenciales no son correctas');
    } on ConnectionTimeout {
      logout('Timeout');
    } catch (e) {
      logout('Error no controlador');
    }
  }
```

## 9. Mostrar el error en pantalla
- La función de logout tiene el mensaje de error.
1. Escuchar estado en login_screen.dart
2. Usar snackBar para mostrar error.

``` dart
  void showSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormNotifier);

    // El listener ya se elimina, lo cual se gestiona por ConsumerWidget
    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

```

### Uso de custom error.
- Puede ser útil si se desea guardar la data en un logger.
  - Por otro lado, permite atrapar las respuestas de error directamente desde el backend.
1. auth_datasource_impl.dart

``` dart
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {'email': email, 'password': password});
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw CustomError(e.response?.data['message'] ?? 'Credenciales no válidas');
      if (e.type == DioExceptionType.connectionTimeout) throw CustomError('Revisar conexión a internet');
      throw CustomError('Something wrong happened');
    } catch (e) {
      throw CustomError('Something wrong happened');
    }
  }

```

2. auth_provider.dart

``` dart
  Future<void> loginUser(String email, String password) async {
    // Se coloca un delay intencional
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlador');
    }
  }
```

# Sección 26. Go Router - Protección de rutas
## Temas
1. Proteger rutas
2. Redireccionar
3. Actualizar instancia del GoRouter cuando hay cambios en el estado
4. Colocar listeners de GoRouter
5. Change notifier
6. Preferencias de usuario
7. Almacenar token de acceso de forma permanente

## Corregir overflow en register_scree.dart
- Esta ventana debe hacerse manual.
- Se puede usar const Spacer.
https://www.udemy.com/course/flutter-cero-a-experto/learn/lecture/36954462#questions

## Preferencias de usuario - Shared Preferences
- Se le denomina servicio ya que no ocupa un datasource, de lo contrario sería un repositorio.
    - Por otro lado también se va a inyectar en otro lugar (auth_provider.dart)
1. Instalar shared_preferences
  - https://pub.dev/packages/shared_preferences
  - Permite grabar en el dispositivo. También se puede usar isar, pero shared_preferences es muy usado para esto.
2. Aplicar patrón adaptador a shared_preferences.
  - Se le puede dedicar una sección para domain, infrastructure, etc. Sin embargo, no va a requerir tanta mecánica, solo 3 métodos.
  1. features -> shared -> infrastructure -> services -> key_value_storage_service.dart (clase abstracta)

    - Se coloca en shared ya que se desea crear un wrapper alrededor de la mecánica de shared_preferences que solo lo use en un solo lugar.
    - Ya que el valor que pueden recibir los valores pueden ser varios se decide usar genéricos.
      - Se recuerda que con esto Dart maneja el dato según el tipo de dato que le llegue.



  2. features -> shared -> infrastructure -> services -> key_value_storage_service_impl.dart (implementación de clase abstracta)
    - Definir instancia de sharedPreferences para consumir métodos

``` dart
abstract class KeyValueStorageService {
  Future<void> setKeyValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);
  Future<bool> removeKey(String key);
}

```    

``` dart
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case int:
        return prefs.getInt(key) as T?;
      case String:
        return prefs.getString(key) as T?;
      default:
        throw UnimplementedError('GET not implemented for type ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case int:
        prefs.setInt(key, value as int);
        break;
      case String:
        prefs.setString(key, value as String);
        break;
      default:
        throw UnimplementedError('Set not implemented for type ${T.runtimeType}');
    }
  }
}

```

## 2. Guardar token en dispositivo
1. Inyectar impl de keyValueStorageSerivce en auth_provider
``` dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();
  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState());
```

2. Guardar y eliminar token.

``` dart
  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
```

## 3- Revisar el estado de autenticación (método checkAuthStatus)
1. Invocar este método cuando el notifier se crea.

``` dart
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }
```

2. Implementar método checkAuthStatus en el datasource.

``` dart
class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));
  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final reponse = await dio.get('/auth/check-status', options: Options(headers: {'Authorizatiions': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(reponse.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw CustomError(e.response?.data['message'] ?? 'Token no es válido');
      if (e.type == DioExceptionType.connectionTimeout) throw CustomError('Revisar conexión a internet');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
```

3. En authProvider implementar su propio método checkAuthStatus que llama al del datasource por medio del repositorio.

``` dart
  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    // Al llamar a logout ya se establece que el estado es noAuthenticated de AuthStatus.
    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout();
    }
  }
```

## 4. Check Auth Status Screen
1. features\auth\presentation\screens\check_auth_status_screen.dart
2. Colocar pantalla en GoRouter, la cual va a ser la pantalla primera que se muestra '/splash'
    - Quien va a disparar el método de autenticación no es la panalla, sino GoRouter.
3. Mandar logout al presionar botón de cerrar sesión.

``` dart
class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomFilledButton(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
                text: 'Cerrar sesión'),
          ),
```

## 5. Go_Router protección de rutas
1. Se va a envolver al GoRouter con un provider.
    - Se usa Provider ya que no va a cambiar GoRouter.
2. Corregir en main la definición de router usando ahora Provider.

``` dart
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(goRouterProvider),
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

3. Usar redirect en GoRouter
    - Verifica la ruta a la que se desea ir.
    - Se podrían construir las rutas de forma dinámica, pero eso haría que en algún momento la aplicación tenga una pantalla negra.
    - Se aprecia que cuando se hace la navegación no se reemplazan las rutas, simplemente es un stack.
    - Se va a usar refreshListenable, el cual al cambiar vuelve a evaluar el reidrect, lo cual va a ser útil en los estados de la app de autenticado o no
## 6. GoRouterNotifier
1. Se usa ChangeNotifier
    - Es nativo de Flutter, no se debe configurar ni instalar.
    - Es parte del gesto de estado nativo InheritedWidget
2. config\router\app_router_notifier.dart
  - Su función es permitir poder colocar refreshListenable.
  - Este ChangeNotifier siempre va a ser el mismo sin importar el gestor de estado, y tiene como objetivo notificar un cambio en el estado de la autenticación.

``` dart
final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authNotifier);
});


class GoRouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  // En todo mometo de la app se debe estar pendiente de los cambios de authoNofitier, por lo que se le coloca addListener
  GoRouterNotifier(this._authNotifier){
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

```

3. Crear instancia de GoRouterNotifier en refreshListenable en app_router.dart por medio de riverpod.

``` dart
final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla
```

## 7. Navegar dependiendo de la autenticación

``` dart
    redirect: (context, state) {
      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) return null;

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' && isGoingTo == '/register') return null;
        return 'login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == 'splash') return '/';
      }

      return null;
    },
```

## 8. Bloquear botón de login
- Se hace para que la persona no pueda hacer varias peticiones de login en lo que hay un proceso en marcha.
- Esto se hace con isPosting, el cual se colocará así en onFormSubmit en login_form_provder.dart

``` dart
  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    //  Print llama al método toString que se le hizo override.
    await loginUserCallback(state.email.value, state.password.value);
    state = state.copyWith(isPosting: false);
  }
```

- En login_screen se deshabilita el botón.

``` dart
SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Ingresar',
                buttonColor: Colors.black,
                onPressed: loginForm.isPosting ? null : ref.read(loginFormNotifier.notifier).onFormSubmit,
```

# Sección 28. Obtener productos - Datasources y Repositories
## Temas
1. Mejorar el mecanismo de Login (Botón de login automático)
2. Masonry ListView
3. Productos
4. Entidad
5. Datasources
6. Repositorios
7. Riverpod
8. Provider
9. StateNotifierProvider

## 1. onFieldSubmitted
- Es un campo presente en TextFormField.
1. En login_screen.dart se llama al campo con onFormSubmit del form provider.

``` dart
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            errorMessage: loginForm.isFormPosted ? loginForm.password.errorMessage : null,
            onChanged: ref.read(loginFormNotifier.notifier).onPasswordChange,
            onFieldSubmitted: (_) => ref.read(loginFormNotifier.notifier).onFormSubmit(),
          ),
```

## Entidades, datasources y repositorios
1. Crear directorios de domain e infra en products.

## ProductMapper

## Implementación de getProductsByPage
- No es requerido que se envie el bearer token, pero se implementa de igual manera.
1. Definir Dio y accessToken en products_datasource_impl.dart

``` dart
class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ));

```

``` dart
  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];
    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;
  }
```

## 3. Riverpod - Product Repository Provider
1. features\products\presentation\providers\product_repository_provider.dart

``` dart
final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final productsRepository = ProductsRepositoryImpl(
    ProductsDatasourceImpl(
      accessToken: accessToken,
    ),
  );
  return productsRepository;
});

```

## 4. Riverpod - StateNotifierProvider - State
1. features\products\presentation\providers\products_provider.dart

``` dart
class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage = false,
    int? limit = 10,
    int? offset = 0,
    bool? isLoading = false,
    List<Product>? products = const [],
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        products: products ?? this.products,
      );
}

```

## 5. Riverpod - StateNotifierProvider - Notifier
1. features\products\presentation\providers\products_provider.dart

``` dart
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({
    required this.productsRepository,
  }) : super(ProductsState()) {
    loadNextPage();
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsByPage(limit: state.limit, offset: state.offset);

    if (products.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products],
    );
  }
}
```

## 6. Riverpod - StateNotifierProvider - Provider
1. features\products\presentation\providers\products_provider.dart

``` dart
final productsProdiver = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
});
```

- En la clase minuto 3 aprox se menciona caso en donde isLastPage, pero una persona en otra parte del mundo agrega un nuevo producto.
