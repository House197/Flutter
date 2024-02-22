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

## Progress Indicators
### CircularProgressIndicator
- Ya viene configurado, en donde se puede cambiar tanto el strokeWidth, backgroundColor.

### ControlledProgressIndicators
- Se puede controlar un Indicator al especificar su campo value.
- A modo de prueba, se envuelve todo con StreamBuilder para poder ir cambiando ese value.

#### StreamBuilder
- Se va ir construyendo en tiempo de ejecución.
- La primera emisión da un valor nulo.
- Se especifica una condición para que el Stream deje de emitir valores con takeWhile().
- No tiene el campo de child, pero sí de builder.
- Flutter automáticamente realizar el dispose del StreamBuilder cuando el widget se destruye.

#### Circular ControlledProgressIndicator

#### Linear ControlledProgressIndicator
- Neceista saber el espacio para poder renderizar la línea.
- Al envolver este elemento en un Row no hay un límite de ancho.
- Se debe usar Exapanded para que tome todo el espacio que el padre da en el eje principal.

``` dart
  }
}

class _ControlledProgressIndicator extends StatelessWidget {
  const _ControlledProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Stream.periodic(const Duration(milliseconds: 300), (value) {
          return (value * 2) / 100;
        }).takeWhile((value) => v<alue < 100),
        builder: (context, snapshot) {
          final progressValue = snapshot.data ?? 0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: progressValue,
                  strokeWidth: 2,
                  backgroundColor: Colors.black12,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: LinearProgressIndicator(
                  value: progressValue,
                ))
              ],
            ),
          );
        });
  }
}
```

## Snackbars
- Se crea con onPressed de FloatingButton de Scaffold.
- Se puede crear de dos maneras:
    - Se usa key para diferenciar el Scaffold.
    - Indicarle a Flutter que encuentre el Scaffold más cercano para construirlo (ScaffoldMessenger).

### ScaffoldMessenger
- Con ScaffoldMessenger.of(context).clearSnackBars(); se limpian los Snackbars anteriores para evitar mostrar varios si el usuario dio varias veces click a su invocación.
- Se puede agregar una action al snackbar, la cual sin importa qué va a hacer que se cierre el snackbar.
- Se puede definir el tiempo que el Snackbar va a estar presente.

``` dart
import 'package:flutter/material.dart';

class SnackbarScreen extends StatelessWidget {
  static const name = 'snackbar_screen';

  const SnackbarScreen({super.key});

  void showCustomSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackbar = SnackBar(
      content: const Text('Hola Mundo'),
      action: SnackBarAction(label: 'Ok!', onPressed: () {}),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snackbars y Diálogos'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCustomSnackbar(context),
        label: const Text('Mostrar Snackbar'),
        icon: const Icon(Icons.remove_red_eye_outlined),
      ),
    );
  }
}

```

## Diálogos y licencias
### Mostrar licencias
- Flutter da showAboutDialog, el cual abre una popup que contiene un botón que despliega las licencias usadas.
- El título del diálogo se puede cambiar desde él mismo o que tome el tpitutlo de Material App.
- El contenido del diálogo se coloca por medio del campo children.

``` dart
  void showCustomSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackbar = SnackBar(
      content: const Text('Hola Mundo'),
      action: SnackBarAction(label: 'Ok!', onPressed: () {}),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }


       floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCustomSnackbar(context),
        label: const Text('Mostrar Snackbar'),
        icon: const Icon(Icons.remove_red_eye_outlined),
      ),
```

### Diálogo personalizado (AlertDialog)
- Se usa showDialog, el cual contiene el campo de builder.
- Del campo de builder se retorna AlertDialog.
    - Tiene los campos de title, content y actions.
    - Se puede cerrar usando context.pop(), lo  cual es posible a go_router. De lo contrario se tendría que usar Navigator.of
    - Para evitar que se cierra haciendo click fuera de él se coloca barrierDismissable en false en showDialog.

``` dart
  void openDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Estas seguro?'),
              content: const Text(
                  'sdsfdsffa ff gd fgsdh hv  lk osaf dsf aosdf osalf'),
              actions: [
                TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancelar')),
                FilledButton(
                    onPressed: () => context.pop(),
                    child: const Text('Aceptar'))
              ],
            ));
  }

              FilledButton.tonal(
              onPressed: () => openDialog(context),
              child: const Text('Mostrar diálogo'),
            )
```

## Animated Container
- Es un contenedor que cuando detecta un cambio en su propiedad anima ese cambio.

``` dart
AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 200,
          height: 230,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(30)),
        ),
```

## Checkbox, Radios y otros Tiles
### SwitchListTile
``` dart
class _UiControlsView extends StatefulWidget {
  const _UiControlsView();

  @override
  State<_UiControlsView> createState() => _UiControlsViewState();
}

enum Transportation { car, plane, boat, submarine }

class _UiControlsViewState extends State<_UiControlsView> {
  bool isDeveloper = true;
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        SwitchListTile(
          title: const Text('Developer Mode'),
          subtitle: const Text('Controles adicionales'),
          value: isDeveloper,
          onChanged: (value) => setState(() {
            isDeveloper = value;
          }),
        )
      ],
    );
  }
}
 
```

### RadioListTile
- Solo permite seleccionar una opción.
- Se crea una enum para determinar los valores permitidos para el Radio.
``` dart
enum Transportation { car, plane, boat, submarine }

class _UiControlsView extends StatefulWidget {
  const _UiControlsView();

  @override
  State<_UiControlsView> createState() => _UiControlsViewState();
}

class _UiControlsViewState extends State<_UiControlsView> {
  bool isDeveloper = true;
  Transportation selectedTransportation = Transportation.car;
```
- Sus campos son:
    - El value ayuda a enlazar el valor seleccionado con el valor actual.
    - groupValue es la variable que se usa para marcar cuál es la opción seleccionada.
    - onChange permite gestionar la acción. 

``` dart
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        RadioListTile(
          title: const Text('By Car'),
          subtitle: const Text('Viajar por carro'),
          value: Transportation.car,
          groupValue: selectedTransportation,
          onChanged: (value) => setState(() {
            selectedTransportation = Transportation.car;
          }),
        ),
        RadioListTile(
          title: const Text('By Boat'),
          subtitle: const Text('Viajar por barco'),
          value: Transportation.boat,
          groupValue: selectedTransportation,
          onChanged: (value) => setState(() {
            selectedTransportation = Transportation.boat;
          }),
        ),
        RadioListTile(
          title: const Text('By plane'),
          subtitle: const Text('Viajar por avión'),
          value: Transportation.plane,
          groupValue: selectedTransportation,
          onChanged: (value) => setState(() {
            selectedTransportation = Transportation.plane;
          }),
        ),
```

## ExpansionTile
- Permite envolver elementos para compactarlos en la ui, en donde por medio de un botón se despliegan.

## CheckboxTile
- Es una opción independiente basada en un valor booleano.
- En un Stateful Widget se definen las opciones

``` dart
  bool wantsBreakfast = false;
  bool wantsLunch = false;
  bool wantsDinner = false;

         CheckboxListTile(
          title: const Text('Desayuno?'),
          value: wantsBreakfast,
          onChanged: ((value) => setState(() {
                wantsBreakfast = !wantsBreakfast;
              })),
        ),
        CheckboxListTile(
          title: const Text('Almuerzo?'),
          value: wantsLunch,
          onChanged: ((value) => setState(() {
                wantsLunch = !wantsLunch;
              })),
        ),
        CheckboxListTile(
          title: const Text('Cena?'),
          value: wantsDinner,
          onChanged: ((value) => setState(() {
                wantsDinner = !wantsDinner;
              })),
        ),
```

## PageView App Tutorial
- Se basa en PageView para hacer el swip de ventanas de forma horizontal.
- Se colocar physics para poder tener el mismo comportamiendo en iOs y Android.
- En _Slide se usa Image(image: AssetImage()) para pasar la imagen, pero se pudo haber hecho también con Image.asset

### Determinar último slide
- Se tiene el campo de controller en PageView.
- Todos los widgets que hacen un movimiento de slide tienen un controlador.
  - ListView.
  - SinglePageScrollView.
  - PageView.
- Se debe usar un stateful widget para poder saber el slide actual por medio de la variable que contendrá el controller.
  - El pageViewController tiene la propiedad page para indicar la page en donde se encuentra.
    - El máximo es 1 y el mínimo es 0.
    - Cada que se va haciendo el movimiento del swipe se van incrementando ese valor.
- Se define la variable que contiene el controlador.
  - Con init se le agrega un listener a la variable del controlado, en donde se puede determinar la page actual.

``` dart
class _AppTutorialScreenState extends State<AppTutorialScreen> {
  //late final PageController pageViewController;
  final PageController pageViewController = PageController();
  bool endReached = false;
  @override
  void initState() {
    super.initState();
    pageViewController.addListener(() {
      final page = pageViewController.page ?? 0;
      //Por si aún no se ha asignado el controlador.
      if (!endReached && page >= (slides.length - 1.5)) {
        setState(() {
          endReached = true;
        });
      }
      print("${pageViewController.page}");
    });
  }
  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

```

## InfiniteScroll
- Se usa ListView.builder para cargar las imágenes, ya que permite renderizar las imágenes que van a entrar a pantalla en lugar de renderizar todas de golpe.
- Se usa FadeInImage para colocar una imagen por defecto en lo que carga la que debe.

``` dart
FadeInImage(
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
              placeholder: AssetImage('assets/images/jar-loading.gif'),
              image: NetworkImage(
                  'https://picsum.photos/id/${imagesIds[index]}/500/300'),
            );
```

- Para que el ListView ocupe el espacio en blanco que aparece en la pantalla se envuelve con el widget MediaQuery.removePadding, usando su campo removeTop en true. Así como removeBottom para que ocupe el espacio de abajo.

``` dart
class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {
  List<int> imagesIds = [1, 2, 3, 4, 5];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        removeTop: true,
        child: ListView.builder(
            itemCount: imagesIds.length,
            itemBuilder: (context, index) {
```

### Imágenes infinitas
- Se tiene la lisya imagesIds, la cual va pasando el id de la imagen.
  - Se le van a ir agregando elementos.

``` dart
class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {
  List<int> imagesIds = [1, 2, 3, 4, 5];

  void addFiveImages() {
    final lastId = imagesIds.last;
    imagesIds.addAll([1, 2, 3, 4, 5].map((e) => lastId + e));
  }

```

- Por medio de un scroll controller se va a mandar a llamar la función.
  - El controller se va a colcoar en el ListView.
  - Por medio de un listener y de position.maxScrollExtent para saber el límite del scroll se hace esto.
  - Se coloca un threshold para llamar a la función un poco antes de llegar al fondo.
  - A pesar de que Flutter va a estar disparando esta parte de forma seguida y haciendo la evaluación, no tiene tanto impacto ya que no se hace un redibujo por medio de setState.
  - Se simula una acción sincrona para dar la impresión que se cargan nuevas imágenes.
  - Por medio de una bandera se asegura que la función que carga la acción simulada sincrona no se dispare varias veces.
  - Se debe verificar que el Widget esté montado antes de mandar el setState.
    - Esto puede ocurrir si se sale de la app y el Widget no está montado, lanzando una exepción.

``` dart
class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {
  List<int> imagesIds = [1, 2, 3, 4, 5];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool isMounted = true;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      //scrollController.position.pixels
      if ((scrollController.position.pixels + 500) >=
          scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    isMounted = false;
    super.dispose();
  }

  Future loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});

    await Future.delayed(const Duration(seconds: 2));

    addFiveImages();
    isLoading = false;

    if (!isMounted) return;

    setState(() {});
  }

  void addFiveImages() {
    final lastId = imagesIds.last;
    imagesIds.addAll([1, 2, 3, 4, 5].map((e) => lastId + e));
  }
```

### Refresh Indicator
- Se envuevle el ListView con RefreshIndicator.
- El campo onRefresh se llama cuando se realiza el trabajo.
- También se puede personalizar su posición por medio de edgeOffset.
    - También se tiene strokeWidth.

``` dart
 Future<void> onRefresh() async {
    isLoading = true;
    setState(() {});
    await Future.delayed(const Duration(seconds: 3));
    if (!isMounted) return;
    isLoading = false;
    final lastId = imagesIds.last;
    imagesIds.clear();
    imagesIds.add(lastId + 1);
    addFiveImages();

    if (!isMounted) return;
    setState(() {});
  }

  RefreshIndicator(
          strokeWidth: 2,
          edgeOffset: 10,
          onRefresh: onRefresh,
          child: ListView.builder(
              controller: scrollController,
              itemCount: imagesIds.length,
              itemBuilder: (context, index) {
                return FadeInImage(
```

### Mover Scroll de forma automática
``` dart
  void moveScrollToBottom() {
    if (scrollController.position.pixels + 150 <=
        scrollController.position.maxScrollExtent) return;
    scrollController.animateTo(scrollController.position.pixels + 150,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

// Se llama en la siguiente función

  Future loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});

    await Future.delayed(const Duration(seconds: 2));

    addFiveImages();
    isLoading = false;

    if (!isMounted) return;

    setState(() {});

    moveScrollToBottom();
  }
```

# Sección 11. Riverpod - Menú y Temas
## Temas
- Drawers (menús laterales).
- Gestor de estado Riverpod.

## Navigation Drawer
- Se coloca en el campo drawer dado por Scaffold.
- Se le pasa NavigationDrawer.
- Ya que no es una pantalla entera, y solo se va a crear un menú se coloca su diseño en presentation -> widgets -> side_menu.dart.
    - Va a ser Stateful ya que se necesita saber la opción seleccionada.
- Se van a usar los elementos del archivo menu_items.dart
    - A modo de prueba se colocan dos elementos en children de NavigationDrawer por medio de los Widget NavigationDrawerDestination.
- Así como con el navegador que se puede tener en el bottom de la app, la opción seleccionada se da por un index, el cual se puede asignar por medio del campo onDestinationSelected y el campo selectedIndex.

### Consideraciones de Notch y opciones del menú
- Algunos elementos tienen el Notch, lo cual Flutter con NavigationDrawer ya se encarga de renderizar los elementos de tal forma que no choquen.
    - Sin embargo, el diseño puede verse bien para algunas plataformas pero para otras no.
- Se determina si el dispositivo tiene notch por medio de:

``` dart
final hastNotch = MediaQuery.of(context).viewPadding.top > 35;
```

- Ayuda a determinar el Padding en una dirección.
- A partir de esto se puede determinar el valor para dar a algunos widgets.

``` dart
class _SideMenuState extends State<SideMenu> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final hastNotch = MediaQuery.of(context).viewPadding.top > 35;

    return NavigationDrawer(
        selectedIndex: selectedIndex,
        onDestinationSelected: (selected) {
          selectedIndex = selected;
          setState(() {});
        },
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(28, hastNotch ? 10 : 20, 16, 20),
            child: const Text('Menu'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.add),
            label: const Text('Home Screen'),
          ),
```

- Se construyen los elementos de menú con la variable de appItemsMenu, en donde se usa sublist para tomar una porción de los elementos a modo de poder añadir más estilo al menú.
    - Se tiene el Widget Divider para colocar una línea horizontal.

``` dart
         Padding(
            padding: EdgeInsets.fromLTRB(28, hastNotch ? 10 : 20, 16, 20),
            child: const Text('Menu'),
          ),
          ...appMenuItems.sublist(0, 3).map(
                (item) => NavigationDrawerDestination(
                  icon: Icon(item.icon),
                  label: Text(item.title),
                ),
              ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),
```

### Navegar desde el menú
- Por medio del campo onDestinationSelected de NavigationDrawer se toma el menu item por medio del value dado por el callback.
    - De esta forma, se ocupa context.push(menuItem.link)
- Por otro lado, al regresar de la página que se navegó se aprecia que el menú sigue abierto.
    - Se va a cerrar por medio de tener una referencia del Scaffold que tiene al drawer, siendo el que están en HomeScreen.
    - La referencia se obtiene por el campo de key que presenta Scaffold.

``` dart
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Flutter + Material 3'),
      ),
      body: const _HomeView(),
      drawer: const SideMenu(),
    );
  }
}
```

- Este scaffoldKey tiene la referencia al estado actual del Scaffold. (Si tiene drawers, menú lateral al inicio o al final.)
    - Se puede tener un service locators y gestor de estado, pero como está ligado directamente a ese SideMenu está bien colocarlo ahí.
- En SideMenu se hace referencia por medio de pasarlo en el parámetro.

``` dart
class SideMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SideMenu({super.key, required this.scaffoldKey});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

```

- Esta propiedad se va a usar en onDestinationSelected.
    - Se realiza un null operator para revisar que no sea null y se aplica su método closeDrawer().

``` dart
    return NavigationDrawer(
        selectedIndex: selectedIndex,
        onDestinationSelected: (selected) {
          selectedIndex = selected;
          final menuItem = appMenuItems[selected];
          setState(() {});
          context.push(menuItem.link);
          widget.scaffoldKey.currentState?.closeDrawer();
        },
```

- Falta tener un gestor de estado para saber cuál fue la última opción seleccionada del menú.

## Preparación de pantalla para Riverpod
- presentation -> screens -> counter -> counter_screen.dart

## Riverpod
### Nota de actualización
Riverpod annotations y generador de código
Como varios sabrán, Riverpod no hace mucho lanzó una nueva sintaxis, (No marca como obsoleta la anterior sintaxis) significa que ahora tenemos dos formas de usarlo.

La nueva versión utiliza decoradores y anotaciones que ayudan al generador de código para crear el provider ideal para lo que queremos hacer.

Tiene pro y contras esta nueva versión de código:

Pros:

Es la forma recomendada por Riverpod

Sintaxis mucho más simple

Determina automáticamente el provider acorde a la necesidad

Cons:

Hay que mantener un watch o ejecutar el generador en cada cambio que hagamos en los providers

flutter pub run build_runner watch

Un paquete adicional de riverpod_generator como dependencia de desarrollo (que realmente no es gran problema)

Pueden ver los ejercicios de una u otra sintaxis con el switch que colocaron en el sitio web de Riverpod

### Introducción
- Riverpod no depende de context.
- Flutter_riverpod es la implementación de riverpod para Flutter.

1. Se insatala con pub assist y escribiendo flutter_riverpod.
2. Se envuelve a MyApp en main.dart con el Widget ProviderScope, el cual va a mantener una referencia a todos los providers que se utilicen.

``` dart
void main() => runApp(
      const ProviderScope(child: MyApp()),
);

```

3. Se crea presentation -> providers -> counter_provider.dart
    - StateProvider es un proveedor de un estado.
    - Es una pequeña pieza de información del aplicación

``` dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 5);

```

4. Se utiliza provider en counter_screen.dart
    - Forma 1. Envolver el Widget con un Consumer, el cual es un builder.
        - En lugar de heredear de un StatelessWidget se se hereda de un ConsumerWidget.
            - Funciona igual que un StatelessWidget con algunas adiciones para el uso del provider.
        - ConsumerWidget ofrece la referencia en el build method.
            - Esto es como indicarle a Riverpod que se va a ocupar la referencia a algún provider.
            - El provider se especifica en el método watch de ref.

``` dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets_app/presentation/providers/counter_provider.dart';

class CounterScreen extends ConsumerWidget {
  static const name = 'counter_screen';
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final clickCounter = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Screen')),
      body: Center(
        child: Text(
          'Valor: $clickCounter',
          style: titleStyle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

- Con watch se están al pendiente de los cambios del proveedr de información.
    - Cuando CounterProvider cambia (el proveedor de información), entonces se determina lo que se debe redibujar.
    - Si algo no cambia, entonces usa lo que tiene en memoria.
        - Si determinadas sección del Widget no cambian, entonces se ocupa lo que está en memoria y solo redibuja lo que tuvo cambio.

### Cambiar valores y modificadores
- Forma 1. Usar ref.read para leer provedores desde métodos.
    - Se debe usar el método notifier del provider.
        - Si no se usa notifier entonces apunta al valor, pero la usar notifier se tiene acceso al state.
    - Se usa el método state de read.
    - Con lo anterior ya se puede modificar el valor del provider.
``` dart
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),
```
- Forma 2. Esta forma es conveniente para cuando se necesita el estado o algo en general.

``` dart
     floatingActionButton: FloatingActionButton(
        onPressed: () {
          //ref.read(counterProvider.notifier).state++;
          ref.read(counterProvider.notifier).update((state) => state + 1);
        },
        child: const Icon(Icons.add),
      ),
```

### Provider de theme
1. presentation -> providers -> theme_provider.dart

### Pantalla para cambiar colores
1. La lista de colores constante que se definió en app_theme.dart
    - En el proveedor de Theme se coloca uno inmutable.
    - Se hace usando Provider y retornando la lista de colores de app_theme.dart.

``` dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets_app/config/theme/app_theme.dart';

final isDarkModeProvider = StateProvider((ref) => false);

final colorListProvider = Provider((ref) => colorList);

```

2. Jalar provider en theme_changer_screen.dart
    - Se usa ref.watch, ya que este método sabe cuándo cambia y cuándo no.
    - Se podría pensar en usar read ya que se sabe que ese valor nunca va a cambiar, pero watch es capaz de saber eso.

#### RadioListTile
- Se usa para mostrar las opciones de colores disponibles.
- Se usa un provider para mantener registro del indice seleccionado.
    - Se coloca el mismo color al radio button por medio del campo activeColor.
    - groupValue muestra el valor seleccionado, en donde se marca el radio button.
    - El campo de Value se el valor que se le asigna a cada Radio, el cual se toma del ListView.

``` dart
class _ThemeChangerView extends ConsumerWidget {
  const _ThemeChangerView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(selectedColorProvider);
    final List<Color> colors = ref.watch(colorListProvider);
    return ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          return RadioListTile(
              title: Text(
                'Este color',
                style: TextStyle(color: color),
              ),
              subtitle: Text('${color.value}'),
              activeColor: color,
              value: index,
              groupValue: selectedColor,
              onChanged: (value) {
                ref
                    .read(selectedColorProvider.notifier)
                    .update((state) => value!);
              });
        });
  }
}
```

### Indice del color seleccionado
- En theme_provider se define el provider para el color seleccionado, el cual se usará en Theme_changer_screen.

### App Theme
- Recibe como argumento isDarkMode para poder usarlo en el brightness de ThemeData.

``` dart
class AppTheme {
  final int selectedColor;
  final bool isDarkMode;

  AppTheme({
    this.selectedColor = 0,
    this.isDarkMode = false,
  }) : assert(selectedColor >= 0 && selectedColor < colorList.length,
            'selectedColor must be positive and less or equal than ${colorList.length}');

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      colorSchemeSeed: colorList[selectedColor],
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
```

- Se recibe desde main.dart, por lo que se debe hacer ConsumerWidget para poder leer el valor y pasarlo a AppTheme.

``` dart

void main() => runApp(
      const ProviderScope(child: MyApp()),
    );

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final selectedColor = ref.watch(selectedColorProvider);
    return MaterialApp.router(
      title: 'Flutter Widgets',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: selectedColor, isDarkMode: isDarkMode)
          .getTheme(),
    );
  }
```

## Riverpod StateNotifier
- Se quiere estar pendiente de la clase de AppTheme.
- En theme_provider.dart se va a crear un objeto personzalizadp de tipo AppTheme.
    - Se usa StateNotifierProvider.
    - Se recuerda que Provider es para valores inmutables, StateProvider es para mantener alguna pieza de estado,
    y StateNotifierProvider es para mantener un estado de forma más elaborada.
    - Se aprecia al dejar el cursor sobre la clase que StateNotifierProvider<Null, Object?>
        - El primer elemento es el nombre de la clase que se desea contorle el estado.
        - El segundo es el estado que se va a tener.

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
- Se importa algo específico de una librería con show:
``` dart
import 'dart:math' show Random;
```
- Se quita física de rebote en ListView con pysics, const ClampingScrollPhysics().
- Se recomienda reiniciar la aplicación por completo al cargar assets como imágenes.
- Tener cuidado al invocar setState en un listener, ya que el sitener ejecuta la función varias veces debido al frame de actualización que presenta flutter.
  - Es buena práctica mandar dispose de un controlador cada que se usa un listener.
- No usar métodos como watch dados por Riverpod en métodos como onPressed.
    - Se debe usar read.