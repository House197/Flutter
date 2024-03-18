# Sección 21. Push Notifications + Local Notifications
## Tema
Esta sección está dedicada enteramente al manejo de Push en Android.

1. Tipos de estado de notificaciones
2. Métodos para su manejo
3. Entidades
4. BLoC
5. Leer las notificaciones push
6. Interacciones
7. Navegación a diferentes rutas basados en la PUSH
8. Firebase
9. Configuraciones de FCM
10. Configuración de proyecto de Firebase
11. Tareas y más

## Inicio
1. Crear carpetas por defecto.
    - config
        - theme
            - app_theme.dart
        - config
            - app_router.dart
    - presentation
        - screens
            - home_screen.dart
    - Colocar AppTheme en main.dart y colocar en false debug banner
2. Instalar dependencias.
    1. Equatable.
    2. flutter_bloc
    3. go_router
3. main.dart, quitar home de MaterialAPP y usar constructor con nombre de MaterialApp router.
    - Colocar campor de routerConfig para colocar appRouter de app_router.dart

## BLoC y FlutterFire
- El estado contiene una propiedad igual a un estado que lo va a dar el paquete de firebase_messaging.
1. Instalar firebase_messaging
    - Firebase permite trabajar con notificaciones en simmuladores de Android, no de iOS.
    - Se trabaja con la versión 14.2.16
2. presentation -> bloc
    1. Crear bloc notifications

``` dart
part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final AuthorizationStatus status;
  // TODO: Crear modelo de notificaciones
  final List<dynamic> notifications;

  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined,
    this.notifications = const [],
  });

  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<dynamic>? notifications,
  }) =>
      NotificationsState(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
      );
  @override
  List<Object> get props => [status, notifications];
}

```

3. Corregir errore de notifications_bloc.dart
    1. Corregir importación de bloc a flutter_bloc.
    2. Corregir instancia de estado.
4. Colocar bloc en nivel superior de la app.
    1. Envolver a MyApp en main.dart con MultiBlocProvider.

## Solicitar permisos
1. Mostrar estado actual de los permisos en appBar en home_screen.dart.
    - Actualmente es notDetermined, tal como se colocó en notifications_state.dart
    1. Utilizar context.select para especificar el bloc deseado y extraer el estado de status.

``` dart
title: context.select((NotificationsBloc bloc) => Text('Permisos: ${bloc.state.status}')),
```

2. Definir método requestPermission en notifications_bloc.dart.
    1. Colocar instancia de FirebaseMessaging.
    2. Copiar y pegar código dado en documentación de firebase (Cloud Messaging -> Permissions).
3. Invocar método en onPressed en appBar.
``` dart
            onPressed: () {
              context.read<NotificationsBloc>().requestPermission();
            },
```

### Configuración para uso de firebase_messaging
- Se debe colocar lo que el minSdkVersion sea 19 en C:\Users\Usuario\Documents\Github Desktop\Flutter\Udemy\Flutter\push_app\android\app\build.gradle

``` gradle
    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.example.push_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
        minSdkVersion 19
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
```

## Configurar proyecto de Firebase
1. Tener cuenta en firebase.
2. Crear nuevo proyecto.
    1. Seleccionar botón Get started.
    2. Seleccionar nuevo proyecto.
3. Instalar FirebaseCLI para configuración de firebase (https://firebase.google.com/docs/cli).
    1. Descargar el binario y ejecutar los pasos no sirve. Se debe usar node.
``` bash
npm install -g firebase-tools
```
4. Cambiar id de la aplicación.
    - Firebase va a amarrar bundeId o Package Identifier para configurarlo y permitir únicamente la comunicación de ese app , ese identifier con Firebase.
    - Con este nombre se sube a la play store, por lo que debe ser único.
    - En Android se encuentra en C:\Users\Usuario\Documents\Github Desktop\Flutter\Udemy\Flutter\push_app\android\app\src\main\AndroidManifest.xml
        - El nombre se encuentra en el campo de package.
    1. Cambiar el nombre. <manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.arturorivera.push_app">
    2. Buscar el nombre por defecto (com.example.push_app) presionando CTRL + SHIFT + F.
        - Cambiar bien en donde aparece el nombre, ya que faltaron pocos campos que no se mencionan a continuación, tales como namespace en los archivos que se enlistan.
        1. Colocar nuevo nombre en build.gradle en applicationId.
        2. En MainActivity.kt
            - De igual manera, a la carpeta 'example' que contiene este archivo se le debe colocar el valor que está comprendido entre com. y .push_app
            - Si el nombre de la aplicación se cambió en el strint entonces se debe renombrar a la carpeta que sigue de la anterior nombrada 'example' para que coincida el path.
        3. En C:\Users\Usuario\Documents\Github Desktop\Flutter\Udemy\Flutter\push_app\build\app\generated\source\buildConfig\debug\com\example\push_app\BuildConfig.java
        4. Opcional. Para iOS, a partir del minuto 7. https://www.udemy.com/course/flutter-cero-a-experto/learn/lecture/36754030#learning-tools
5. Instalar firebase_core, en donde se ocupa la versión ^2.7.1
6. Ejecutar comandos dados por firebase:
    1. Se debe tener C:\Users\Usuario\AppData\Local\Pub\Cache\bin en el path de variables de entorno para poder correr el primer comando.
        - Si se corrió el primer comando entonces se debe ahora correr reemplazando activate con deactivate para poder volver a instalar.
    2. Al correr flutterfire configure se selecciona el nombre del proyecto.
    3. Seleccionar android e ios.
    4. Colocar nombre com.<nombre>.<appName>. Lo hace por defecto.
``` bash
# Install the CLI if not already done so
dart pub global activate flutterfire_cli

# Run the `configure` command, select a Firebase project and platforms
flutterfire configure
```

## Inicializar la aplicación de Firebase en Flutter
- Código dado por doc oficial. https://firebase.flutter.dev/docs/overview
``` dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```
1. Colocar WidgetsFlutterBinding.ensureInitialized(); en main.dart. Esto asegura que se tenga acceso a que la aplicación de Flutter y los widgets ys estén correctamente inicializados.

``` dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotificationsBloc()),
      ],
      child: const MyApp(),
    ),
  );
}
```

2. Colocar Firebase.initializeApp en bloc para centralizarlo.
    1. Definir método estático en notifications_bloc.dart
``` dart
  // Firebase Cloud Messaging
  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
```

3. Llamar método initializeFCM en main.dart
``` dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsBloc.initializeFCM();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotificationsBloc()),
      ],
      child: const MyApp(),
    ),
  );
}
```

## Actualizar estado acorde a persmiso
1. Crear evento de bloc.
``` dart
part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  NotificationStatusChanged(this.status);
}
```
2. Crear método en notifications_bloc.dart para llamarlo cuando se dispare el evento.
``` dart

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
  }


  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
  }
```

3. Disparar evento usando add para actualizar ahitorizations permission.

``` dart
  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    add(NotificationStatusChanged(settings.authorizationStatus));
  }
```

# Notas
## context.read
- Se usa en método porque no se desea redibujar en un onPressed.