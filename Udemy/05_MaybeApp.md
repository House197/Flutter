# Temas
En esta sección haremos el diseño de la aplicación de YesNo, la cual eventualmente responderá nuestras preguntas (siempre y cuando sean de si o no).

En esta sección veremos:

TextEditingControllers

Focus Nodes

ThemeData

Widgets como:

Containers

SizeBox

ListViews

CustomWidgets

Expanded

Padding

Image (desde internet)

ClipRRect (bordes redondeados)

Entre otros

- Se recomienda tener la extensión Awesome Flutter Snippets para poder usar materialapp, el cual coloca el código base en main dart.

# Estilo global de la aplicación
- Se reocmienda colocar en el estilo de la aplicación en un archivo independiente.
- Se crea la carpeta config y la subcarpeta theme. Finalmente, se crea el archivo app_theme.dart
- Se puede ver que hay tres partes en Flutter:
  - Construcción de lógica de negocio.
  - Conexión entre lógica de negocio y los widgets.
  - Creación de diseño de App.

## app_theme.dart
- Se define la clase AppTheme.
- Se crea un método que regresa el tipo ThemeData, ya que es lo que espera theme en MaterialApp.
- De esta manera, en tiempo de ejecución se puede recibir una variable para determinar el tema de manera dinámica.
- Se definen las variables colorThemes y customColor, las cuales son privadas.
    - Estas variables se usarán en colorSchemeSeed.
- Se crea el parámetro selectedColor, el cual se pasará desde fuera para definir el tema de la aplicación.

``` dart
const Color _customColor = Color(0xFF49149F);

const List<Color> _colorThemes = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
];
```

- Se usan las aserciones para evitar que se mande un valor incorrecto a la clase.

``` dart
class AppTheme {

  final int selectedColor;

  AppTheme({
    this.selectedColor = 0
  }): assert( selectedColor < _colorThemes.length, 'Colors must be below ${_colorThemes.length}'),
      assert( selectedColor >= 0);

```

- En main.dart se llama a esta clase para theme en MaterialApp.

``` dart
lass MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yes No App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme( selectedColor: 2).theme(),
```

# Chat Screen
- Se crea la carpeta presentation -> chat -> chat_screen.dart
- En AppBar del Scaffold de esta pantalla se usa leading y el widget CircleAvatar para definir la imagen de perfil.

## CircleAvatar
- Se tiene el campo backgroundImage.
- Para usar imágenes de intener se usa NetworkImage.

## Área de los mensajes ListView
- Se extrae el Widget Container que se coloca en body del Scaffold.
- Se define a este Widget como privado, por lo que ya no se requiere pasa la key en el constructor.
- Se utiliza Expanded para asegurar que el Widget ocupe todo el espacio disponible en el main axis, el cual es vertical ya que se usa un ListView.
- Se usa SafeArea para envolver a todo el Widget de _ChatView para asegurar que los elementos no choquen con algún elemento del dispositivo.

## SafeArea
- Presenta campos para definir si en algún lado debería ser false y sí ocupe ese espacio.

## ListView builder
- La palabra builder indica que es una función que en tiempo de ejecución se va aejecutar para construir el Widget.
- ListView solo construye los elementos que están en pantalla y los que van a entrar en pantalla.
  - Es decir, va construyendo sobre demanda según se vaya haciendo scroll.
- Los campos importantes son:
  - itemCount, permite indicar el número de elementos a construir. Si se omite entonces los elementos a construir son infinitos.
  - itemBuilder, define una función que permite retornar el elemento a construir.

## Mensajes - Burbujas de Chat
- A partir de este punto se empiezan a definir Widgets específicos, los cuales se van colocando en presentation -> widgets.

### my_message_bubble.dart
- Se define una columna para definir el Container del mensaje y una SizedBox como segundo elemento para hacer la separación.
- Se usa el tema de la aplicación por medio de Theme.of(context).colorScheme.
  - Este elemento va a buscar el contexto más cercano que tenga definido el Theme, el cual en este caso es el global.

### friend_message_bubble.dart
- Se usa Image.network para tomar una imagen o gif de internet
  - Al definir el height y el width de la imagen no afecta a ClipRRect, el cual se queda con la misma medida.
  - Se aplica fit en la imagen para asegurarse que con las dimensiones que se especificaron, ahí coloque la imagen.
  - Es útil definir las dimensiones de las imágenes para reservar el espacio cuando las imágenes se estén cargando y evitar brincos una vez que carguen.
#### ClipRRect
- Widet que permite hacer border redondeados.

### Mostrar mensaje mientras carga la imagen
- Se tienen varias formas, entre las cuales se tiene fadeInImage y el loadingBuilder, el cual es el que se va a usar para Image.Network.
  - Se le requiere pasar un callback.
  - Si loadingProgress es null significa que ya se completó.
    - Se retorna child cuando ya se completa.
    - Se puede retornar cualquier otra cosa si no se ha completado la carga.

``` dart
class _ImageBubble extends StatelessWidget {
  const _ImageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        'https://yesno.wtf/assets/yes/3-422e51268d64d78241720a7de52fe121.gif',
        width: size.width * 0.7,
        height: 150,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            width: size.width * 0.7,
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: const Text('Cui cui texting'),
          );
        },
      ),
    );
  }
}
```

### TextFormField
- Este Widget no se va a ocupar específicamente para el Chat, ya que también se puede ocupar como buscado u otra opción.
- En la carpeta de widgets se crea la carpeta shared.
  - En esta carpeta se crea message_field_box.dart
- Este Widget se ocupa en el Widget Column de chat_screen.dart.
- Se usa decoration para darle estilo, así como Container.

# Notas
- Cuando se tiene una función en un Widget, éstas usan un Callback. Entonces, este Widget no puede ser constante ya que se ejecúta códio en tiempo de tiempo de ejecución.
- Para contenedores se usa decoration: BoxDecoration
  - Se le da radio por medio de radius: BorderRadius.circular(30)
- Se definen Widgets privados solo cuando se van a usar en el Widget del mismo archivo (friend_message_bubble.dart)
- Se toman las medidas del dispositivo con:
  - MediaQuery da información del dispositivo.
``` dart
final size = MediaQuery.of(context).size
```