# Sección 12. Full App - Cinemapedia
## Temas
1. Datasources.
    1. Implementaciones.
    2. Abstracciones.
2. Repositorios.
    1. Implementaciones.
    2. Abstracciones.
3. Modelos.
4. Entidades.
5. Riverpod.
    1. Provider.
    2. StateNotifierProvider.
    3. Notifiers.
6. Mappers.

## 1. Inicio de la aplicación - Estilo, Router y HomeScreen
1. Abrir paleta de comandos con CTRL + SHIFT + P.
2. Escribir Flutter: New Project.
3. Seleccionar opción Application.

### Estilo y Router
1. config -> theme -> app_theme.dart
    - Colocar instancia de la clase en main.dart.
``` dart
import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;
  final int selectedColor;

  AppTheme({this.isDarkMode = false, this.selectedColor = 0});

  ThemeData getTheme() => ThemeData(
        useMaterial3: false,
        colorSchemeSeed: const Color(0xFF2862F5),
      );
}
```
2. config -> router -> app_router.dart
    - GoRoute ayuda a no tener que hacer configuraciones adicionales si se desea pasar el código en la web y en la integración de Deep Linking.
    1. Se abre línea de comando.
    2. Se escribe y selecciona Pubspec Assist.
    3. Se descarga go router.
    4. En app_router.dart se define la variable final que almacenará las rutas por medio de GoRouter y GoRoute.
    5. Se define initialLocation con '/'.
    6. Se colocan las rutas deseadas en el campo de routes.
    7. Reemplazar a MaterialApp en main.dart con MaterialApp.router.
        1. Agregar campo de routerConfig y configurarlo pasando la variable final creada en app_router.dart.
        2. Eliminar campo de home en MaterialApp si es que se encuentra.

``` dart
final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.name,
    builder: (context, state) => const HomeScreen(),
  ),
]);
```

3. presentation -> screens -> movies -> home_screen.dart
    - Se coloca como vairable estática el nombre que tendrá su ruta.

``` dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Placeholder(),
    );
  }
}
```

4. Crear archivo de barril para exportar los widgets.
    - presentation -> screens -> screens.dart

5. MaterialApp en main.dart debe verse así:
``` dart
import 'package:flutter/material.dart';
import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}

```

## 2. Repositories y Datasources
1. Se crea la carpeta domain.
    - Acá se definen las reglas del juego de la aplicación y el tipo de clase (entidad) que se va a usar a lo largo de la aplicación.

### Entidad
1. domain -> entities -> movie.dart
    - Se copia la clase del material adjunto.
``` dart
class Movie {
  final bool adult;
  final String backdropPath;
  final List<String> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie(
      {required this.adult,
      required this.backdropPath,
      required this.genreIds,
      required this.id,
      required this.originalLanguage,
      required this.originalTitle,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.releaseDate,
      required this.title,
      required this.video,
      required this.voteAverage,
      required this.voteCount});
}
```

### Datasources
1. domain -> datasources -> movies_datasource.dart.
2. Se crea la clase abstracta para definir qué reglas debe cumplir algo para ser considerado un datasource.
    - Se definen los métodos que las clases van a tener para traer a la data.
    - En el método se pasa el parámetro de page, ya que va a ser paginado.
``` dart
import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
}

```
3. Se define cómo lucen los orígenes de datos que pueden traer las películas.

### Repositories
1. domain -> repositories -> movies_repository.dart
    - Luce igual que el datasource.

``` dart
import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});
}

```

## 3. TheMovieDB y variables de entorno
1. Crear cuenta.
2. Iniciar sesión.
3. Ir a Settings.
4. Ir a apartado API.
5. Generar una API Key.

### Variables de entorno.
- Un cambio en las variables de entorno no redibuja a los widgets.

1. Crear archivo .env en root del proyecto.
2. Definir variable de entorno para colocar API Key.
3. Crear archivo .env.template en root del proyecto.
    1. Colocar nombre de las variables de entorno que se deben usar.
4. Ignorar archivo .env en .gitignore.
5. Instalar paquete flutter_dotenv
    1. Abrir paleta de comando CTRL + SHIFT + P
    2. Esc ribir y seleccionar Pubspec Assist.
    3. Instalar flutter_dotenv.
6. Definir asset para .env en pubspec.yaml.
``` yaml
  assets:
    - .env
```
7. Importar paquete de dotenv.dart en main.dart.
8. Hacer función main como asíncrona.
9. Inicializar paquete para cargar archivo .env, lo lea y defina su uso de manera global.
``` dart
Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}
```
10. Crear config -> constants -> environment.dart
    - Se define una clase con atributos estáticos para colocar la extracción de las variables de entorno.
``` dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String theMovieDbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay key';
}
```

### Documentación en README.md
1. Explicar cómo crear archivo .env

## 4. Modelos
### moviedb
- Se entiende que movieDBResponse es una clase en donde se puede crear su instancia por medio de un json.
    - La instancia contendrá varios parámetros que se retornan de la respuesta de la API, en donde en su atributo de response trae las películas.
1. infrastructure -> models -> moviedb -> moviedb_response.dart
2. Copiar json de respuesta de la API para 'movie/now_playing' desde Postman.
3. Pegar respuesta en quicktype.io y nombrar.
4. Copiar código generado, el cual es un ejemplo para hacer el mapeo de la data.
5. Atributo de originalLanguage se coloca como string.
6. Realizar ajustes al código pegado.
    1. La fecha se hace opcional.
    2. Se extrae la clase Result con FN + F2 y se le coloca el nombre de MovieMovieDB.
        1. infrastructure -> models -> moviedb -> movie_moviedb.dart
7. Se eliminan las enumeraciones y se corrigen los errores que puedan aparecer por eso.

## 5. Mappers
- No se desea que la aplicación funcione directamente con el modelo de la respuesta de la API, razón por la cual se creó la entidad.
- Entonces, se debe hacer un mapeo entre la respuesta de la API con la entidad creada.

1. infrastructure -> mappers -> movie_mapper.dart
2. Se define el método estático movieDBToEntity.
    - Retorna el tipo de dato Movie.
    - Recibe como parámetro una variable con tipo de dato MovieMovieDB (Movie From MovieDB).
    - En la paleta de comando usar format document para mejorar la estructura del archivo.
    - En la respuesta de la API se tiene backdrop_path, el cual contiene el endpoint para recuperar la imagen.
        - En la documentación de themoviedb se muestra el link completo para poder traer una imagen.
        - En este ejemplo para posterPath se coloca no-poster en lugar de una imagen para objetivos de ejemplo más adelante.

``` dart
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: moviedb.backdropPath != ''
          ? 'https://image.tmdb.org/t/p/w500/${moviedb.backdropPath}'
          : 'https://www.wnpower.com/blog/wp-content/uploads/sites/3/2023/06/error-404-que-es.png',
      genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: moviedb.posterPath != ''
          ? 'https://image.tmdb.org/t/p/w500/${moviedb.posterPath}'
          : 'no-poster',
      releaseDate: moviedb.releaseDate,
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount);
}
```

## 6. Implementaciones
### Datasource. Implementación para obtención de películas en cines (getNowPlaying)
- Para cada origen de dato que se vaya a tener se debe crear un archivo exclusivo. En este caso solo se va a trabajar con MovieDB, por lo que se crea el archivo moviedb_datasource.dart.
- El método getNowPlaying se encarga de traer los datos de la base de datos, mapear cada map y retornar una lista de Movie.
1. infrastructure -> datasources -> moviedb_datasource.dart.
2. Instalar paquete dio para hacer peticiones HTTP.
    1. Se instala el paquete dio con Pubspec.
    2. Se crea e inicializa variable de dio con la instancia de Dio en el top level de la clase.
    3. Pasar BaseConfiguratrions como argumento a clase de Dio.
        1. Definir baseUrl, el cual es la base del URL para todas las peticiones que se van a hacer.
        2. Definir queryParameters.
            - api_key.
            - language.
3. Crear instancia de MovieDBResponse a partir de JSON.
4. Filtrar resultados y aplicar mapper para retornar lista de Movie.
5. Si las peículas no traen poster entonces se debe ignorar.

``` dart
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDbDatasource extends MovieDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX'
      }));
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/');
    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();
    return movies;
  }
}
```

### MovieRepository
- Por medio del repository se puede cambiar el datasource en cualquier momento.
1. infrastructure -> repositories -> movie_repository_impl.dart.
2. Crear clase que implemente MoviesRepository.
3. Definir atributo de datasource.
    - Es de tipo MoviesDatasource (clase abstracta) y no de tipo MovieDbDatasource (clase que implementa datasource).
    - Esto se ahce porque la clase abstracta define la regla de cómo debe verse un datasource.
4. Implementar método getNowPlaying.

``` dart
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource;

  MovieRepositoryImpl(this.datasource);
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }
}
```


## 7. Instancia del Repositorio - Riverpod
- El objetivo es propocrionar MovieRepositoryImpl de forma global.

### Riverpod
1. Instalar flutter_riverpod
2. Envolver a MyApp en main.dart con ProviderScope, el cual tiene referencia a todos los providers de riverpod.

``` dart
Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MyApp()));
}
```

### Instancia del repositorio
1. presentation -> providers -> movies -> movies_repository_provider.dart
    - Este va a ser un provider que no va a cambiar, por lo que será de tipo lectura.
    - Una vez creado no se necesita cambiar.
    - Entonces, se usan los siguientes providers.
        - Provider.
2. Se crea movieRepositoryProvider por medio de Provider.
    - Va a retornar la instancia de MovieRepositoryImpl, el cual recibe como argumento la implamentación del datasource deseada.
``` dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';

// Repositorio inmutable.
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MovieDbDatasource());
});
```

### MoviesProviders
- En este archivo se van a definir los demás provider.
- Se crea una clase que permita la reutilización y únicamente cambiar el caso de uso, el cual sería la forma en cómo se va a pedir la información.

1. presentation -> providers -> movies -> movies_providers.dart
#### NowPlayingMovies Provider
- Se consulta a este provider para saber cuáles son las películas que están en el cine.
- Se recuerda que StateNotifierProvider es un proveedor de un estado que notifica su cambio.
    - StateNotifier pide el tipo de estado que va a mantener, el cual sería un listado de Movie.
        - Se debe intentar que sea lo más simple posible.
    - Se crea la clase que controla o que sirve para notificar a StateNotifierProvider, y se provee del estado.
- La clase MoviesNotifier va a sevir para:  
    - Saber página actual.
- MoviesNotifier va a ser genérico para que sirva para otros providers.
    - Debe crearse un nuevo estado para notificar a StateNotifier que hubo un cambio.
    - No se tiene a ref en la clase. Podría pasarse desde StateNotifierProvider, pero esto haría que esté ligado a ese proveedor.
    - MoviesNotifier solo necesita saber el "caso de uso" para traer las películas.
        - Se define un typedef para especificar el tipo de función que se espera.
        - Va a ser un Future Function<List<Movie>> que reciebe el page.
            - Así se define el caso de uso. De esta forma, MoviesNotifier va a recibir esa función para cargar las siguiente películas.
        - La función definida typedef se obtiene de MoviesRepositoryImpl.
            - Con Riverpod se obtiene la referencia a la función de movieRepositoryProvider.

``` dart
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  MovieCallback fetchMoreMovies;
  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
  }
}
```
### Notifier

# Buenas prácticas
- Las importaciones importan.
    - Primero deben estar las de dart.
    - Segundo las de Material o paquetes de Flutter.
    - Tercero deben ir los paquetes de terceros.
    - Por último las de dependencias personales.
- Un cambio en las variables de entorno no redibuja a los widgets.
- Hcaer que el estado que gestiona StateNotifier sea lo más simple posible.