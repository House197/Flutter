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

## 7. Pantalla de productos
- Instalar paquete de gridview, el cual se utilizó para masonry en cinemapedia. https://pub.dev/packages/flutter_staggered_grid_view
1. lib -> features -> products -> presentation -> screens -> products_screen.dart
2. Implementar scroll controller en view.

``` dart
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // TODO: Implementar infinite scroll
    ref.read(productsProdiver.notifier).loadNextPage();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
```

## 8. Tarjetas de producto
1. lib -> features -> products -> presentation -> widgets -> product_card.dart
- Se recuerda colocar altura predefinida a las imágenes y al placeholder para reservar el espacio, ya que con el infinite scroll se puede disparar varias veces debido a que la carga de nuevas imágenes no agregaría suficiente espacio si es que no se define antes.

## 9. Pantalla de Producto
1. lib -> features -> products -> presentation -> screens -> product_screen.dart
  - En esta pantalla se considera que si se trabaja para la web o se tiene un deep link entonces es conveniente volver a buscar la data, ya que pudo haber cambiado para este momento.
  - Esta pantalla se va a usar tanto como para actualizar como para crear productos.

2. Colocar ruta de screen.

``` dart
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
```

3. La tarjeta de ProductCard en ProductsScreen se envuelve con un GestureDectector para poder navegar a la nueva ruta.
``` dart
          return GestureDetector(
            onTap: (){
              context.push('/product/${product.id}');
            },
            child: ProductCard(product: product));
        }),
```

# Sección 29. Crear y Actualizar Productos
## Temas
Esta sección está dedicada a la creación y mantenimiento de productos. Puntualmente:

1. Formularios
2. Segmentos de botones
3. Selectores
4. Posteos
5. Path
6. Post
7. Retroalimentación de sucesos
8. Manejo de errores
9. Inputs personalizados
10. Y todo lo relacionado al mantenimiento de producto

## 1. Product Provider
- Se podría hacer solo con 2 providers. Pero se prefiere seguir practicando con StateNotifierProvider.
  1. El primero que diga cuando está cargando el producto.
  2. El segundo que mantenga la información del producto.
1. \lib\features\products\presentation\providers\product_provider.dart
  - Se usa autodispose y family para indicar que se espera como argumento el productId, por lo que se tiene que mandar a llamar pasando un argumento (en este caso productId).
    - Al usar family ya no se tiene acceso a notifier directamente, solo hasta el momento de pasar el arguemento.
  - Por esta razón se coloca un tercer tipo en <>, el cual es string.

2. Implementar la carga del producto.
  - En el constructor se ejecuta primero la parte de super antes del contructor propio.

3. Implementar getProductById en products_datasource_impl.dart
  1. Crear features\products\infrastructure\errors\product_errors.dart para gestionar el error de cuando el id dado no es válido para buscar al producto.

### NOTA
- Se tuvo que colocar lo siguiente de enable... en el manifest
  - Flutter\teslo-shop\teslo-app\android\app\src\main\AndroidManifest.xml

``` xml
   <application
        android:label="teslo_shop"
        android:name="${applicationName}"
        android:enableOnBackInvokedCallback="true"
```

``` dart
class ProductNotFound implements Exception {}
```

``` dart
  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
```

4. Mandarlo a llamar en product_screen.

### FIX
- Con el código actual existe un error, ya que se intenta llamar el cambio de estado cuando ya no está el notifier implementado.
  - En ProductScreen Se tiene un ConsumerStatefulWidget, y solo se manda a llamar el productProvider es en el initState del consumerState. Una vez ya no se está ocupando se limpia ya que se está usando autoDispose.
- Entonces, en product_screen el StatefulWidget es la vista que se va a crear en esta pantalla. 
  - El problema actual está en que como solo se está usando este provider en un solo lugar y luego ya no es necesario, automáticamente lo destruye y luego se tiene la info de regreso y ya no existe ningún notifier.

- Se borra todo el código y se rehace.
  - En resumen, el problema era que solo se tenía la referencia a ese productProvider, y solo se tenía en ese método, cuando el método ya no se ocupaba más se hacía la limpieza automática.

``` dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_provider.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Center(child: Text(productState.product?.title ?? 'Cargando')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save_as_outlined),
      ),
    );
  }
}

```

- La ventaja que se aprecia de Riverpod acá es que guarda en memoria el productProvider, en donde se va a tener en memoria cuyo 'id' sea el mismo.
  - Entonces, siempre y cuando el 'id' sea el mismo, se puede usar esta misma sintaxis y va a usar la misma referencia a lo largo de la app.

## 2. Loader
1. Flutter\teslo-shop\teslo-app\lib\features\shared\widgets\full_screen_loader.dart

``` dart
class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

```

2. Colocalro en product_screen.dart
3. Crear formulario, el cual estaba en el material adjunto.
  1. Flutter\teslo-shop\teslo-app\lib\features\shared\widgets\custom_product_field.dart
4. De igual forma se tiene el la view del product, la cual se colocará hasta abajo en product_screen.dart

## 3. Campos adicionales de formulario - formz
- Se requieren hacer validaciones de campos.
- Antes de hacer el gestor de estado se crean los campos requeridos.

1. Flutter\teslo-shop\teslo-app\lib\features\shared\inputs\title.dart
  - Solo se hace la validación que no sea vacío. Se copia y pega el de email y solo se modifica.

2. Repetir el proceso para los demás campos que se tengan que validar:
  - price
  - stock
  - slug

## 4. Implementar createUpdateProduct en products_datasource_impl.dart
``` dart
  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final bool productHasId = productId != null;
      final String method = productHasId ? 'PATCH' : 'POST';
      final String url = productHasId ? '/products/$productId' : '/post';
      productLike.remove('id');

      final response = await dio.request(
        url,
        data: productLike,
        options: Options(method: method),
      );

      final product = ProductMapper.jsonToEntity(response.data);

      return product;
    } catch (e) {
      throw Exception();
    }
  }
```

## 5. Product Form Provider 
- Aunque product_provider.dart tiene data que podría ayudar con la validación no es lo mismo, por lo que se le dedica un provider unicamente al formulario.
  - Por otro lado, el product_provider tiene la finalidad de proveer información a la app.

1. Flutter\teslo-shop\teslo-app\lib\features\products\presentation\providers\forms\product_form_provider.dart

### 1. State
``` dart
class ProductFormState {
  final bool isFormValid;
  final String? id;
  final TitleForm title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const TitleForm.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.sizes = const [],
    this.gender = 'men',
    this.inStock = const Stock.dirty(0),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith(
    bool? isFormValid,
    String? id,
    TitleForm? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  ) =>
      ProductFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        gender: gender ?? this.gender,
        inStock: inStock ?? this.inStock,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}

```

### 2. Notifier
- Se recuerda que se encarga de mantener el estado y sus cambios. También de emitir la data que debe ser procesada por otro ente.

``` dart
class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    required Product product,
    this.onSubmitCallback,
  }) : super(ProductFormState(
          id: product.id,
          title: TitleForm.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price),
          sizes: product.sizes,
          gender: product.gender,
          inStock: Stock.dirty(product.stock),
          description: product.description,
          tags: product.tags.join(','),
          images: product.images,
        ));

  void onTitleChanged(String value) {
    state = state.copyWith(
      title: TitleForm.dirty(value),
      isFormValid: Formz.validate([
        TitleForm.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid: Formz.validate([
        TitleForm.dirty(state.title.value),
        Slug.dirty(value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid: Formz.validate([
        TitleForm.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onStockChanged(int value) {
    state = state.copyWith(
      inStock: Stock.dirty(value),
      isFormValid: Formz.validate([
        TitleForm.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }
}
```

### 3. Provider
- Este provider tendrá tanto autoDispose como family, ya que se va a recibir un producto.

``` dart
final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  final createUpdateCallback = ref.watch(productsRepositoryProvider).createUpdateProduct;
  return ProductFormNotifier(product: product, onSubmitCallback: createUpdateCallback);
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<Product> Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    required Product product,
    this.onSubmitCallback,
  }) : super(ProductFormState(
          id: product.id,
          title: TitleForm.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price),
          sizes: product.sizes,
          gender: product.gender,
          inStock: Stock.dirty(product.stock),
          description: product.description,
          tags: product.tags.join(','),
          images: product.images,
        ));

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    final productLike = {
      'id': state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      // Imágenes es diferente debido a cómo trabaja el backend.
      'images': state.images
          .map(
            (image) => image.replaceAll('${Environment.apiUrl}/files/product/', ''),
          )
          .toList(),
    };

    try {
      await onSubmitCallback!(productLike);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Se había usado en otra app para que los errores aparezcan cuando se ha pasado por todos los inputs. Tabmién se puede usar para revisar isFormSubmitted
  void _touchedEverything() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      TitleForm.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.inStock.value),
    ]));
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
      title: TitleForm.dirty(value),
      isFormValid: Formz.validate([
        TitleForm.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid: Formz.validate([
        TitleForm.dirty(state.title.value),
        Slug.dirty(value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid: Formz.validate([
        TitleForm.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onStockChanged(int value) {
    state = state.copyWith(
      inStock: Stock.dirty(value),
      isFormValid: Formz.validate([
        TitleForm.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onSizeChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final TitleForm title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const TitleForm.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.sizes = const [],
    this.gender = 'men',
    this.inStock = const Stock.dirty(0),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    TitleForm? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        gender: gender ?? this.gender,
        inStock: inStock ?? this.inStock,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
```

## 5. Conectar el provider con el formulario
1. product_screen.dart, convertir _ProductView en ConsumerWidget para poder tener referencia el provider del form.

``` dart
class _ProductView extends ConsumerWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productForm = ref.watch(productFormProvider(product));
```

2. Proveer de la información del producto desde productForm y no directamente desde el Product, ya que el form ya contiene la data del product.
  - Esto es útil para ir viendo las modificaciones que se le vayan haciendo.
3. Hacer referencia tambi+en en _ProductInformation por medio de riverpod.
  - Se recuerda que la Riverpod hace una instancia global de los proveedores, por lo que cada que se hace ref.wath o read en realidad solo se están apuntando a la referencia de esta instancia, por lo que no importa las veces que se vaya haciendo la referencia con ref.watch y read.
4. Usar productForm para llenar data de _ProductInformation y pasar callback a CustomProductField así como errorMessage.
  - Se usa read para pasar la referencia de funciones con Riverpod.
5. Incovar onFormSubmit en botón de guardado.

## 6. Actualizar la pantalla de productos
- Los providers son diferentes para los productos que se ven en el formulario y los que se ven en la pantalla principal.
  - Por esta razón hasta el momento el cambio solo se refleja en el formulario del producto, no en la pantalla principal.
1. Se implementa el método de actualización en products_provider.dart.

``` dart
  Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final product = await productsRepository.createUpdateProduct(productLike);
      final isProductInList = state.products.any((element) => element.id == product.id);
      if (!isProductInList) {
        state = state.copyWith(products: [...state.products, product]);
      }

      state = state.copyWith(products: state.products.map((e) => e.id == product.id ? product : e).toList());

      return true;
    } catch (e) {
      return false;
    }
  }

```

2. Llamar este método en product_form_provider.dart
  - Ahora el callback viene de este provider y no del productsRepositoryProvider.
  - Se hace cambio también en la firma que espera el notifier, ya que ahora el callback regresa un bool y no un product.

``` dart
final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  //final createUpdateCallback = ref.watch(productsRepositoryProvider).createUpdateProduct;
  final createUpdateCallback = ref.watch(productsProdiver.notifier).createOrUpdateProduct;
  return ProductFormNotifier(product: product, onSubmitCallback: createUpdateCallback);
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    required Product product,
```

## 7. Mostrar mensaje de actualización
- Se va a usar snackbar.
- Se recuerda que no se debe usar context en espacios asíncronos, ya que pudo haber cambiado durante ese tiempo de espera.
  - Sin embargo, se puede usar cuando se usa then en el future.
- Se crea un método para el snackbar en product_screen.dart

``` dart
  void showSnackbar( BuildContext context ) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto Actualizado'))
    );
  }
```

- Se utiliza por medio de then del future.

``` dart
       onPressed: () {
          if (productState.product == null) return;
          ref.read(productFormProvider(productState.product!).notifier).onFormSubmit().then((value) {
            if (!value) return;
            showSnackbar(context);
          });
        },
```

## 8. Crear un nuevo producto
- Al navegar a ProductScreen en lugar de mandar el id se manda la palabra new.
1. product_provider.dart, función loadProduct se agrga lógica de si se recibe la palabra new.
2. Se define el método newEmptyProduct()

``` dart
  Product newEmptyProduct() {
    return Product(
      id: 'new',
      title: '',
      price: 0,
      description: '',
      slug: '',
      stock: 0,
      sizes: [],
      gender: 'men',
      tags: [],
      images: [],
    );
  }

  Future<void> loadProduct() async {
    try {

       if(state.id == 'new') {
        state = state.copyWith(
          isLoading: false,
          product: newEmptyProduct(),
        );
        return;
       }
```
3. Navegar a pantalla con el botón de Nuevo Product en products_screen.dart

``` dart
        onPressed: () {
          context.push('/product/new');
        },
```
4. Evaluar en product_form_provider.dart si el id es new entonces enviar null.

``` dart
  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    final productLike = {
      'id': (state.id == 'new') ? null : state.id,
```

## 9. Ocultar teclado cuando ya no se ocupa
- Se envuelve a product_screen en un GestureDetector para poder usar FocusScope.

``` dart
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
```

- Se debe llamar en otros lugares, como en el size selector o gender selector.

# Sección 30. Cámara, Galería y carga de archivos
1. Patrón adaptador sobre el paquete de cámara
2. POST Form Multipart
3. Mostrar imágenes como archivos
4. Multiples cargas simultáneas
5. Postman - Pruebas de API
6. Actualizar estado del formulario
7. Otras validaciones

## 2. PubDev - Cámara y Galería 
1. Descargar paquete https://pub.dev/packages/image_picker.
  - Este paquete permite trabajar con la cámara y con la galería.
  - Para Android no se requieren configuraciones adicionales, pero para iOS en la documentación se especifica qué se debe agregar.

```
<dict>

	<key>NSPhotoLibraryUsageDescription</key>
	<string>Se requiere acceso a la galería para seleccionar los productos</string>
	<key>NSCameraUsageDescription</key>
	<string>Se requiereuiere acceso a la cámara para poder tomar foto de los productos</string>
	<key>NSMicrophoneUsageDescription </key>
	<string>Si desea grabar audio se requiere acceder al micrófono.</string>
```

## 3. Patrón adaptador - Servicio
1. Flutter\teslo-shop\teslo-app\lib\features\shared\infrastructure\services\camera_gallery_service.dart
``` dart
abstract class CameraGalleryService {
  Future<String?> takePhoto();
  Future<String?> selectPhoto();
}

```
2. Flutter\teslo-shop\teslo-app\lib\features\shared\infrastructure\services\camera_gallery_service_impl.dart

``` dart
import 'package:image_picker/image_picker.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/camera_gallery_service.dart';

class CameraGallerySeviceImpl extends CameraGalleryService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (photo == null) return null;
    print('Imagen ${photo.path}');
    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (photo == null) return null;
    print('Foto ${photo.path}');
    return photo.path;
  }
}

```

## 4. Probar cámara y galería
- Se llaman en los botones de actions en produc_screen.dart

``` dart
AppBar(
    title: const Text('Editar Producto'),
    actions: [
      IconButton(
        icon: const Icon(Icons.photo_library_outlined),
        onPressed: () async {
          final photoPath = await CameraGallerySeviceImpl().selectPhoto();
          if (photoPath == null) return;
          photoPath;
        },
      ),
      IconButton(
        icon: const Icon(Icons.camera_alt_outlined),
        onPressed: () async {
          final photoPath = await CameraGallerySeviceImpl().takePhoto();
          if (photoPath == null) return;
          photoPath;
        },
      ),
    ],
  ),
```

## 5. Mostrar imágenes desde Paths absolutos
1. Añadir nuevo método en product_form_provider.dart para actualizar imágenes del estado.

``` dart
  void updateProductImage(String path) {
    state = state.copyWith(
      images: [...state.images, path]
    );
  }

```

2. Llamar método en product_screen al momento que se tiene el photoPath en los actions.

``` dart
          actions: [
            IconButton(
              icon: const Icon(Icons.photo_library_outlined),
              onPressed: () async {
                final photoPath = await CameraGallerySeviceImpl().selectPhoto();
                if (photoPath == null) return;
                ref.read(productFormProvider(productState.product!).notifier).updateProductImage(photoPath);
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () async {
                final photoPath = await CameraGallerySeviceImpl().takePhoto();
                if (photoPath == null) return;
                ref.read(productFormProvider(productState.product!).notifier).updateProductImage(photoPath);
              },
            ),
          ],
```

3. Refactorizar _ImageGallery en product_screen.dart, ya que ahora se van a tener imágenes que no son de Network debido al uso de la cámara, la cual guarda el file en el cache.
  - Se va a cambiar el imageProvide para que sea Network o AssetImage dependiendo de si la imagen empieza o no con http.

``` dart
      children: images.map((e) {
        late ImageProvider imageProvider;
        if (e.startsWith('http')) {
          imageProvider = NetworkImage(e);
        } else {
          imageProvider = FileImage(File(e));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: FadeInImage(
                fit: BoxFit.cover,
                image: imageProvider,
                placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
              )),
        );
```