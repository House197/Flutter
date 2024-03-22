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

## Token del dispositivo y determinar permiso actual
- Cuando la app se lanza por primera vez se va a tener notDetermined la autorización.
1. Se crea método notifications_bloc llamado _initialStatusCheck.
  - Se invoca después de que se crean los listeners de eventos.
  - Toma la instancia de messaging para obtener los settings de notificación y ver el status.
``` dart
  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);

    _initialStatusCheck();
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus)); // Síncrono
  }
```
2. Obtener el token cuando se tiene permiso autorizado.
  - Se crea el método _getFCMToken y se invoca en _initialStatusCheck, en donde el cambio de estado es síncrono, por lo que se puede invocar al final del código sin problema.
  - Por otro lado, se prefiere invocar este método cuando el status cambia.

``` dart
  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void _getFCMToken() async {
    //final settings = await messaging.getNotificationSettings();
    //if(settings.authorizationStatus != AuthorizationStatus.authorized) return;
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();
    print(token);
  }
```

## Escuchar mensajes Push
- Con el token se tiene el identificador único del dispositivo para recibir pushes.
- Con la versión de Flutter mayo a 1.12 ya no se debe hacer la parte de Android Integration, por lo que se prosigue a la sección de Cloaud Messaging -> Usage de la documentación de Firebase. https://firebase.flutter.dev/docs/messaging/usage
- En la docuementación se mencionan tres estados:
  - Foreground. El usuario tiene la app abierta y usando.
  - Backround. El usuario tiene l aplicación abierta pero en el fondo (minimizada).
  - Terminated. El dispositivo está bloqueado o la aplicación on está corriendo.

### Foreground messages
- Se crea método en notificactions_bloc _handleRemoteMessage.
  - Esto es un listener que se debe escuchar, lo cual se hace con otro método llamado _onForegroundMessage.
- _onForegroundMessage va a ser un Stream, por lo que solo se debe inicializar una vez.
  - No se va a limpiar el listener ya que siempre se quiere escuchar mientras la app esté corriendo.
  - Se inicializa una única vez por medio de llamarlo cuando se inicializa la app.

``` dart
  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);

    _initialStatusCheck();
    _onForegroundMessage();
  }


 void _handleRemoteMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification == null) return;

    print('Message also contained a notification: ${message.notification}');
  }

  void _onForegroundMessage(){
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }
```

### Recibbir primera notificación Push
1. Se va al proyecto creado en Firebase.
2. Ir a sección de Participación en el menú de nevagación izquierdo.
3. Selecciona Messaging.
4. Hcaer click en crear primera campaña.
5. Escoger opción Mensaes de Firebase Notifications.
6. Llenar campos de formulario.
  - La imagen debe ser menor a 300KB
7. Abrir sección de Orientación para hacer mensajes de prueba.
  - Se escoge la app deseada en el dropdown que aparece.
8. Sección de Programación, seleccionar que se desea ahora la notificación.
9. Sección Opciones adicionales.
  - Canal de Android ya está establecido en Firebase.
  - En las claves es usual colocar con notifications push uno de tipo type con un valor de chat.
    - De igual manera se tiene un campo de id con un valor específico, tal como el id de un usuario al que se desea mandar la notificación.
10. Guardar como borrador, no seleccionar revisar.
  - Seleccionar mensaje y editar.
  - De vuelta en la primera sección 'Notificación' del formulario se prueba esto con el botón de 'Enviar mensaje de prueba'. Se debe usar el token generado.

## Notificaciones cuando app está terminada
- Al tener la app en background se recomienda ir guardando las notificaciones en bsae de datos para que cuando el usuario vuelva a ingresar se muestren.
1. Buscar sección de Background messages. https://firebase.flutter.dev/docs/messaging/usage
  - There are a few things to keep in mind about your background message handler:
    - It must not be an anonymous function.
    - It must be a top-level function (e.g. not a class method which requires initialization).
    
    - Since the handler runs in its own isolate outside your applications context, it is not possible to update application state or execute any UI impacting logic. You can, however, perform logic such as HTTP requests, perform IO operations (e.g. updating local storage), communicate with other plugins etc.

    - It is also recommended to complete your logic as soon as possible. Running long, intensive tasks impacts device performance and may cause the OS to terminate the process. If tasks run for longer than 30 seconds, the device may automatically kill the process.

2. Colocar implementación en top_level de notifications_bloc.dart
``` dart
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
```

3. Invocar función onBackgroundMessage en main.dart

``` dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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

4. Terminar la aplicación al cerrarla en el dispositivo.
5. Mandar otra notificación, la cual se recibe en las notificaciones del dispositivo.

## Entidad para el manejo de notificaciones
- Sirve como una capa de seguridad para manejar las notificaciones recibidas de la misma manera sin importar si son notificaciones web, android o iOS.
1. domain -> entities -> push_message.dart
  - No se le coloca el nombre de notification, ya que hay modelos de Firebase que pueden tener ese nombre.

``` dart
class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final Map<String, dynamic>? data;
  final String? imageUrl;

  PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    this.data,
    this.imageUrl,
  });

  @override
  String toString() {
    return ''' 
    PushMessage - 
id: $messageId
title: $title
body: $body
sentDate: $sentDate
data: $data
imageUrl: $imageUrl
    ''';
  }
}
```

2. Se coloca esta entidad en notifications_state.dart como el tipo de la lista que retorna el estado.

``` dart
part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final AuthorizationStatus status;

  final List<PushMessage> notifications;

  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined,
    this.notifications = const [],
  });

  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<PushMessage>? notifications,
  }) =>
      NotificationsState(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
      );
  @override
  List<Object> get props => [status, notifications];
}
```

3. Implementar en _handleRemoteMessage en notifications_bloc.dart para convertir remoteMessage en el PushMessage que necesita la app.
  1. Revisar si messageId no es nulo y darle formato, ya que contiene carácteres inválidos como : y %, los cuales pueden rompler el sistema de go_router.

``` dart
  void _handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final notification = PushMessage(
      messageId: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid ? message.notification!.android?.imageUrl : message.notification!.apple?.imageUrl,
    );

    print(notification);
  }

```

## Actualizar estado con la nueva notificación
1. Crear evento NotificactoinReceived en notifications_event.dart con argumento PushMessage.
``` dart
class NotificationReceived extends NotificationsEvent {
  final PushMessage pushMessage;

  NotificationReceived(this.pushMessage);
}
```
2. Disparar evento, el cual debe ser cuando se recibe una nueva notificación y se utiliza para crear una instancia de PushMessage.
``` dart
  void _handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final notification = PushMessage(
      messageId: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid ? message.notification!.android?.imageUrl : message.notification!.apple?.imageUrl,
    );

    add(NotificationReceived(notification));
  }
```
3. Crear listener _onPushMessageReceived en notifications_bloc.dart para reaccionar al evento. En el evento se va a cambiar las notifications del estado.
``` dart
  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(notifications: [event.pushMessage, ...state.notifications]));
  }
```
4. Agregar listener al evento en notifications_bloc.dart
``` dart
  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);

    // Verificar estado de las notificaciones
    _initialStatusCheck();

    // Listener para notificaciones en Foreground
    _onForegroundMessage();
```
4. Probar en home_screen.dart
  1. Esuchar al estado de NotificationBloc.
``` dart
class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationsBloc>().state.notifications;
    return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notifications[index].title),
            subtitle: Text(notification.body),
            leading: notification.imageUrl != null ? Image.network(notification.imageUrl!) : null,
          );
        });
  }
}
```

## Segunda pantalla - Información de la notificación
1. presentation -> screens -> - detail_screen.dart
2. Se va a crear un nuevo método en notifications_bloc.dart para recuperar notificaciones si es que hay.
  - Se coloca acá porque es posible que más adelante se requiera usar el método en otros lugares de la app.
``` dart
  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications.any((element) => element.messageId == pushMessageId);
    if (!exist) return null;

    return state.notifications.firstWhere((element) => element.messageId == pushMessageId);
  }
```
3. Navegación a la pantalla.
  1. Crear ruta en go_router
  2. Colocar onTap en ListTile en home_screen, el cual representa a la notificación por el momento.
``` dart
    GoRoute(
      path: '/push-details/:messageId',
      builder: (context, state) => DetailsScreen(
        pushMessageId: state.pathParameters['messageID'] ?? '',
      ),
    ),
```

## Manejar interacciones con las notificaciones
- Se desea que cuando la app esté en bakground y lleguen las notificaciones en el menú del dipositivo, al hacer click sobre la notificación lleve a la ventana de la notificaicón y no solo abrá la app y muestre el home_screen.dart
- En la documentación oficial -> Cloud Messaging -> Notifications, en la sección de Handling Interaction. https://firebase.flutter.dev/docs/messaging/notifications

1. Crear stateful widget llamado HandleNotificationInteractions el final de main.dart.
  - Recibe un widget y lo retorna.
2. Colocar builder en Material App para retornar instancia de HandleNotificationInteractions, en donde el child viene directamente del builder.
  - El Child dado por el builder básicamente regresa el nuevo MaterialApp.
  - Entonces se está envolviendo a toda la aplicación en HandleNotificationInteractions.
3. Se copia parte del código dado por Firebase y se implementa en el state de HandleNotificationsInteraction. Solo no se copia el override de la función build.
4. Agregar lógica deseada en _handleMessage.
  1. Al seleccionar la notificación lo primero que se va a hacer es almacenarla en el bloc.
    1. En notifications_bloc se hace público el método handleRemoteMessage, ya que se encarga de disparar el evento de NotificationsReceived.
    2. Invocar handleRemoteMessage en _handleMessage de main.dart.
    3. Usar Go_Router para navegar a la ventana de details.
      - Para este momento puede que no esté inicialiado el router, pero se puede usar appRouter, el cual es la instancia de GoRouter.
``` dart
  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);
    final messageId = message.messageId?.replaceAll(':', '').replaceAll('%', '');
    appRouter.push('/push-details/$messageId');
  }
```


# Sección 22. Enviar notificaciones desde una RestAPI
- Se debe vovler a configurar firebase con el token del dispotivo (esto es si se trabaja en dos máquinas diferentes)
## Temas
- Crear un backend rápido para obtener el Bearer token de Firebase, y con eso, poder probar el Restful API de la forma recomendada de Firebase.
- También les explicaré una forma simple, pero ya no es la recomendada.

## Forma recomendad
- Se debe crear un backend.
- Se descarga el servidor de node y se ejecuta.
### Bearer Token
1. Autorizar Request. https://firebase.google.com/docs/cloud-messaging/auth-server
  - Esto ya está en el servidor que se pasó.
2. Ir al proyecto en Firebase.
  1. En Descrición general en el navegador izquierdo se selecciona el engrane para poder seleccionar configuración del proyecto.
  2. Seleccionar opción cuentas de servicio.
  3. Click en el botón generar nueva clase privada.
  4. El archivo JSON descargado se pega en el proyecto de node.
    1. Renombrar por firebase-admin.json
  5. Correr aplicación y acceder al puerto 3000 para obtener bearer token.

### REST
1. Hacer pruebas en Postman.
  1. En la documentación de firebase, en la parte de Via REST se copia solo la primera línea de código después de POST y antes de HTTP. https://firebase.flutter.dev/docs/messaging/notifications#via-rest
  https://fcm.googleapis.com/v1/projects/flutter-projects-2768a/messages:send
  2. Se coloca el nombre del proyecto dado por firebase en la sección correspondiente de la línea copiada.
  3. En Postman se usa el verbo POST.
  4. EN Postman, en Auth y con la poción de Bearer Token se pega el Token sin las comillas.
  5. En body se selecciona RAW y se pega el JSON dado en la documentación en lo restante del código.
    1. Colocar el token del dispositivo en el campo de token.
    2. El último campo del JSON no debe llevar coma al final.
    3. En el campo de data se pueden enviar más valores.
  6. Si se desea enviar imágenes entones se revisa la documentación y se filtra por imageUrl. https://firebase.google.com/docs/cloud-messaging/send-message?hl=es-419#rest

# Notas
## context.read
- Se usa en método porque no se desea redibujar en un onPressed.
## Tokens
- En el Backend se pueden guardar los diferentes tokens que un usuario guarda para poder mandarles notificaciones a los dispositivos que tiene.