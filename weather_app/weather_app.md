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
dev_dependencies:
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

14:41