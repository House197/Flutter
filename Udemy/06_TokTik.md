# Sección 7. Videos Verticales
## Temas
- Manejo de assets
- Paquetes
- Gesture Detector
- Posicionamiento de Widgets
- Mappers
- Gradientes
- Loops
- Aserciones
- Stacks
- Controladores de video

## Recomendaciones
- Para poder reproducir los videos se debe usar un dispositivo físico, ya que el emulador puede presentar problemas.

## Inicio de la app
1. CTRL + SHIFT + P
2. Flutter: Create project
3. Seleccionar Application.
4. Eliminat boilerplate de main.dart
5. Usar mateapp (Proviene de extensión Awesome Flutter Snippets).
6. debugShowCheckedModeBanner en false en MaterialApp.

## Theme de app
1. Crear config -> theme -> app_theme.dart
2. Crear método que retorna ThemeData.

``` dart
import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      );
}
```

## Estructuras y entidades
- Se crea el modelo de dato cercano a la regla de negocio de la institución.
- Se define la lógica de negocio que se aplicaría a todas las aplicaciones que usen este tipo de VideoPost.
    - En otras palabras, cómo se desea que la data fluya en la aplicación sin importar las fuentes externas.
- La entidad no debe estar relacionada por cómo estén los nombres en una API, ya que la API puede cambiar en el futuro.
    - Por esta razón se ocupan los mappers, para poder definir a las entidades como se desee y luego mapearlas con los datos deseados de la API.
1. Crear estructura de carpetas domain -> entities -> video_post.dart

``` dart
class VideoPost {
  final String caption;
  final String imageUrl;
  final int likes;
  final int views;

  VideoPost({
    required this.caption,
    required this.imageUrl,
    this.likes = 0,
    this.views = 0,
  });
}
```

## Creación de carpeta shared
- Se colocan los elementos que son compartidos en la aplicación.
- En la subcarpeta de dawta se coloca la información de los VideosPost.
    - Esta información puede venir de una API.

1. Crear estructura de carpetas shared -> data -> local_videos_post.dart.
    - En este archivo se define la lista de mapas que se usará para los videos.

## Creación de carpeta de assets.
- Se coloca en el root de la aplicación, no en lib.

1. Creación de carpeta assets -> videos.
2. Colocar path de los assets en pubspec.yaml.

``` yaml
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/videos/
```

## Creación de capa presentation
1. presentation -> screens -> discover -> discover_screen.dart
    - La carepta de discover hace referencia al Home Screen en donde se van descubriendo nuevos videos.
    - Se tiene el subdiretorio discover ya que se pueden tener varias páginas relacionadas a esa característica.

### Provider y problemática futura
1. CTRL + SHIFT + P para abrir paleta de comandos.
2. Instalar provider por medio de Pubspec Assist: Add/Update dependencies.
3. Escribir provider para instalar.
4. Crear presentation -> providers -> discover_provider.dart
5. Crear clase DiscoverProvider que extiende de ChangeNotifier.
    - Contiene la lista de videos.
    - El Provider termina trabajando como un Singleton.
6. Crear variable initialLoading en True.
7. Definir lista video vacía.
8. Crear método loadNextPage para cargar los videos.
    - Se aprecia que si se hace la implementación de la función de cargar los videos en este punto va a amarrar al provider a la dependencia del origen de datos que va a ser local, el cual se encuentra en la capa shared -> data -> local_video_posts.dart.
    - Si en un futuro se decide quitar el origen de datos local entonces se va a tener que ajustar la función loadNextPage para que apunte a un nuevo origen de datos.
    - Se violenta el principio SOLID Open and Close, en donde las clases o funciones deben estar abiertas a la extensión, pero cerradas a la modificación.
        - Se respetaría si la clase aceptara recibir un repositorio que ya sepa cómo cargar esos videos y de dónde cargarlos.
        - Al provider no le debería de importar de dónde se obtienen los videos.
``` dart
import 'package:flutter/material.dart';
import 'package:tok_tik/domain/entities/video_post.dart';

class DiscoverProvider extends ChangeNotifier {
  bool initialLoading = true;
  List<VideoPost> videos = [];

  Future<void> loadNextPage() async {
    notifyListeners();
  }
}
```
9. Envolver MaterialApp en main.dart con MultiProvider.
10. Definir providers en el campo de providers, el cual es ChangeNotifierProvider.
    - Cuando se crea la instancia de DiscoverProvider(), se quiere mandar a llamar inmediatamente loadNextPage, por lo que se usa el operador de cascada ..método.
    - Al usar doble punto se refiere al objeto raíz, siendo en este caso a la instancia de DiscoverProvider.

``` dart
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => DiscoverProvider()..loadNextPage(),
        ),
      ],
      child: MaterialApp(
```
11. Colocar campo de lazy en false para ChangeNotifierProvider (opcional).
    - Por defecto los providers se cargan hasta que se usan, lo cual se cambia por medio de cambiar el campo de lazy a false.
    - Hace que automáticamente cuando se cree la referencia al DiscoverProviuder se lance el constructor.
    - ES CONVENIENTE PARA PROCESOS QUE SE SABEN EL USUARIO VA A LLEGAR A ÉL, PERO TODAVÍA NO.

#### Leer y asignar los videos a provider
- Se usa map, el cual no muta. Es parecido al de JavaScript. 
    - Retorna un iterable.
    - Se convierte a lista con toList.

``` dart
import 'package:flutter/material.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/infrastructure/models/local_video_model.dart';
import 'package:tok_tik/shared/data/local_videos_post.dart';

class DiscoverProvider extends ChangeNotifier {
  bool initialLoading = true;
  List<VideoPost> videos = [];

  Future<void> loadNextPage() async {
    await Future.delayed(const Duration(seconds: 2));

    final List<VideoPost> newVideos = videoPosts
        .map((video) => LocalVideoModel.fromJsonMap(video).toVideoPostEntity())
        .toList();

    videos.addAll(newVideos);
    notifyListeners();
  }
}
```

### Carpeta de Widgets
1. Se define la estructura presentation -> widgets -> shared -> video_scrollable_view.dart.
    - A los widgets que se planeen reutilizar en varias pantallas se les debe colocar en una carpeta shared.

### PageView
- Es similar a un listado.
- Permite hacer scroll a pantalla completa.
- Toma todo el espacio de la pantalla.
- Para que en Android funciones se debe colocar al propiedad physics, usando el valor constante BouncingScrollPhysics.
- Se cambia la dirección con el campo scrollDirection, usando enum Axis.
- Se recomienda el uso de PageView builder para ir renderizar los videos por demanda y no todos a la vez.

### discover_screen.dart
#### CircularProgress y PageView
1. Se crea la estructura principal con Scaffold.
2. Se coloca la variable que trae a DiscoverProvider.
    - Se usa la extensión de método watch que se le da a context.

``` dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final discoverProvider = context.watch<DiscoverProvider>();

    return const Scaffold(
      body: Center(
        child: Text('Hola Mundo'),
      ),
    );
  }
}
```

### Botones de like y views (Stack)
- Permite colocar a los hijos u otros Widgets unos sobre otros.
- Por defecto los widgets apaercen en la posición (0,0)
- Para poder posicionar a los widgets se debe envolver al widget deseado con Positioned.
    - Se usa en conjunto con Stack.

#### Icono girando - animate_do
- Paquete creado por fernando herrera.

1. Se instala con pub assist. Se escribe animate_do
2. Se envuelve el Widget deseado con SpinPerfect
3. Se coloca a la propiedad infinite en true.
4. Ajustar la duración por medio del campo duration.

``` dart
        SpinPerfect(
          infinite: true,
          duration: const Duration(seconds: 5),
          child: const _CustomIconButton(
            value: 0,
            iconData: Icons.play_circle_outlined,
          ),
        ),
```

### Video Player
1. Instalar dependencia video_player.
2. Se lee la información acerca que se tiene de Android para esta librería.
    - Se debe habilitar un permiso para poder usar videos de internet.

```
If you are using network-based videos, ensure that the following permission is present in your Android Manifest file, located in <project root>/android/app/src/main/AndroidManifest.xml:

<uses-permission android:name="android.permission.INTERNET"/>
```

3. Se coloca lo anterior en la segunda línea. Puede ser antes o después de application, pero no dentro.
``` xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <uses-permission android:name="android.permission.INTERNET"/>

    <application
        android:label="tok_tik"
        android:name
```

#### Widget fullscreen_player.dart
1. Se debe darle un tamaño en específico, por lo que se usa SizedBox.expand
    - Con expand se asegura que tome toda la pantalla.

#### Controlador del video - FutureBuilder
- Otorga el control para reproducir, quitar el audio, adelantar o detener el video.

1. En fullscreen_player.dart se define el controlador, en donde el widget debe ser stateful.
2. Se usa initState para inicializar el video.
3. Los videos se van a cargar desde los assets, razón por la cual se usa .asset. En un futuro esto puede cambiar para tomarlos desde internet.
4. Se define dispose para limpiar el controlador cuando el Widget se destruya.
5. Definir el future builder, en donde el future que retorna es el initialize del controlador.
  - FutureBuilder es un builder que trabaja basado en Futures.
  - Por medio del snapshot se sabe el outcome del future.

#### Reproducir videos
- Se usa el Widget de ApspectRatio para evitar que el video no se estire de más.
  - El valor de aspectRatio que se debe pasar ya lo entrega el mismo controlador con controller.value.aspectRatio.
  - Se decide si mostrar indicador de carga o no por medio del valor de snapshot.connectionState != ConnectionState.done.

#### Gradiente de fondo
- Ya que este elemento va a estar posicionado dentro del un Stack se usa Positioned.fill, en donde el fill es similar a SizedBox, pero diseñado para Stack.
  - Va a tomar todo el espacio disponible en el stack.
- Se usa DecoratedBox.
- El Linear gradient por defecto va en horizontal. Se puede cambiar con begin y end.

#### Pausar videos
- Se envuelve AspectRatio con un GestureDetector para poder ejecutar funciones al tocar la pantalla.
- Por medio de controller.value.isPlaying se deicde si usar controller.pause() o contorller.play().

## Mapper - VideoPost - LocalVideo
- Por el momento tanto los modelos como los mappers se colocarán en models, pero más adelante se especifica cuál debe ser la estructura.

1. Se crea la capa de infrastructure -> models -> local_video_model.dart
    - El obejtivo del archivo es ayudar a mapear cómo luce local_video_posts.dart
2. Se crea la clase LocalVideoModel.
3. Se definen los atributos.
    - El nombre de los atributos debe ser el mismo que la estructura de dato que se espera. Es decir, debe tener el mismo nombre que el campo que se recibe del datasource.
    - Esto con la finalidad de poder hacer un match entre las repsuestas de las APIs con la aplicación.
    - Así, si la API cambia en el futuso solo se tineen dos lugares que se deben ajustar al cambio de la API (modelo y mapper).
4. Se define el constructor de la clase.
5. Se define el factory constructor para crear instancias de la clase.
    - Para validar si algún campo es nulo para asignarle un valor se puede usar:
    - Por otro lado, se puede reemplazar la arrow function por una función de cuerpo para poder hacer validaciones.
    - No se recomiendas las aserciones, ya que son más para el modo de desarrollo, y en este punto se están en el modo de ejecución.
``` dart
  factory LocalVideoModel.fromJsonMap(Map<String, dynamic> json) =>
      LocalVideoModel(
        name: json['name'] ?? 'No Value',
        videoUrl: json['videoUrl'],
        likes: json['likes'] ?? 0,
        views: json['views'] ?? 0,
      );
```
6. Crear Mapper para poder mapear de diferentes sources.

``` dart
import 'package:tok_tik/domain/entities/video_post.dart';

class LocalVideoModel {
  final String name;
  final String videoUrl;
  final int likes;
  final int views;

  LocalVideoModel({
    required this.name,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
  });

  factory LocalVideoModel.fromJsonMap(Map<String, dynamic> json) =>
      LocalVideoModel(
        name: json['name'],
        videoUrl: json['videoUrl'],
        likes: json['likes'],
        views: json['views'],
      );

  VideoPost toVideoPostEntity() => VideoPost(
        caption: name,
        videoUrl: videoUrl,
        likes: likes,
        views: views,
      );
}
```

## helpers
### Formateo de números
1. Se crea el archivo huma_formats.dart.
2. Se descarga el paquete intl (paleta de comandos, instalar con Pubspect assist).

``` dart
import 'package:intl/intl.dart';

class HumanFormats {
  static String humanReadableNumber(double number) {
    final formatterNumber =
        NumberFormat.compactCurrency(decimalDigits: 0, symbol: '')
            .format(number);
    return formatterNumber;
  }
}
```

# Sección 8. Conceptos de Clean Architecture - Datasources - Repositories
## Temas
- Repositorios
- Datasources

Pensemos en los datasources como los orígenes de datos de nuestra aplicación, es como en la universidad, donde tenemos diferentes profesores que dan diferentes clases... pero en sí, cada profesor sigue los lineamientos de la universidad para brindarles a ustedes las clases. Cada profesor es un Datasource diferente.

Los repositorios son la forma en la que accedemos a los datasources, pensemos en el repositorio como el aula de clase en si, cada profesor (datasource) entra al aula de clase, y empieza a enseñar matemáticas, filosofía, geografía, etc... luego el profesor (datasource) se va del salón, y entra otro nuevo profesor (otro datasource) pero hace exactamente lo mismo que el profesor anterior pero enseña otro tema.

## Flujo de arquitectura limpia
1. UI.
2. Presentación.
3. Casos de uso. (Reglas de negocio de la institución)
  - Por ejemplo, si se está en una institución financiera, se tiene:
    - Crear un cliente.
    - Mostrar saldos del cliente.
  - Todo debería ser el mismo proceso sin importar en qué aplicación se esté usando.
4. Repertorios y datasources.
5. Información regresa al UI.

## Cración de archivos
- La capa de dominio define las reglas que gobiernan a la aplicación.
1. Crear carpetas domain -> datasources, domain -> repositories

### Datasource
- Se crea la clase abstracta que va a gobernar las implementaciones de los origenes de datos.
- Las clases que implementen VideoPostDatasource van a ser origenes de datos válidos permitidos para los providers o repos puedan obtener esa información.

### Repositories
- Se crea el archivo video_posts_repository.dart
- Es lo mismo que el datasource, solo se cambia el nombre de la clase.
  - La idea es que el repository va a terminar llamando al datasource.
  - La idea es poder hacer el cambio del origen de datos y las clases simplement llamar al repositorio de 'getFavoriteVideosByUser' o algún otro método sin importar el datasource.
  - Al respositorio se le indica de dónde va a tomar los datos.

## Implementaciones
- En la capa de infraestructura se crean los mismos archivos y carpetas de datasources y repositories.
- En esta parte se hacen las implementaciones.

### Datasource
- Se crea local_video_datasource_impl.
- Se implement getTrendingVideosByPage, el cual debe contener la lógica que se puso en el provider de loadNextPage.

``` dart
import 'package:tok_tik/domain/datasources/video_posts_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/infrastructure/models/local_video_model.dart';
import 'package:tok_tik/shared/data/local_videos_post.dart';

class LocalVideoDatasource implements VideoPostDatasource {
  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    await Future.delayed(const Duration(seconds: 2));
    final List<VideoPost> newVideos = videoPosts
        .map((video) => LocalVideoModel.fromJsonMap(video).toVideoPostEntity())
        .toList();
    return newVideos;
  }
}
```

### Repository
- El repositorio es quien llama al datasource.
- Se le debe proveer un origen de datos.

``` dart
import 'package:tok_tik/domain/datasources/video_posts_datasource.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/domain/repositories/video_posts_repository.dart';

class VideoPostsRepository extends VideoPostRepository {
  // Se usa la clase abstracta de VideoPostDatasource, no la implementación.
  // Eso implica que cualquier VideoPostDatasource es permitido.
  final VideoPostDatasource videosDatasource;

  VideoPostsRepository({required this.videosDatasource});

  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) {
    return videosDatasource.getTrendingVideosByPage(page);
  }
}

```

## Llamar repository en Provider.
- En el provider se elimina la lógica de datasource y se le agrega la propiedad de videosRepository.

``` dart
import 'package:flutter/material.dart';
import 'package:tok_tik/domain/entities/video_post.dart';
import 'package:tok_tik/domain/repositories/video_posts_repository.dart';

class DiscoverProvider extends ChangeNotifier {
  final VideoPostRepository videosRepository;
  bool initialLoading = true;
  List<VideoPost> videos = [];

  DiscoverProvider({required this.videosRepository});

  Future<void> loadNextPage() async {
    final newVideos = await videosRepository.getTrendingVideosByPage(1);
    // Se imagina que se tiene una página, pero aún no se implementa eso.
    videos.addAll(newVideos);
    initialLoading = false;
    notifyListeners();
  }
}
```

### Pasar repository al Provider
- Se crea la instancia del repositorio y se le pasa como argumento al provider.
- El repositorio va a usar los videos locales.
  - Si en el futuro cambia el datasource, se modifica lo que se le pasa al repository al inicializar pero debería seguir funcionando igual.

``` dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final videoPostRepository =
        VideoPostsRepositoryImpl(videosDatasource: LocalVideoDatasource());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => DiscoverProvider(videosRepository: videoPostRepository)
            ..loadNextPage(),
```

# Notas
- La forma de colocar un color opcional y definir su valor por defecto en un atributo de un Widget es de la siguiente manera, ya que hacer de la forma como se ha hecho no e sposible debido a que el color es algo se se computa.
``` dart
class _CustomIconButton extends StatelessWidget {
  final int value;
  final IconData iconData;
  final Color? color;

  const _CustomIconButton({
    required this.value,
    required this.iconData,
    iconColor,
  }) : color = iconColor ?? Colors.white;
```
- Los stateless widgets no tienen ciclo de vida, pero los stateful sí.
- Cada que se construye un controlador se debe ir limpiando. Cada que el Widget se destruye se tiene que hacer dispose.
- En el desarrollo, cada que se guardan cambios FutureBuild se vuelve a invocar, por lo que el Widget no se destruye y se van acumulandos los datos. Es conveniente reiniciar la app de vez en cuando.