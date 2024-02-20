# Sección 9
## Temas
1. Navegación entre pantallas.
2. Widgets
    - Botones y variantes.
    - Botones personalizados.
    - Tarjetas.
    - Tarjetas personalizadas.
    - Align.
3. Rutas
    - Propias de Flutter.
    - Go_Router.
    - Paths.
    - Configuración de router.
        1. Propio.
        2. De Terceros.

## Theme y estilo de la app
1. Creación de config -> theme -> app_theme.dart

``` dart
import 'package:flutter/material.dart';

const colorList = <Color>[
  Colors.blue,
  Colors.orange,
  Colors.deepPurple,
  Colors.purple,
  Colors.green,
  Colors.teal,
  Colors.blue,
  Colors.pink,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0 && selectedColor < colorList.length,
            'selectedColor must be positive and less or equal than ${colorList.length}');

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: colorList[selectedColor],
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
```

2. Colocar theme en Material App en main.dart
``` dart
import 'package:flutter/material.dart';
import 'package:widgets_app/config/theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).getTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```

## Opciones de la app (Menu Items)
1. Creación de archivo config -> menu -> menu_items.dart
2. Se usa un constructor constante, ya que una vez que se hace una instancia de MenuItem nunca va a cambiar.

## Home
1. Crear presentation -> screens -> home -> home_screen.dart
2. Se usa ListView.builder para renderizar los MenuItems.
3. Se usa ListTile en lugar de text, ya que provee de campos como title, subtitle, leading, trailing y tap.

## Navegación entre pantallas
1. Se crea presentation -> screens -> buttons -> buttons_screen.dart.
2. Se crea presentation -> screens -> cards -> cards_screen.dart.
3. Se implementa la navegación en el onTap de ListTile en home_screen.dart.
    - Se recuerda que el método push de Navigator coloca ventanas una sobre la otra, y por medio de pop se pueden ir quitando.

### Rutas con nombre (no recomendado)
- No es recomendable trabajar con ellas.
- En Material App se tiene el campo de routes, en donde se define un Map.
    - Las llaves son Strings, las cuales tienen el nombre de la ruta.
    - Los valores son los callbacks, en donde se retorna el Widget deseado a navegar.
- No se pueden pasar argumentos.
- No se pueden pasar params a la ruta.
- Investigar Deep Linking.

### go_router
- Se instala por medio de Pubspect Assist.
1. Colocar configuración de router en config -> router -> app_router.dart
    - Se puede colocar en donde más sentido tenga en la estructura de carpetas.
    
- Se puede definir el campo de initialLocation para indicar la ruta de inicio.
    - Si se omite entonces se toma la primera ruta definida por GoRoute.

2. Crear archivo screens.dart (archivo de barril) en el root de screens.
    - Ya que se pueden tener varias rutas en el proyecto, este archivo se va a encargar de exportar todas las screens.
    - De esta manera, se tienen los archivos separados y a la vez solo se toman de un solo lugar.

``` dart
export 'package:widgets_app/presentation/screens/buttons/buttons_screen.dart';
export 'package:widgets_app/presentation/screens/cards/cards_screen.dart';
export 'package:widgets_app/presentation/screens/home/home_screen.dart';
```

3. Definir rutas y widges a utilizar usando GoRouter en app_router.dart
``` dart
import 'package:go_router/go_router.dart';
import 'package:widgets_app/presentation/screens/screens.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/buttons',
    builder: (context, state) => const ButtonsScreen(),
  ),
  GoRoute(
    path: '/cards',
    builder: (context, state) => const CardsScreen(),
  ),
]);
```
4. Usar MaterialApp.router() en main.dart.

``` dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).getTheme(),
    );
  }
}
```

5. Eliminar campo de home si se tiene y definir campos de routerConfig con el appRouter definiro en app_router.dart.
6. Definir context.go('ruta/deseada') o context.push('ruta/deseada') en la función que se desea lo use.
    - go_router expande las funcionalidades de context.

``` dart
class _CustomListTile extends StatelessWidget {
  final MenuItem menuItem;
  const _CustomListTile({
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(menuItem.icon, color: colors.primary),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: colors.primary,
      ),
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subTitle),
      onTap: () {
        //Navigator.of(context).push(
        //    MaterialPageRoute(builder: (context) => const ButtonsScreen()));
        context.push(menuItem.link);
      },
    );
  }
}
```

#### Versión de rutas por nombre
- Se pueden definir las rutas por medio del nombre.
``` dart
GoRoute(
    name: 'song',
    path: 'songs/:songId',
    builder: /*...*/,
)
```
- Para navegar a la ruta usando el name se usa goNamed.

``` dart
onPressed: () {
    context.goNamed('song', params: {'songId': 123});
}
```

- El name se puede definir en el Widget deseado al crear una variable de tipo estático para no tener que instanciar la clase para poder usarlo.
    - En esta variable se coloca el name.

``` dart
class HomeScreen extends StatelessWidget {
  static const String name = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter + Material 3'),
      ),
      body: const _HomeView(),
    );
  }
}
```

- Se usan estas variables estáticas en el app_router

``` dart
import 'package:go_router/go_router.dart';
import 'package:widgets_app/presentation/screens/screens.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.name,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/buttons',
    name: ButtonsScreen.name,
    builder: (context, state) => const ButtonsScreen(),
  ),
  GoRoute(
    path: '/cards',
    name: CardsScreen.name,
    builder: (context, state) => const CardsScreen(),
  ),
]);
```

- Se define context.pushedName en la función que se desea invoque la navegación.

``` dart
      onTap: () {
        //Navigator.of(context).push(
        //    MaterialPageRoute(builder: (context) => const ButtonsScreen()));

        //context.push(menuItem.link);

        context.pushNamed(CardsScreen.name);
      },
```

## Wrap
- Acepta una lista de Widgets, en donde si la línea ya no es suficiente rompe en una nueva para acomodar a los elementos.
- Tiene el campo spacing para definir el espacio que debe haber entre elementos.
- Al definir el AxisAlignment es con WrapCrossAlignment o alignment: WrapAlignment.center.

## Diferentes botones pre-configurados (buttons_screen)
- Se les da estilo por medio de ButtonStyle.
### FloatingActionButton
- Se define para regresar a la ventana anterior.

``` dart
class ButtonsScreen extends StatelessWidget {
  static const String name = 'buttons_screen';
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons Screens'),
      ),
      body: const _ButtonsView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          context.pop();
        },
      ),
    );
  }
}
```

### ElevatedButton
``` dart
   return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Wrap(
        spacing: 10,
        children: [
          ElevatedButton(onPressed: () {}, child: const Text('Elevated Button')),
          const ElevatedButton(onPressed: null, child: Text('Elevated Disabled'))
        ],
      ),
    );
```
### Elevatedutton con constructor icon
- Es lo mismo con la diferencia de que acepta un icono.
    - El icono puede ser cualquier Widget.
```dart
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.alarm_add_outlined),
              label: const Text('Elevated Icon'),
            )
```

### FilledButton
``` dart
FilledButton(onPressed: (){}, child: const Text('Filled Button'))
```

### FilledButton.icon
- No tiene child, en su lugar tiene icon.

``` dart
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.ac_unit),
              label: const Text('Filled Icon'),
            )
```

### Outlined Button
``` dart
            OutlinedButton(onPressed: (){}, child: const Text('Outlined Button')),
            OutlinedButton.icon(onPressed: (){}, icon: const Icon(Icons.add_box), label: const Text('Outlined Icon'))
```

### TextButton
``` dart
            TextButton(
              onPressed: () {},
              child: const Text('Text Button'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.catching_pokemon),
              label: const Text('Text Button Icon'),
            )
```

### IconButton
``` dart
           IconButton(
              onPressed: () {},
              icon: const Icon(Icons.abc_outlined),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(colors.primary),
                iconColor: const MaterialStatePropertyAll(Colors.white),
              ),
            )
```

## Botón personalizado
- Se envuelve todo el widget deseado con Material.
    - Permite definir incluso el splash screen.

### InkWell
- Es como un GestureDetector, pero reacciona cuando se tiene el método con un splash.

### ClipRRect
- Permite colocar border redondeados.
    - Permite cortar y dejar los bordes redondeados.
- Debe envolver incluso a Material.

## Cards
- Son agrupadores que tinen cierto estilo.
- Se usa Align para posicionar los elementos de la Column.
    - Se envuelve a los widgets deseados con su respectivo align.

### Shape ( añadir borders )
- Se le pasa RoundedRectangleBorder
- Si no se le define el borde por defecto lo coloca en 0, formando un rectángulo.

``` dart
class _CardType2 extends StatelessWidget {
  final String label;
  final double elevation;

  const _CardType2({required this.label, required this.elevation});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.outline),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
```

### Tarjetas con relleno e imágenes
- Para colocarle relleno se debe usar el color de Card.
  - Los colores tienen la propiedadsurfaceVariant.
- Para el relleno se ocupa Stack en lugar de Column.
  - Con Stack el primer elemento en children es el que está más al fondo de la app, mientras que los que le siguen van acercandose al usuario.

``` dart
class _CardType3 extends StatelessWidget {
  final String label;
  final double elevation;

  const _CardType3({required this.label, required this.elevation});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.surfaceVariant,
      elevation: elevation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Column(children: [
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.more_vert_outlined),
                onPressed: () {},
              )),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text('$label - filled'),
          )
        ]),
      ),
    );
  }
}
```

#### Tarjeta con imagen
- Para este caso se puede dar redondeo coin ayuda de la propiedad clipBehavior de Card.
  - Lo más cercano a ClipRRect es Clip.hardEdge, el cual evita que el contenido haga overflow.

``` dart
class _CardType4 extends StatelessWidget {
  final String label;
  final double elevation;

  const _CardType4({required this.label, required this.elevation});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      elevation: elevation,
      clipBehavior: Clip.hardEdge,
      child: Stack(children: [
        Image.network(
          'https://picsum.photos/id/${elevation.toInt()}/600/350',
          height: 350,
          fit: BoxFit.cover,
        ),
        Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20))),
              child: IconButton(
                icon: const Icon(Icons.more_vert_outlined),
                onPressed: () {},
              ),
            )),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text('$label - filled'),
        )
      ]),
    );
  }
}

```

# Sección 10. Continuación
## Temas
- RefreshIndicator
- InfiniteScroll
- ProgresIndicators
- Lineales
- Circulares
- Controlados
- Animaciones
- Snackbars
- Diálogos
- Licencias
- Switches, Checkboxes, Radios
- Tiles
- Listas
- Pageviews

# Notas
- En ThemeData se puede configurar el estilo de todos los AppBars por medio de appBarTheme.
- Los botones se deshabilitan colocando null en onPressed.
- Se puede especificar el width de un SizedBox como double.infinity para que tome todo el ancho.
    - Si el Widget no tiene una dimensión especifica ocasiona errores.
- Al momento de mapear una variable para renderizar widgets directamente en el árbol de widgets se puede usar ...variable.map()
``` dart
    return Column(
      children: [

        ...cards.map(
          (card) =>
              _CardType1(label: card['label'], elevation: card['elevation']),
        )
        
      ],
```
- Mientras más elevación dado a un Widget más profundo es el color principal.
- Se usa SingleChildScrollView para agregar scroll a un Widget.
  - El último elemento parace que le falta espacio entre él mismo y el bottom de la app, por lo que se recomienda poner un Sized Box con altura al final de la lista de widgets.
- Con Stack el primer elemento en children es el que está más al fondo de la app, mientras que los que le siguen van acercandose al usuario.
- En Image.Network se puede usa fit para indicarle a la imagen cómo ocupar el epsacio disponible, en donde se puede pasr BoxFit.cover.