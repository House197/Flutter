# Sección 31. Despliegues a Play Store y Apple App Store
## Temas
1. Re-nombrar app fácilmente y automáticamente
2. Splash Screens
3. Ícono de la aplicación
4. Android Developer Console
5. Apple Developer Portal
6. Alphas y Betas - Android
7. TestFlight - Apple
8. AAB - Application Bundle Android
9. IPA - IOS
10. Entre otras generalidades

## 1. Cambiar BundleID - App ID semiautomáticamente
- Se puede hacer de forma manual como se vio en la sección de Push Notifications, pero se tienen librerías que pueden hacer esto ya.
1. Descargar libería change_app_package_name, la cual va en las dependencias de desarrollo. https://pub.dev/packages/change_app_package_name
2. Ejecutar siguiente comando:
    - Ya que ahora el bundle ID va a ser diferente, entonces al momento de correr la app se va a crear una nueva en el dispositivo.
``` bash
dart run change_app_package_name:main com.arturorivera.cinemapedia
``` 

## 2. Cambiar icono de la aplicación
- Así como el cambio del bundle ID esto se puede hacer directo, pero como se menciona en la documentación https://docs.flutter.dev/deployment/android se tiene un paquete para automatizar esto. https://pub.dev/packages/flutter_launcher_icons
1. Instalar dependencia de desarrollo. https://pub.dev/packages/flutter_launcher_icons.
2. Configurar pubspec.yml como se indica en la documentación.
    1. Colocar el path del icon.
    2. Opcional. Colocar path de icono en assets.

``` yml
dev_dependencies:
  build_runner: ^2.4.8
  flutter_lints: ^2.0.0
  flutter_test:
    sdk: flutter
  isar_generator: ^3.1.0+1
  change_app_package_name: ^1.1.0
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/icon-icon2.png"
  min_sdk_android: 21 # android min sdk min:16, default 21
```

3. Ejecutar siguiente comando si es que se creó un archivo independiente y no se hizo en pubpsec.yml

``` bash
flutter pub run flutter_launcher_icons -f <your config file name here>
```

4. Ejecutar siguiente comando si se realizó todo en pubspec.yml. Este comando cambia el icono de la app.

``` bash
flutter pub run flutter_launcher_icons
```

## 3. Splash Screen
- Esto es opcional.
1. Descargar paquete como dependencia normal https://pub.dev/packages/flutter_native_splash.
2. Realizar configuraciones en archivo independiente flutter_native_splash.yaml si se van a tener varias, de lo contrario colocarlas en pupspec.yaml

``` yaml
flutter_native_spash:
  color: "#252829"
```

3. Ejecutar comando:

``` bash 
dart run flutter_native_splash:create
``` 

4. Opcional. Dejar el splash durante un cierto tiempo.
  - Se coloca código en el main para mantener el splash abierto, y se llama su método de remover cuando se crea conveniente, como cuando se tienen todos los valores en el main.

``` dart
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MyApp()));
}
```

``` ts
class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    FlutterNativeSplash.remove();
```

## 4. Verificar que se tenga Java instalada.
- Al tener Android Studio ya se tiene Java instalad. Se puede encontrar su path al correr el siguiente comando y ver el path de Java:

``` bash
flutter doctor -v
```

- El path va a estar cado como:


### Descargar Java
- Si no se tiene Java entonces se instala.
1. Descargar Java. https://www.oracle.com/java/technologies/downloads/#jdk22-windows
2. Agregar al PATH.

``` bash
C:\Program Files\Java\jdk-22\bin
```

## 5. Android - Llaves de Release y Upload
https://www.udemy.com/course/flutter-cero-a-experto/learn/lecture/37078172#overview
https://docs.flutter.dev/deployment/android
1. Se tiene que generar llave, la cual se asegura que en las actualización de la app sea la misma persona quien lo hace.
  1. Ejecutar siguiente comando en la terminal. No hace falta estar en el root del proyecto. El siguiente comando solo es para windows.
  - Al comando se le hizo la modificación para que se creara en el path en donde se está corriendo el comando.

``` bash
keytool -genkey -v -keystore .\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

<img src='Images\31-KryGeneration.png'></img>

2. Cambiar nombre del archivo por el nombre de la app con -test al final: cinemapedia-test.jks

3. Crear archivo key.properties en android.
  - Este archivo no se sube a git.

``` yml
storePassword=123456
keyPassword=123456
keyAlias=upload
storeFile=C:\Users\ECON\cinemapedia-test.jks
```

4. Configure signing in gradle
  - Es especificar que use la llave creada para hacer la generación de la app.
  1. Abrir archivo <project>/android/app/build.gradle
  2. Especificar el applicationId correcto, ya que no se cambió con la dependencia que tenía la tarea de hacerlo.
  3. Pegar lo que se indica en la documentación.

5. Habilitar acceso a internet en AndroidManifest.
  - Flutter\cinemapedia\android\app\src\main\AndroidManifest.xml
``` XML
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
```

- Existen más configuraciones que son opcionales. (R8, etc)

## 6. Android Crear App Bundle
1. Ejecutar comando, Andoird ABB:

``` bash
flutter build appbundle
```

2. Dirigirse al link dado por la documentación https://developer.android.com/studio/publish/upload-bundle
  1. Hacer proceso de enrolamiento en Play Store.