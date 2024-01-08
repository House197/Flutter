# Weather App
Creación de proyecto con el comando en consola:

``` bash
flutter create weater_app
``` 

# General

## Instalar dependencias al clonar repositorio.
Se corre el siguiente comando en la consola de comandos.

``` bash
flutter pub get
```

## Título de app
- En Android se define en el Widget MaterialApp, en la propiedad Title.
- En IOS se ve en el folder **info.plist**, el cual puede verse al presion CMMD + P y escribir el nombre del archivo.

## Theme
- Se ubica en el Widget MaterialApp.
- Se encarga de proveer el esquema de la aplicación.
- Especifica que se usa la versión 3 de useMaterial por medio de la propiedad booleana userMaterial3.
- Provee del color del esquema por medio de colorScheme.
    - La aplicación hace referencia a **inversePrimary** (en bacgroundColor ubicado en AppBar), el cual puede ser definido en el esquema con un color.
- Ayuda a aplicar todo el Theme a las ventanas creadas en la app sin tener que definir una por una.

``` dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple,
        inversePrimary: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

```

- Se usa ThemeData en la propiedad de theme, el cual cuenta con opciones por defecto.
    - Se puede modificar la configuración de las opciones dadas al colocar al final **copyWith**.

## Quitar debug mode
- Se quita en MaterialApp con la propiedad debugShowCheckedModeBanner

# AppBar de WeatherScreen
## Centrar texto
- Se usa la propiedad centerTitle, el cual espera un booleano.

## Colocar icono de refresh
- Se usa el campo de actions.
- En el arreglo de actions se coloca GestureDetector para envolver al icono, el cual se coloca con Icon(Icons.refresh) para colocar el icono deseado.
    - GestureDetector permite colocar alguna función al child por medio de onTap o algunas otras propiedades.
    - Se tiene que especificar el Padding y otros estilos.
- La mejor opción para este escenario es usar IconButton, ya que cuenta con la misma funcionalidad pero trae estilo por defecto.

``` dart
import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ), 
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print('refresh');
            }, 
            icon: const Icon(Icons.refresh)
          ),
        ],
      ),
    );
  }
}
```

# Body de Scaffold para Weather Screen
- Se plantea el layout de la aplicación por medio del Widget Placeholder, el cual acepta la propiedad fallbackHeight si es que no se define algun child.

``` dart
    body: const Column(
    children: [
        Placeholder(
        fallbackHeight: 250,
        ),
        SizedBox(
        height: 20,
        ),
        Placeholder(
        fallbackHeight: 150,
        ),
        SizedBox(
        height: 20,
        ),
        Placeholder(
        fallbackHeight: 150,
        ),
    ],
    ),
```

## Main Card para mostrar temperatura actual y clima
- Se puede usar con Container, pero éste no cuenta con elevation.
- La mejor opción es Card Widget en conjunto con un SizedBox, el cual va a permitir definir el width y height.
    - Se recuerda que para que SizedBox tome todo el Width posible se debe especificar:
    width: double.infinity
- Se usa SizedBox en lugar de Container cuando solo se quiere modificar la altura o el ancho sin querer usar otras propiedades.

### Card
- Acepta las propiedades:
    - elevation.
    - shape. Ayuda a dar el radio a las esquinas con el uso de RoundedRectangleBorder
    - child.

### Backfrop filter
- Ayuda a mejorar la visualización de Elevation.
- Coloca Blur en la dirección de X y Y.
- Se usa la propiedad filter, la cual acepta a la clase abstracta cuyo constructor es privado ImageFilter.
- Se coloca en el child de Card.
- A este Widget se le envuelve con otro llamado ClipRRect para clipearlo con las propiedades que se mencionen, siendo en este caso el borderRadius, el cual debe ser el mismo que se define para la Card.

``` dart
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '149 K',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Rain',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Placeholder(
              fallbackHeight: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            const Placeholder(
              fallbackHeight: 150,
            ),
          ],
        ),
      ),
```

## Weather Forecast
- A modo de colocar el texto en el 'flex-start' se envuelve con el Widget Align.
- De igual manera, se puede definir en la propiedad de crossAxisAlignment en el Padding que envuelve todo el body.

### Carousel de Forecast usando SingleChildScrollView y Row
- Para el dise;o de las carta se usa Container para poder darle un ancho, un radio.
  - Container no cuenta con la propiedad de BorderRadius, pero si con la propiedad de decoration, la cual en este caso debe pasarsele BoxDecoration.
#### SingleChildScrollView
- Por defecto el scroll es el eje vertical.
- Se cambia el flujo del scroll por medio de la propiedad scrollDirection.

``` dart
const SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      HourlyForecastItem(),
      HourlyForecastItem(),
      HourlyForecastItem(),
      HourlyForecastItem(),
      HourlyForecastItem(),
      HourlyForecastItem(),
    ],
  ),
),
```

#### Creacion de plantilla para tarjeta de Additional information

- Para poder personalizar el Widget se pasan los valores deseados al constructor.
  - Se declaran los atributos como final, ya que los widgets son inmutables.
  - Los Widgets que reciben los atributos no pueden declararse como const, ya que ahora son dinamicos.


``` dart
class AdditionalInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoCard(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
```

- Los valores se pasan de la siguiente manera:

``` dart
const Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    AdditionalInfoCard(
      icon: Icons.water_drop,
      label: 'Humidity',
      value: '90',
    ),
    AdditionalInfoCard(
      icon: Icons.air,
      label: 'Wind Speed',
      value: '7.5',
    ),
    AdditionalInfoCard(
      icon: Icons.beach_access,
      label: 'Pressure',
      value: '1000',
    ),
  ],
)
```


#### Creacion de plantilla para tarjeta de Forecast
- Asi como en React, se crea el Widget para poder renderizarlo por medio del mapeo de un arreglo y mostrar el numero de Widgets necesarios. 

``` dart
class HourlyForecastItem extends StatelessWidget {
  const HourlyForecastItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          children: [
            Text(
              '05:00',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.cloud),
            Text('300')
          ],
        ),
      ),
    );
  }
}
```

## Llamadas a API para recuperar data del clima

### Instalación de Flutter HTTP

- Se instala la dependencia de Flutter HTTP.
  - En el archivo de pubspec.yaml se agregan las dependencias necesarias en la sección de dependencies.
  - Se visita la página de la depnedencia para obtener la versión más reciente. (https://pub.dev/packages/http)
  - El archivo pubspec.yaml luce de la siguiente manera.

```yaml
dependencies:
  flutter_test:
    sdk: flutter
  http: ^1.1.0
```

  - Se usa esa versión de http debido a que el SDK del proyecto no es válida para vesiones superiores.
```
  Because weather_app depends on http >=1.1.1 which requires SDK version >=3.2.0 <4.0.0, version solving failed.


  You can try the following suggestion to make the pubspec resolve:
  * Consider downgrading your constraint on http: flutter pub add dev:http:^1.1.0
  exit code 1
```

- Al guardar el archivo visual studio corre el comando para descargar la dependencia.

``` bash
flutter pub get
```

### Uso de dependencia HTTP

- Para poder llamar a la AP loca la logica en un Stateful Widget en weather screen.
- A la clases stateless de Weather_Screen se convierte en Stateful presionando CTRL ALT R.
  - Se decodifica la respuesta JSON por medio de la funcion jsonDecode.
  - No se recomienda utilizar late para inicializar las variables que se alimentaran de la API, ya que late requiere que la variable inicialice antes de la funcion build, lo cual no es el caso ya que el codigo de la llamada de la API sera ejecutado despues de la build function aunque la llamada a la funcion este initState, el cual se ejecuta antes de la funcion build.
- Cuando se inicializa la variable usando por ejemplo double temp = 0 para cuando la API se encargue de actualizar el valor de la variable la funcion BUILD ya se habra ejecutado, pero no se estara volviendo a correr la funcion BUILD. Entonces, se debe usar setState para volver a correr la funcion BUILD una vez que la API ya ha actualizado los valores.

``` dart
class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = 'Mexico';
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=a17d8aca84846ee500b328a8df181e45'),
      );

      final data = await jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  --- Resto del codigo ---
```

- No olvidar que es buena prácticar agregar el tipo de dato que retorna una función de tipo Future.

### Loading Indicator en lo que carga respuesta de la API
- Se usa el Widget CircularProgressIndicator.
- Por medio de un ternario se decide si renderizar el cuerpo de la aplicacion o un indicador de carga.

``` dart
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                print('refresh');
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: temp == 0
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
```

## FutureBuilder Widget

- En lugar de declarar una variable variable que se le asigna el resultado de la llamada de la API se usa FutureBuilder.
- Sus campos son:
  - future
    - Se le pasa una funcion de tipo Future (getCurrentWeather).
  - builder
    - Se soloca una funcion con los argumentos:
      - context
      - snapshot
        - Es una clase que perminta gestionar estados en la aplicacion.
        - Por medio de su atributo connectionState se puede observar si la llamada a la API se encuentra en busqueda o ya tiene los datos solicitados.

- La funcion que llama a la API ya no requiere invocar setState, solo retornar la data.
- Por medio de los métodos de snapshot se renderiza dinámicamente el progress indicator o el cuerpo de la aplicación.
  - Por medio del método hasError se puede también renderizar un Widget para cuando la llamada de la API tuvo algún error.
    - El mensaje de error se define al momento en el que se verifica que data['cod'] sea 200, de lo contrario se usó throw.

``` dart
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
```

- Se usa adaptive en el Progress Indicator para garantizar que se renderice el del sistema operativo correspondiente.
- El código de Future Builder luce así hasta el momento.

``` dart
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot
              .data!; // Se usa ! para indicar a Flutter que esta variable no es null ni va a tener un error hasta este punto del código.

          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final pressure = currentWeatherData['main'] ['pressure'];
          final humidity = currentWeatherData['main']['humidity'];
          final windSpeed = currentWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '$currentSky',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weather Forecast',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HourlyForecastItem(
                          icon: Icons.tornado, hour: '01:00', value: '150'),
                      HourlyForecastItem(
                          icon: Icons.sunny, hour: '02:00', value: '230'),
                      HourlyForecastItem(
                          icon: Icons.cloud, hour: '03:00', value: '250'),
                      HourlyForecastItem(
                          icon: Icons.night_shelter,
                          hour: '04:00',
                          value: '353'),
                      HourlyForecastItem(
                          icon: Icons.water_damage,
                          hour: '05:00',
                          value: '321'),
                      HourlyForecastItem(
                          icon: Icons.water_damage,
                          hour: '06:00',
                          value: '542'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoCard(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$humidity',
                    ),
                    AdditionalInfoCard(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '$windSpeed',
                    ),
                    AdditionalInfoCard(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$pressure',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
```

## Iterar en una lista de objetos para renderizar Widgets 
- Se puede hacer con un For loop.
  - No se deben usar {} en Flutter code.

``` dart
               SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 1; i <= 5; i++)
                        HourlyForecastItem(
                          icon: data["list"][i]['weather'][0]['main'] ==
                                      'Clouds' ||
                                  data["list"][i]['weather'][0]['main'] ==
                                      'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          hour: data["list"][i]["dt"].toString(),
                          value: data["list"][i]['main']['temp'].toString(),
                        ),
                    ],
                  ),
                ),
```

- EL problema con lo anterior es que si se tienen varias iteraciones entonces todos los Widgets estarían presentes, lo que llevaría a un impacto al desempeño de la aplicación. 
- Se recomienda usar ListView.Builder en lugar de SingleChildScrollView.
- Si se desearan retornar varios elementos del For Loop entonces se debe agregar ... y envolver todo en una lista.

``` dart
               SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 1; i <= 5; i++) ... [
                        HourlyForecastItem(
                          icon: data["list"][i]['weather'][0]['main'] ==
                                      'Clouds' ||
                                  data["list"][i]['weather'][0]['main'] ==
                                      'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          hour: data["list"][i]["dt"].toString(),
                          value: data["list"][i]['main']['temp'].toString(),
                        ),
                      ],
                    ],
                  ),
                ),
```

## ListView.Builder
- Permite mostar los elemento a demanda.
- Acepta los campos:
  - itemCount
    - Se especifican cuantos elementos se van a mostrar.
  - itemBuilder.
    - Debe retornar un Widget.
    - Cuenta con los argumentos:
      - context
      - index
- Se debe restringir la altura de este Widget, ya que por defecto trata de ocupar toda la altura.
  - Se limita envolviendolo con un SizedBox.

``` dart
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        final hourlyForecast = data["list"][i + 1];
                        final hourlySky = hourlyForecast['weather'][0]['main'];
                        final hourlyTemp =
                            hourlyForecast['main']['temp'].toString();
                        final time = hourlyForecast['dt_txt'].toString();
                        return HourlyForecastItem(
                          icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          hour: time,
                          value: hourlyTemp,
                        );
                      }),
```

## Dar formato a la fecha usando 
- En pub.dev se encuentran las librerías disponibles para Flutter.
- Se usa intl para dar formato a las fechas.
- Se presiona CMD + SHIFT + P para poder seleccionar la opción de agregar una dependencia (Dart: Add Dependency).
  - Se escribe el nombre del paquete.
- A continuación se convierte el valor de fecha dada por la API en tipo DateTime.
  - Luego, se usa DateFormat para darle el formato deseado.

``` dart
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        final hourlyForecast = data["list"][i + 1];
                        final hourlySky = hourlyForecast['weather'][0]['main'];
                        final hourlyTemp =
                            hourlyForecast['main']['temp'].toString();
                        final time = DateTime.parse(hourlyForecast['dt_txt']);
                        return HourlyForecastItem(
                          icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          hour: DateFormat.Hm().format(time),
                          value: hourlyTemp,
                        );
                      }),
                ),
```

## Refrescar llamada a la API.
- Se recomienda guardar el valor de la función que llama a la API en una variable.
  - Luego, el botón de refresh va a llamar a setState, en donde se colocará la reasignación de la variable con la función que llama a la API.

``` dart
class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = 'Puebla';
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&units=metric&appid=a17d8aca84846ee500b328a8df181e45'),
      );

      final data = await jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
```

# Teoría

- El lema de FLutter es:  
  - Constraints go down
  - Sized go up

- Flutter no traduce los Widgets a componentes nativos del sistema operaitov, sino que pinta algo en el canvas usando su propio sistema de renderizado.
  - El sistema de renderizado que utiliza se llama Kia Graphics Engine, el cual está siendo reemplazado por Impeller.

## Widget Tree
- Representa la estructura de la UI por medio de la composición de múltiples Widgets.
- Flutter se encarga del renderizado, por lo que el Widget Tree es el método para los desarrolladores para organizar la estrucura de la UI.

## Widget
- Es una configuración.
- Es un objeto ligero con propiedades finales.
  - Sus propiedades son finales porque un Widget es inmutable.

## Render Object Tree
- Hay tres tipos:
  - LeafRenderObjectWidget
    - Se usa para Widgets que no tienen hijo o hijos.
    - Ejemplo: Error Widget.
  - SingleChildRenderObjectWidget
    - Se usa para Widgets que solo tienen un hijo.
    - Ejempo: ColoredBox
  - MultiChildRenderObjectWidget
    - Se usa para Widgets que tienen múltiples hijos.
- Lo que realmente se renderiza en la pantalla es un Render Object.
  - Lo hace por medio de invocar métodos como:
    - Render Object.
    - Update Render Object.
- Determina el tamaño, posición y representación visual de los Widgets.
- Se encarga de tareas como: layout calculation, painting pixel en la pantalla.

## Element Tree
- Es el árbol que se encuentra entre el Widget Tree y Render Object Tree.
- Es el reflejo de Widget Tree y es responsable de la gestión del ciclo de vida de Widgets y el estado mutable. 
- Entonces, durante el mount de la aplicación los Widgets se crean, los cuales a su vez crean a un elemento correspondiente.
  - Un Widget llama a la función createElement.
    - Un StatelessWidget crea un stateless element.
    - Un StatefulWidget crea un stateful element.
- Se encarga de ejecutar el proceso de Reconciliation o Diffing.

## BuildContext
- Es una clase abstracta.
- Es un Element.
- Permite localizar un Widget en particular en el árbol de Widgets.
- Se tiene acceso a Element por medio de BuildContext.

## Conclusión
- El árbol de Widgets se itera para encontrar cada Widget y luego un render object particular de Widget se crea.

15:04