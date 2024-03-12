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

class MovieDbDatasource extends MoviesDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX'
      }));
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});
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
        - Se debe intentar que sea lo más simple posible (el estado).
    - Se crea la clase que controla o que sirve para notificar a StateNotifierProvider, y se provee del estado (MoviesNotifier).
- La clase MoviesNotifier va a sevir para:  
    - Saber página actual.
- MoviesNotifier va a ser general para que sirva para otros providers.
    - Debe crearse un nuevo estado para notificar a StateNotifier que hubo un cambio en lugar de alterar directamente al estado (así como con React).
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

#### Evitar peticiones simultáenas
1. Crear variable bool isLoading.
2. Retornar si isLoading es true.
3. Si no es verdadera, inicializar a true.
4. Colocar delay antes de que se asigne false a la variable para reducir aún más el tiempo de peticiones.
5. colocar valor en false una vez que el proceso ha terminado.

``` dart
class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;
  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading = false;
  }
}
```


### Archivo de barril
1. presentation -> providers -> providers.dart
``` dart
export 'movies/movies_providers.dart';
export 'movies/movies_repository_provider.dart';
```

#### Resumen
- La principal razón de hacer lo anterior así s separar la aplicación por capas para poder modificar fácilmente a los elementos.
- El provider movies_provider tiene la función de mantener el estado de películas, los cuales pueden ser varios:
  - Estado de películas en el cine.
  - Estado de las que están por venir.
  - Las que están favvoritas.
  - etc.
- Entonces, se crea una clase (MoviesNotifier) general para solo mantener el estado de las películas.
  - Va a tener la función de cargar la siguiente página de películas y mantenerlas en memorial.
- nowPlayingMoviesProvider (StateNotifierProvider)
  - Su objetivo de este Provider es que sea manejado por medio de StateNotifierProvider, y acá se va a saber específicamente esas películas por medio de fetchMoreMovies, el cual se obtiene de la referencia del método getNowPlaying de movieRepositoryProvider.
  - Los demás providers que se van a crear (Upcoming y demás), este mismo objeto con el mismo Notifier, solo va a cambiar el caso de uso para saber las películas que van a traer (el caso de uso se obtuvo con la referencia al método antes mencionado).

## 8. Mostrar películas en pantalla
- Se desea mandar a llamar al ciclo de vida para la carga de la primera página.
1. Extraer widget en body de HomeScreen y nombrarlo como _HomeView.
2. Convertir _HomeView en ConsumerSatefulWidget.
3. Convertir State a ConsumerState.
  - En ConsumerState ya se tiene acceso a ref.
4. Colocar init section.
  - En esta sección se desea mandar a llamar al provider para llegar a loadNextPage.
  - Se usa el método read de ref.
  - Acá solo se manda a llamar a la petición.
5. Recuperar listado de películas con ref.watch en build function.

# Sección 13. Containuación
## Temas
- Esta sección tiene por objetivo realizar 4 consultas a TheMovieDB para obtener:
  - Películas populares
  - Películas en cines
  - Películas mejor calificadas
  - Películas que próximamente estarán en cines
- scroll horizontal infinito, slivers y más.

## Custom AppBar
1. presentation -> widgets -> shared -> custom_appbar.dart
### Spacer
- Widget que toma todo el espacio disponible de un FlexLayout.

### SafeArea
- Se puede evitar que tome espacio de más por medio de top, bottom, left y right, los cuales se les debe asignar false al que se desee.

``` dart
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Icon(Icons.movie_outlined, color: colors.primary),
                const SizedBox(width: 5),
                Text('Cinemapedia', style: titleStyle),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              ],
            ),
          ),
        ));
  }
}
```

## 2. MoviSlideShow - Carrusel de películas
1. Instalar paquete card_swiper.
  - Al instlar paquetes se debe verificar que diga Dart 3 ready.
2. presentation -> widgets -> movies -> movies_slideshow.dart
3. Se define su altura con SizedBox.
### Swiper
- Funciona al igual que cualquier builder.
- Campos especiales:
  1. viewPortFraction: 0.4
    - Permite hacer visible una parte de los elementos contiguos.
  2. scale: 0.6
      - Los elementos se reducen en tamaño a excepción del que está actualmente mostrándose.
      - Presenta animación para colocar al elemento que va a estar mostrandose con una escala de 1.
  3. autoplay: true.
  4. Pagination.
    - Swiper tiene el campo pagination, el cual espera el enum SwiperPagination o una personalización.

``` dart
class MoviesSlideshow extends StatelessWidget {
  final List<Movie> movies;
  const MoviesSlideshow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.8,
        autoplay: true,
        scale: 0.8,
        pagination: SwiperPagination(
            margin: const EdgeInsets.only(top: 0),
            builder: DotSwiperPaginationBuilder(
              activeColor: colors.primary,
              color: colors.secondary,
            )),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _Slide(movie: movie);
        },
      ),
    );
  }
}
```

### _Slider
- Es el Widget que irá retornando Swiper.
1. Colocar Padding con el propósito de que sea completamente visible el BoxShadow.
2. Se define DecoratedBox.
  1. Colocar estilo de decoration en una variable para facilitar mantenimiento.
  2. Se define boxShadow, el cual es una lista.
3. Se usa ClipRRect para tener border redondeado.
4. Se usa Image.network y fint BoxFit.cover para colocar imagen.
  - Usar loadingBuilder para saber si la imagen ya cargó o colocar algo mientras tanto.
5. Instalar paquete animate_to
  - Se usa para tener FadeIn al momento que la imagen se ha cargado.

``` dart
class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ]);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.backdropPath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black12));
              }

              return child;
            },
          ),
        ),
      ),
    );
  }
}
```

## 3. Movies Slideshow Provider
- No se puede usar un método como sublist al momento de pasar el argumento a MoviesSlideShow, ya que en un inicio el arreglo es 0.
  - Se puede hacer una evaluación, sin embargo, por motivos educativos se crea un provider nuevo.
1. presentation -> providers -> movies -> movies_slideshow_provider.dart
2. Se crea un provider inmutable, ya que solo se desean leer las películas.
  - Si después las película cambian entonces quien cambia es nowPlayingMovies, no este provider.

``` dart
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
  if (nowPlayingMovies.isEmpty) return [];
  return nowPlayingMovies.sublist(0, 6);
});

```

## 4. CustomBottomNavigationBar
1. Dirigirse a Scaffold de HomeScreen.
2. Usar bottomNavigationBard.
3. presentation -> widgets -> shared -> custom_bottom_navigationbar.dart
  - Se le coloca elevation 0 para evitar ese estilo.

``` dart
import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.label_outline), label: 'Categorías'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline), label: 'Favoritos'),
      ],
    );
  }
}
```

``` dart
class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
```

## 5. Movie Horizontal ListView
1. presentation -> providers -> movies -> movies_horizontal_listview.dart

### HumanFormats
1. Descargar paquete intl.
2. config -> helpers -> human_formats.dart

``` dart
import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number) {
    final formatterNumber =
        NumberFormat.compactCurrency(decimalDigits: 0, symbol: '', locale: 'en')
            .format(number);
    return formatterNumber;
  }
}

```

## 6. InfiniteScroll Horizontal
- Así como se hizo en la sección de toktik, se llamará a una función que traiga a más películas y se agregaran a la lista de películas actuales.
  - Se coloca un controller en el ListView. (Implica que se debe usar StatefulWidget).
  - El Widget recibe una función de tipo VoidCallback la cual es opcional.
  - En el listener del controlador se verifica que esté definida para poder usarla.
  - Se invoca la función por medio de la posición actual del scroll.
1. Convertir MoviesHorizontalListview a StatefulWidget.
2. Crear e inicializar variable scrollController en la sección de state antes del built method.
3. Asignar controllador a ListView por medio de campo controller.
4. Declarar init.
5. Agregar listener a scrollController en sección de init.
  1. Revisar que loadNextPage no sea null.
  2. Revisar que posición del scroll con un margen de gracia sea mayor o igual a la máxima posición del scroll.
  3. Incovar función loadNextPage.
6. Crear sección de dispose para utiliza método dispose en el controlador.
  - Cada que se hace un listener se debe hacer un dispose.

## 7. CustomScrollView y Slivers (home_screen.dart)
- Slivers son widgets especiales para comportamiento con el scroll, y trabajan en conjunto con CustomScrollView.
- CustomScrollView puede reemplazar a SingleChildScroll para evitar desbordamientos.

### SliverList
- Tiene el campo delegate.
  - Se usa para crear Slivers o los widgets dentro de ListView.
- Se le debe pasar SliverChildBuilderDelegate.
  - Recibe un builder para poder construir los widgets deseados.
  - Se retorna la Columna que se tenía para mostrar todos los Caruseles.
  - El Widget de CustomAppbar ya no pertenecerá a la sección de Column, sino que se colocará en slivers envuelto con SliverAppBar.
- Se tiene el campo countChildren.
  - Se coloca en 1 para que solo renderice una vez la Column.


``` dart
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Column(
              children: [
                MoviesSlideshow(movies: slideShowMovies),

        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
                            MoviesHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'Populares',
                  subTitle: 'Desde siempre',
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                ),
              ],
            );
          },
          childCount: 1,
        ))
      ],
    );
```

## 8. Obtener películas populares, upcoming y top rated
- En la documentación de TheMoviesDB se encuentran los endpoints para recuperar las películas. (movie/popular).
### Domain, Datasource (movies_datasource.dart)
1. Definir signature del método para traer películas populares.
### Domain, Repository (movies_reposity.dart)
1. Definir signature del método para traer películas populares.
### Infrastructure datasources (moviedb_datasource.dart), implementación de método ()
``` dart
class MovieDbDatasource extends MoviesDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-MX'
      }));

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json);
    final List<Movie> movies = movieDbResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();
    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response =
        await dio.get('/movie/popular', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }
}
```
### Infrastructure repositories (moviedb_repository_impl.dart), implementación de método ()
``` dart
class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDatasource datasource;

  MovieRepositoryImpl(this.datasource);
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return datasource.getUpcoming(page: page);
  }
}
```

### Llamar información en provider movies_providers.dart
- Con Riverpod se pueden tener varias instancias de la clase en lugar de solo 1 como el caso de Provider.
- De esta forma, se crea una instancia nueva de MoviesNotifier, en donde la callback ahora se alimenta de la referencia a la función getUpcoming da la implementación del repositorio, la cual está declarada en un provider.
``` dart
final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

```

### Incovar provider en home_screen
- Se debe hacer la lectura de la función loadNextPage para el provider en el init, de lo contrario no mostrará nada.

``` dart
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }
```

- Leer información en el método build para poder pasar la variable a los widgets deseados.

``` dart
 Widget build(BuildContext context) {
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
```

``` dart
                MoviesHorizontalListview(
                  movies: upcomingMovies,
                  title: 'Próximamente',
                  subTitle: 'En este mes',
                  loadNextPage: () {
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                  },
                ),
```

## 9. FullScreen Loader - Diseño
- Su objetivo es mostrar mensajes que vienen de una lista, en donde se irán tomando por medio de un Stream.
  - Se utiliza un streamBuilder.
  - Con los streams no hace falta cerrarlos cuando acaban, ya que lo hace en automático cuando se usa StreamBuilder.
1. presentation -> widgets> shared -> full_screen_loader.dart

``` dart
class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Cargando películas',
      'Comprando películas',
      'Cargando populares',
      'Ya casi',
      'Cargando mejor puntuados',
    ];
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Espere por favor'),
      const SizedBox(height: 10),
      const CircularProgressIndicator(strokeWidth: 2),
      const SizedBox(height: 10),
      StreamBuilder(
          stream: getLoadingMessages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Cargando');
            return Text(snapshot.data!);
          })
    ]));
  }
}
```

## 9. Mútiples providers simultáneamente
- Hasta que todos los providers de películas tengan valor se va a quitar FullScreenLoader.
1. presentation -> providers -> movies -> initial_loading_provider.dart
  - Se va a basar de otros providers.
  - No se va a cambiar manualmente, por lo que va a ser de solo lectura.

``` dart
final initialLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final step2 = ref.watch(upcomingMoviesProvider).isEmpty;
  final step3 = ref.watch(popularMoviesProvider).isEmpty;
  final step4 = ref.watch(topRatedMoviesProvider).isEmpty;

  if (step1 || step2 || step3 || step4) return true;
  return false;
});

```

# Sección 14. Películas individuales y actores
## 1. Movie_screen.dart
1. presentation -> screens -> movies -> movie_screen.dart 
``` dart
class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Cargando películas',
      'Comprando películas',
      'Cargando populares',
      'Ya casi',
      'Cargando mejor puntuados',
    ];
    return Stream.periodic(const Duration(milliseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Espere por favor'),
      const SizedBox(height: 10),
      const CircularProgressIndicator(strokeWidth: 2),
      const SizedBox(height: 10),
      StreamBuilder(
          stream: getLoadingMessages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Cargando');
            return Text(snapshot.data!);
          })
    ]));
  }
}

```
  - Recibe como parámetro el ID de una película en lugar de una Movie.
  - Se hace para poder implementar conceptos como Deep Linking.
    - Por ejemplo, para añadir la funcionalidad de share y que otra persona al hacer click al enlace pueda acceder a esa película y que se carguen los datos. Si se esperara una Movie, no se va a poder tener la Movie desde un enlace externo.
``` dart
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();
```
- Se usa el provider con un if para retornar el widget de carga deseado.

## 2. Navegar a otra pnatalla con parámetros
- Al seleccionar una película se navegará a su página junto con su ID.
- Por medio de la siguiente técnica se puede explandir la aplicación par aplicaciones más allá de celulares.
- Params siempre son strings.
1. Crear una nueva ruta en router usando GoRoute.
2. Extraer param por medio de state dado por builder.

``` dart
final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.name,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
      path: '/movie/:id',
      name: MovieScreen.name,
      builder: (context, state) {
        final movieId = state.pathParameters['id'] ?? 'no-id';
        return MovieScreen(movieId: movieId);
      })
]);

```

2. La imagen de la película se encargará de navegar a la ruta, por lo que en movie_horizontal_listview.dart la imagen se envuelve con un GestureDetector.
``` dart
                    return GestureDetector(
                      onTap: () => context.push('/movie/${movie.id}'),
                      child: child,
                    );
```
- Al probar esto en la web y navegar directamente al link sin haber seleccionado una imagen la flecha para regresar no va a estar disponible.
  - Esto se ajuste con la configuración de GoRouter.
3. Configurar routes de GoRoute, los cuales son rutas hijas de la ruta correspondiente.
``` dart
final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
            path: 'movie/:id',
            name: MovieScreen.name,
            builder: (context, state) {
              final movieId = state.pathParameters['id'] ?? 'no-id';
              return MovieScreen(movieId: movieId);
            })
      ]),
]);
```
- El / de la ruta de movie se quitó ya que ahora el padre lo da.

## 3. Obtener película por ID - Datasource
- Se pensaría en implementar un helper en el GoRoute, sin embargo éste solo debería encargarse de la navegación.
- En TheMovieId la forma de buscar una película por ID es /movie/{movie_id}.
- Se aprecia que la respuesta que entrega la API es diferente a la que se tiene, por lo que se debe crear un nuevo mapa,

1. Agregar nuevo método en domain -> datasources -> movies_datasource.dart
``` dart
abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getPopular({int page = 1});
  Future<List<Movie>> getTopRated({int page = 1});
  Future<Movie> getMovieById(String id);
}
```

- Lo anterior también se coloca en la clase abstracta de repositorio. Se implementa el método en el repositorio al solo llamar al método desde el Datasource.

2. Crear nuevo modelo para ajustar a la respuesta de la API
  - El modelo va a ser específico de moviedb, ya que viene desde TheMovieDB.
  1. infrastructure -> models -> moviedb -> movie_details.dart
    - Se va usar para poder mapear la respuesta, lo cual va a servir para implementar el mapper de esa respuesta al objeto personalizado.
  2. Copiar respuesta de Postman para la API.
  3. Pegar objeto en QuickType, asegurándose que el lenguaje sea dart, null safety y make all properties final.
  4. Copiar respuesta dada de quicktype, colocandole como nombre MovieDetails.
  5. Pegar resultado en movie_details.dart
    - La sección de código que permite generar una instancia por medio de un String es útil cuando se trasbaja con la librería http, pero dio ya lo hace. Son las primeras tres líneas comentadas.
    - Ajustar los campos según las películas.
3. creación de mapper.
  1. Se crea un nuevo método en movie_mapper (movieDetailsToEntity).
``` dart
  static Movie movieDetailsToEntity(MovieDetails moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: moviedb.backdropPath != ''
          ? 'https://image.tmdb.org/t/p/w500/${moviedb.backdropPath}'
          : 'https://www.wnpower.com/blog/wp-content/uploads/sites/3/2023/06/error-404-que-es.png',
      genreIds: moviedb.genres.map((e) => e.name).toList(),
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
```
4. Usar Mapper en implementación de método en Datasource (moviedb_datasource).
``` dart
  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) throw Exception('Movie with id: $id not found');
    final movieDetails = MovieDetails.fromJson(response.data);
    final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);
    return movie;
  }
```

## 4. MovieDetails Caché Local
- Los Widgets no llaman a las implementaciones, los widgets llaman a los providers que llaman a las implementaciones.
- Se para una película ya se había recuperado su data, no se tiene que volver a hacer otra petición HTTP cuando se desee volver a cargar durante el ciclo de vida de la app.
  - Si se desea refrescar la data se puede hacer con un botón para actualizar el caché.

1. presentation -> providers -> movies -> movie_info_provider.dart
  - No se desea colocar algo similar como con el provider de movies_providers.dart.
  - Se crea una clase para mantener en caché las otras películas que se hayan consultado.
  - Se le llama a la clase como MovieMapNotifier, ya que se va a terminar usando un Mapper.
  - Se hace de la función de forma genérica para que pueda recibir cualquier caso de uso, no necesariamente la implementación del repositorio.
  - Ya que se va a esperar una función que específicamente retorna algo, se crea un nuevo typedef.
    - typedef ayuda a colocar la definición del callback.
2. Crear MovieMapNotifier.
``` dart
/*

  {
    '2324': Movie(),
    '3254': Movie(),
  }

*/

typedef GetMovieCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;
  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;

    final movie = await getMovie(movieId);
    state = {...state, movieId: movie};
  }
}

```
3. Crear Provider.
``` dart

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final getMovie = ref.watch(movieRepositoryProvider).getMovieById;
  return MovieMapNotifier(getMovie: getMovie);
});

```

## 5. Realizar la petición HTTP y prueva de caché
1. Crear ConsumerStatefulWidget en movie_screen.dart y ConsumerState.
2. Override init para realizar petición http.
  - Se utiliza ref.read, ya que se usa en mpetodos initState o como callback en onTap, onLongTap, etc.
    - Esto es así porque no se desea que se redibuje.
``` dart
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
  }
```
- Al usar el provider para realizar la petición HTTP evalua si en el state no existe ya la película antes de hacer esa petición.
3. Extraer la película del state en el método Build.
  - Si la película es null entonces se saber que se hace una petición HTTP.

``` dart
  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeAlign: 2,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('MovieID: ${widget.movieId}'),
      ),
    );
  }
}
```

### Diseño de la ventana
1. Envolver cuerpo principal CustomScrollView para trabajar con Slivers.
2. Crear Weidge CustomSliverAppBar.
  - Ocupará el 70% de la pantalla, lo cual se consigue con una MediaQuery y su campo de expandedHeight.
  - Por medio del campo dado por el otro campo flexibleSpacear: FlexibleSpacebar se colocará la imagen.
    - Se le coloca un Stack.
    - Se usa la estrategia de colocar un gradiente.

``` dart
class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        title: Text(
          movie.title,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.start,
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.7, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0, 0.3],
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
```

### Descripción de la película
1. Colocar SliverList en slivers.
2. Crear Widget _MovieDetails.

## 6. Actores de películas
- El provider de movieInforProvider debería encargarse solamente de las películas, por lo que se creará otro provider destinado a los actores.
1. Crear entidad actor.dart
  - domain -> entities -> actor.dart

``` dart
class Actor {
  final int id;
  final String name;
  final String profilePath;
  final String? character;

  Actor({required this.id, required this.name, required this.profilePath, required this.character});
}
```

2. domain -> datasources -> actors_datasource.dart
3. domain -> repositories -> actors_repository.dart
4. Crear Modelo, 
  0. infrastructure -> models -> moviedb -> credits_response.dart. (solo coloca en folder de movieDB ya que el origen de datos sigue siendo   desde TheMovieDB).
  1. Copiar respuesta de la api https://api.themoviedb.org/3/movie/155?api_key={apiKey}&language=es-MX
  2. Pegar modelo en quicktype.io
  3. Nombrar código generado como CreditsResponse.
    - Asegurarse que el lenguaje es dart, null safety y make all properties final.
  4. Hacer moficiaciones en el código. 
    - Usualmente se debe checar las enumeraciones creadas, P/e:
      - Eliminar enumaraciones y variable de departmentValues.
        - Corregir las secciones en donde se usaba el tipo Department, colocando String en su lugar.
5. Mappers
  1. infrastructure -> mappers -> actor_mapper.dart. (usualmente su nombre se inspira del nombre de su entidad).
  2. Crear método estático castToEntity.
    - En su argumento debe recibir un tipo Cast, el cual es el que se interesa de los campos que presenta CreditsResponse.
``` dart
class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
        id: cast.id,
        name: cast.name,
        profilePath: cast.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500/${cast.profilePath}'
            : 'https://www.wnpower.com/blog/wp-content/uploads/sites/3/2023/06/error-404-que-es.png',
        character: cast.character,
      );
}
```

6. Implementación de datasource
  1. infrastructure -> datasources -> actor_moviedb_datasource.dart
  2. Colocar override del método al que se le va a hacer implementación.
  3. Definir objeto Dio con opciones base en el nivel superior de la clase.
  4. Realizar petición http en el método.
  5. Crear instancia de CreditsReponse a partir del resultado de la petición HTTP.
  6. Crear lista de actores a partir del mapero de cada elemento del cast aplicando el mapper de actores.
  7. Retornar resultado.

7. Implementación Repositorio.
  1. infrastructure -> repositories -> actor_repository_impl.dart
``` dart
class ActorRepositoryImpl extends ActorRepository {
  final ActorDatasource datasource;

  ActorRepositoryImpl({required this.datasource});

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId);
  }
}
```

8. Provider
  1. presentation -> providers -> actors -> actors_repository_provider.dart
``` dart
import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repositorio inmutable.
final actorRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl(ActorMovieDbDatasource());
});
```
  2. presentation -> providers -> actors -> actors_by_movie_provider.dart
    1. Sigue la misma lógica que como se hizo con las películas, en donde se van guardando en caché.
``` dart
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>(
        (ref) {
  final getActors = ref.watch(actorRepositoryProvider).getActorsByMovie;
  return ActorsByMovieNotifier(getActors: getActors);
});

/*

  {
    '2324': <Actor>[],
    '3254': <Actor>[],
  }

*/

typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetActorsCallback getActors;

  ActorsByMovieNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;
    final actors = await getActors(movieId);
    state = {...state, movieId: actors};
  }
}
```

9. Prueba de obtención de actores.
  1. En movie_screen se coloca la lectura del provider en init.
``` dart
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorByMovieProvider.notifier).loadActors(widget.movieId);
  }
```

# Sección 15. Search Delegate
## Temas
- SearchDelegate
- Datasources
- Repositorios
- Búsquedas contra TheMovieDB
- Debouncer
- Streams
- Builders
- DRY
- Providers

En esta sección construiremos un motor de búsqueda completo y robusto para que nuestros usuarios puedan buscar sus películas ahí y preservar búsquedas anteriores para mejorar el rendimiento del mismo.

## 1. Datasource y Repository - SearchMovies
1. Para la búsqueda de películas se usará el datasource de MoviesDatasource.
  1. domain -> datasources -> movies_datasource.dart
  2. Se define el signaturesearchMovies, el cual recibe como argumento la query que contiene la película a buscar.
2. Se coloca el mismo signature en la regla de negocio del repositorio.
3. Implementaciones.
  1. Se ocupa el mismo modelo de moviedb_response para la implementación del método en el datasource.
4. Provider.
  - No se va a ocupar otro provider a parte del que ya se tiene para ocupar la implementación del repositario.

## 2. SearchDelegate
1. presentation -> widgets -> shared -> custom_appbar.dart
  - Flutter ofrece la función showSearch, la cual es provista por buildContext.

### ShowSearch, campo delegate
- Es de tipo SearchDelegate, el cual retorna algo de tipo dinámico.
  - Permite retornar una sección de información de la película, tal como su id o toda la información.
- Delegate se va a encargar de trabajar la búsqueda.

## 3. Delegate
1. presentation -> delegates -> search_movie_delegate.dart.
2. Se crea una clae que extiende SarchDelegate.
3. Se hace override de los campos que pide.
  - Se aprecia que al seleccionar el botón que invoca showCase se abre una nueva ventana, la cual muestra los texto definidos en los métodos para ver qué funcionalidad presentan.

``` dart
import 'package:flutter/material.dart';

class SearchMovieDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [const Text('buildActions')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return const Text('buildLeading');
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Text('buildSuggestions');
  }
}
```

4. Se cambia la palabra placeholder con el override del getter searchFiledLabel.

``` dart
                IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: SearchMovieDelegate());
                  },
                  icon: const Icon(Icons.search),
                )
```

### buildLeading
- buildLeading es lo que se usa para salir de una búsqueda (cuando se encuentra lo que se deseabada y ahora se quiere salir.)
  - Se puede usar para lo que se desee.
  - Se tiene el método close dado por la clase SearchDelegate.
    - result es lo que se desea regresar cuando se cierre showSearch.
      - Por esta razón se especifica que la clase SearchDelegate puede retornar una movie.
        - Puede retornar solo una parte de la clase, pero se decide mejor enviar todo el objeto.
      - Se considera en este caso que la persona solo desea salir de la ventana, por lo que no retorna nada.

``` dart
class SearchMovieDelegate extends SearchDelegate<Movie?> {
  @override
  String get searchFieldLabel => 'Buscar peli';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [const Text('buildActions')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
}
```

### Actions
- Se va colocar un botón se sirve para limpiar lo que la perosna escribe.
- El texto de la caja de search se tiene por medio de query, la cual es una palabra reservada de SearchDelegate.
  - Cada que el query cambia se disparan las acciones.

``` dart
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        duration: const Duration(milliseconds: 200),
        child: IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
      )
    ];
  }
```

### Construir sugerencias - Petición HTTP (buildSuggestions)
- Con ayuda de debounde se previene que la petición se dispare cada que se presiona una tecla.
#### Forma básica
- Se debe llamar searchMovies, lo cual ya está implementado en el reposiutorio movie_repository_impl
1. Se define un tipo de función específica para llamar a la función dada por el provider movieRepositoryProvider.

``` dart
typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovies;

  SearchMovieDelegate({
    required this.searchMovies,
  });

  @override
  String get searchFieldLabel => 'Buscar peli';
```

2. En buildSuggestions se va a construir los widgets por medio de un future, por lo que se debe usar FutureBuilder.

``` dart
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: searchMovies(query),
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  title: Text(
                    movie.title,
                  ),
                );
              });
        });
  }
```

3. Se pasa la función como argumento desde custom_appbar.

``` dart
                    final movieRepository = ref.read(movieRepositoryProvider);
                    showSearch(
                      context: context,
                      delegate: SearchMovieDelegate(
                          searchMovies: movieRepository.searchMovie),
                    );
```

### Mostrar películas en la búsqueda
``` dart
 @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: searchMovies(query),
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return _MovieItem(movie: movie);
              });
        });
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  const _MovieItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.2,
            child: Image.network(movie.posterPath),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textStyles.titleMedium,
                ),
                (movie.overview.length > 100)
                    ? Text('${movie.overview.substring(0, 100)}...')
                    : Text(movie.overview),
                Row(
                  children: [
                    Icon(Icons.star_half_rounded,
                        color: Colors.yellow.shade800),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      HumanFormats.number(movie.voteAverage, 1),
                      style: textStyles.bodySmall!
                          .copyWith(color: Colors.yellow.shade900),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

```

## 4. Regresar de la búsqueda con argumentos
- Se tiene el Widget _MovieItem, el cual es externo a SearchDelegate.
  - Entonces, a modo de poder usar close se va a recibir la función deseada (close).
  - En los argumentos de la función que llega como parámetro se pasa context y la película que se desea retornar.

``` dart
                return _MovieItem(
                  movie: movie,
                  onMovieSelected: close,
                );
```

``` dart
class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
```

- En custom_appbar.dart se especifica que el tipo de dato que puede retornar showSearch puede ser una película, la cual es opcional ya que el usuario pudo salir de la sección de búsqueda sin haber buscado algo.

``` dart
             IconButton(
                  onPressed: () {
                    final movieRepository = ref.read(movieRepositoryProvider);
                    showSearch<Movie?>(
                      context: context,
                      delegate: SearchMovieDelegate(searchMovies: movieRepository.searchMovies),
                    ).then((movie) {
                      if (movie == null) return;
                      context.push('/movie/${movie.id}');
                    });
                  },
                  icon: const Icon(Icons.search),
                )
```

## 5. Debounce Manual
- Se va a limitar el número de peticiones que se realizan al momento de buscar sugerencias, ya que cada que se presiona una tecla se realizan peticiones.
- Se plantea reemplazar FutureBuilder en search_movie_delegate por un StreamBuilder, para que cada que el Stream personalizado emita valores ahí es cuando se va a renderizar el contenido. El Stream va a eimitr valores cuando la persona deja de escribir.
- Se crea un nuevo método _onQueryChanged para emitir el resultado de las películas.
``` dart
  void _onQueryChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        debouncedMovies.add([]);
        return;
      }

      final movies = await searchMovies(query);
      debouncedMovies.add(movies);
    });
  }
```
- Cuando se deja de escribir por un determinado tiempo, se puede hacer sin tener que descargar otro paquete por medio de un timer.
  1. Si el timer está activo entonces se limpia.
  2. Crear debounceTimer.
  - La idea es limpiar el timer cada que la persona está escribiendo, y cuando deja de escribir y el timer llega al tiempo establecido entonces realiza la petición.
- Cuando se cierra la ventana de búsqueda se debe limpiar el Stream actual.
  1. Crear función para limpiar Stream.
``` dart
  void clearStreams() {
    debouncedMovies.close();
  }
```
  2. Incovar función antes de close en buildLeading.
``` dart
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
```

- De igual manera, al momento de seleccionar una película para navegar a su descripción se debe limpiar el stream, por lo que a _MovieItem también se le pasa la función de limpieza.

``` dart
_MovieItem(
                    movie: movie,
                    onMovieSelected: (contex, movie) {
                      clearStreams();
                      close(context, movie);
                    });
```

## 6. Search Movies Providers
- Se desea guardar la búsqueda colocada en el input cada que se salga.

- Usar el campo de query de showSearch, en donde su valor se guarda en un provider.
  - Esto hacer que se dispare la petición cada que se vuelve a entrar al search, ya que las películas no se persisten.
- Se mantendrán las películas en un StateProvider.
  
1. presentation -> providers -> search -> search_movies_provider.dart
2. Mantener String en un StateProvider.

``` dart
final searchQueryProvider = StateProvider<String>((ref) => '');
```

3. Usar el valor del provider en query de showSearch en custom_appbar.dart
4. Actaulizar el valor del provider.
  - La función que se usa para buscar las películas lo va a registrar.
  - searchMovies es la función qe se llama con el query de búsqueda.

``` dart
                  onPressed: () {
                    final searchQuery = ref.read(searchQueryProvider);
                    final movieRepository = ref.read(movieRepositoryProvider);
                    showSearch<Movie?>(
                      query: searchQuery,
                      context: context,
                      delegate: SearchMovieDelegate(searchMovies: (query) {
                        ref.read(searchQueryProvider.notifier).update((state) => query);
                        return movieRepository.searchMovies(query);
                      }),
                    )}
```

## 07. Mantener un estado con las películas buscadas
1. Se usa un StateNotifierProvider.
2. El método SearchedMoviesNotifier searchMoviesByQuery se va a encargar de actaulizar también la query para mantener simple la función de searchMovies en custom_appbar.dart.
3. Para poder también actualizar la query entonces la clase debe recibir como argumento el ref.

``` dart
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final searchMovies = ref.read(movieRepositoryProvider).searchMovies;
  return SearchedMoviesNotifier(searchMovies: searchMovies, ref: ref);
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallback searchMovies;
  final Ref ref;
  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }) : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}
```

4. Llamar provider en custom_appbar.

``` dart
               IconButton(
                  onPressed: () {
                    final searchQuery = ref.read(searchQueryProvider);
                    final searchedMovies = ref.read(searchedMoviesProvider);
                    showSearch<Movie?>(
                      query: searchQuery,
                      context: context,
                      delegate: SearchMovieDelegate(
                          initialMovies: searchedMovies, searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery),
                    ).then((movie) {
                      if (movie == null) return;
                      context.push('/movie/${movie.id}');
                    });
                  },
                  icon: const Icon(Icons.search),
                )
```

5. Mostrar películas almacenadas
  - En Search Delegate se define el argumento initial movies

``` dart
class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovies;
  final List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  });
```
6. Colocar initialData en StreamBuilder del delegate en buildSuggestions

``` dart
  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return StreamBuilder(
        //future: searchMovies(query),
        initialData: initialMovies,
        stream: debouncedMovies.stream,
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return _MovieItem(
                    movie: movie,
                    onMovieSelected: (context, movie) {
                      clearStreams();
                      close(context, movie);
                    });
              });
        });
  }
}
```

7. Llamar searchMoviesByQuery en _onQueryChanged de SearchMovieDelegate cuando query es vacía.
  - Desde la implementación del datasource se verifica que la query no se vacía antes de hacer la consulta.
  - Quitar null checker de onQueryChanged para que siempre llegue a la parte en donde se actualiza el provider.

``` dart
  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    final response = await dio.get('/search/movie', queryParameters: {'query': query});
    if (response.statusCode != 200) throw Exception('Movie $query not found');
    return _jsonToMovies(response.data);
  }
```

``` dart
  void _onQueryChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      debouncedMovies.add(movies);
    });
  }
```

## 08. BuildResults
- Es similar al buildSuggestions.
  - Por el momento al presionar enter la buscar películas no arroja nada, solo arroja resultados cuando se deja de escribir.
  - Si se copia y pega lo de buildSuggestions entonces no aparece nada con enter, ya que el StreamBuilder crea un nuevo listener, pero el stream usado no ha emitido ningún valor a comparación con el que se usa en Sugggestions que ya emitió valores.
  - Si se escribre rápidamente y se presiona buscar sí van a aparecer los resultados.
    - Sucede porque cuando se presiona enter el StreamBuilder de buildResults se crea, y el stream debouncedMovies emite el valor.
  - En otras palabras, si se escribe lento y se presiona enter el stream ya emitió sus valores, por lo que no habrá ningún valor al dar enter.

### Solución ideal.
- Lo más fácil sería deshabilitar el enter, pero no es una opción dada por Flutter.
1. Se va a cambiar initialMovies y ya no va a ser final, ya que se desea cambiar después.
2. Inicializar initialMovies en _onQueryChanged asignandole las movies recuperadas.
3. En buildResults, el campo de initialData de buildResults va a ser initialMovies.

## 09. DRY
- Se coloca un método que retorne un Widget, el cual corresponde con el de buildResults y buildSuggestions.

``` dart
  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
        //future: searchMovies(query),
        initialData: initialMovies,
        stream: debouncedMovies.stream,
        builder: (context, snapshot) {
          final movies = snapshot.data ?? [];
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return _MovieItem(
                    movie: movie,
                    onMovieSelected: (context, movie) {
                      clearStreams();
                      close(context, movie);
                    });
              });
        });
  }
```

## 10. Loading de búsqueda de películas
1. Se coloca en buildActions.
2. Por medio de un stream se va a decidir cuál icono mostrar (el de borrado o el de carga).

``` dart
  void _onQueryChanged(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }
```

``` dart
StreamController<bool> isLoadingStream = StreamController.broadcast();
```

``` dart
 @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          initialData: false,
          stream: isLoadingStream.stream,
          builder: (context, snapshot) {
            if (snapshot.data ?? false) {
              return SpinPerfect(
                duration: const Duration(seconds: 20),
                spins: 10,
                infinite: true,
                child: IconButton(
                  onPressed: () => query = '',
                  icon: const Icon(Icons.refresh_rounded),
                ),
              );
            }

            return FadeIn(
              animate: query.isNotEmpty,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                onPressed: () => query = '',
                icon: const Icon(Icons.clear),
              ),
            );
          }),
    ];
  }
```

# Sección 16. ShellRoutes - Go Router - Tabs
- Se va a dividir en dos secciones.
- Sección 1.
  - Recomendación por Go Router.
    - No preserva el estado de la página.
    - Se implementa el Shell Route y se le mandan las vistas.
- Sección 2.
  - Se implementa keep alive.
## Temas
1. Navegación entre trabs.
2. Preservar el estado.
3. Go_Router
  - Redirect
  - ShellRoute
  - SubShellRoutes


## Preparación de vistas
- Ya se tiene la primera (Home View).
- Si se navega a favoritos se va a tener otra página, la cual va a ser parcial. Esa página parcial es conocida como View (va a estar dentro de otro Widget).
  - Una View es un Widget que es similar a un Widget que sea un screen, solo que es parcial.
- Home_Screen es la pantalla que va a tener los tabs.

1. presentation -> views -> home_views -> favorites_view.dart
2. presentation -> views -> home_views -> home_view.dart
  - Se corta de HomeScreen y se pega en home_view.dart
3. Implementación de enrutamiento en HomeScreen.
  - Se define una nueva propiedad a HomeScreen.
    - Es de tipo Widget.
    - Se llama childView y es lo que se va a mostrar.
4. Enviar el childView en app_router.

## ShellRoute - GoRouter
https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
- Se usa el concepto de NestedNavigation
- ShellRoute es lo mismo que GoRoute pero con características especiales.
  - Permite pasar el Widget hijo por medio de builder.

``` dart
  ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(
          childView: child,
        );
      },
      routes: [
        GoRoute(
            path: '/',
            routes: [
              GoRoute(
                  path: 'movie/:id',
                  name: MovieScreen.name,
                  builder: (context, state) {
                    final movieId = state.pathParameters['id'] ?? 'no-id';
                    return MovieScreen(movieId: movieId);
                  })
            ],
            builder: (context, state) {
              return const HomeView();
            }),
        GoRoute(
            path: '/favorites',
            builder: (context, state) {
              return const FavoritesView();
            }),
      ])
```
 
## Bottom Navigation Bar - Navegación
- En custom_bottom_navigationbar.dart se establece un método para que según el índice del navegador se pueda usar context.go y especificar la location.
- Por otro lado, se establece un método para obtener la location actual y poder saber qué index está activo.

``` dart
class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    switch (location) {
      case '/':
        return 0;
      case '/categories':
        return 1;
      case '/favorites':
        return 2;
      default:
        return 0;
    }
  }

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/');
        break;
      case 2:
        context.go('/favorites');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => onItemTapped(context, index),
      elevation: 0,
      currentIndex: getCurrentIndex(context),
      items: const [
```

## Segunda opción para mantener estado (posición de scroll y momentos de carusel)
### Preparar vistas
1. presentation -> views -> movies -> favorites_view.dart
2. presentation -> views -> movies -> home_view.dart

### Configuración del Router
- La ruta ahora será home, y espera el parámetro de page.
- Se define la propiedad int pageIndex en HomeScreen, la cual se le pasará desde go router por medio de params.
- Por medio de IndexedStack se va a preservar el estado de la view.

``` dart
class HomeScreen extends StatelessWidget {
  static const name = 'home_screen';
  final int pageIndex;
  const HomeScreen({super.key, required this.pageIndex});

  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(),
    FavoritesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

```

``` dart
final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = state.pathParameters['page'] ?? '0';
        return HomeScreen(
          pageIndex: int.parse(pageIndex),
        );
      },
```

### Funcionamiento del bottom navigation bar
- Desde HomeScreen se va a enviar el index de la view actual.
- Se usa este parámetro para navegar usando context.go y saber qué opción está seleccionada.

``` dart
class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavigation({super.key, required this.currentIndex});

  void onItemTapped(BuildContext context, int index) {
    context.go('/home/$index');
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (index) => onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.label_outline), label: 'Categorías'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline), label: 'Favoritos'),
      ],
    );
  }
}

```

### Arreglar rutas
- Por el momento ya no se puede navegar a las ventansa de pelíuclas,y de ahí regersar a la de home.
- En GoRouter se usa redirect para la ruta /.
  - Esto se hace para poder regesar a Home.
- La navegación de la movie está en movie_horizontal_listview.dart

``` dart
                    return GestureDetector(
                      onTap: () => context.push('/home/0/movie/${movie.id}'),
                      child: child,
                    );
```

# Sección 17. Local Databases
## Temas
1. Base de datos Isar. (https://isar.dev/es/)
  - Es de tipo NoSQL.
2. Realizar queries
3. Almacenar en base de datos
4. Leer, insertar y borrar
5. FutureProvider de Riverpod
6. Y otras cosas relacionadas a su uso.

## Isar Database
- Entre los usos de una base de datos local es mantener datos sensibles del usuario en el dispositivo, tales como para un hospital.
  - Por otro lado, sirve para mantener transacciones pendientes en caso de que el internet en el dispositivo no esté presente, permitiendo enviar esos datos al backend una vez que hay conexión a internet.

# Buenas prácticas y notas
- Las importaciones importan.
    - Primero deben estar las de dart.
    - Segundo las de Material o paquetes de Flutter.
    - Tercero deben ir los paquetes de terceros.
    - Por último las de dependencias personales.
- Un cambio en las variables de entorno no redibuja a los widgets.
- Hcaer que el estado que gestiona StateNotifier sea lo más simple posible.
- Se recomienda no usar alturas mayores a 210 px.
- Cada que se hace un listener se debe hacer un dispose.
- ref.read se utiliza cuando se están dentro de funciones o callbacks.
- Los Widgets no llaman a las implementaciones, los widgets llaman a los providers que llaman a las implementaciones. Esto se hace así para tenerlo centralizado.
- physics: const ClampingScrollPhysics se evita tener el rebote en los dispositivos iOS.
- Los gradientes se colocan con DecoratedBox.

- No usar BuildContext across async gaps.
  - Esto sucede que ya que el BuildContext pudo haber cambiado en lo que se espera a que se cumpla la promesa. Por lo que no se recomienda usarlo en showSearch ya que es un Future.
  - Se puede recurrir a then, ya que permite tomar el valor del contexto cuando se ejecutan los bloques de código.
- Si se realiza un Stream de la forma StreamController() solo va a poder tener un listener. Se pueden tener varios lugares en donde se escuche al Stream, por lo que se puede usar StreamController.broadcast(). Con Broadcast cada que se redibuje el Widget éste se volverá a suscribir al Stream.
- Las funciones o métodos que retornan algún Widget no pueden ser asíncronos.