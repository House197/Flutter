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
  - En la carpate de presentation se definen los Widgets.
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
  - A diferencia de container que espera BoxDecoration, acá se usa InputDecoration.
- En InputDecoration se tienen los siguientes campos:
  - filled (bool), especifica si se debe llenar el fondo del elemento.
  - suffixIcon, coloca un ícono al final del elemento, en donde se puede usar un IconButton para poder desempeñar una acción.
  - enabledBorder. Se le pasa OutlineInputBorder para poder decorar el borde del Widget.
  - focusedBorder coloca otro estilo al darle click al elemento, por lo que se recomienda colocar en una variable el estilo general deseado para el Widget para pasarlo tanto a enabledBorder como focusedBorder.
- Se tiene campos que reaccionan a acciones:
  - onFieldSubmitted
  - onChanged, permite reaccionar a cada letra que se va ingresando el Widget.

#### Comportamiento de FormField
- Se usa TextEditingController, el cual se asocia a una variable final.
  - Otorga control del input que se le asocie.
  - Se asocia al TextFormField por medio del campo controller de TextFormField.
- Por medio de textController.clear() se limpia el texto.
- Se obtiene el valor escrito en el Widget en el IconButton definido en InputDecoratoin por medio de este controller: textController.value.text

##### Mantener el foco en el TextFormField al dar Enter o dar en el botón de DONE del teclado del celular.
- Por defecto, al seleccionar ese botón el teclado se va a cerrar y se pierde el foco.
- Se utiliza FocusNode().
- Se utiliza cuando un elemento necesita un foco.
  - Esto aplica para Widgets que tengan el campo focusNode.
- Se utiliza el método de focusNode requestFocus para darle foco al elemento.
- Se puede cerrar el elemento al hacer click afuera por medio del campo de TextFormField por medio del campo onTapOutside, en donde en el cuerpo de su función se usa el método unfocus de FocusNode.

``` dart
import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  const MessageFieldBox({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final colors = Theme.of(context).colorScheme;
    final FocusNode focusNode = FocusNode();

    final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    final inputDecoration = InputDecoration(
      hintText: 'End you message with a "?"',
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      filled: true,
      suffixIcon: IconButton(
        onPressed: () {
          final textValue = textController.value.text;
          print('Valor del text $textValue');
          textController.clear();
        },
        icon: const Icon(
          Icons.send_outlined,
        ),
      ),
    );

    return TextFormField(
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      focusNode: focusNode,
      controller: textController,
      decoration: inputDecoration,
      onFieldSubmitted: (value) {
        textController.clear();
        focusNode.requestFocus();
      },
      onChanged: (value) {},
    );
  }
}
```

# Temas  Sección 6: Yes No - Maybe App - Funcionalidad
- Gestores de estado
- Mappers
- Peticiones HTTP
- Dio
- Paquetes
- Funciones que retornan valores como callbacks

Scroll

Provider

Y más cosas

## Entidad - Message
- Una unidad atómica es lo más puro que va a necesitar la aplicación para trabajar (entidad).
- Se crea la carpeta domain -> entities -> message.dart, ya que la unidad atómica no es un widget o algo que se muestre en pantalla.
  - En la carpeta de domain se coloca código puro de dart, nada de widgets.
- El mensaje va tener el texto, opcional la imagen (url), y un identificador para saber cuál es del usuario y cual del amigo.

``` dart
enum FromWho { me, hers }

class Message {
  final String text;
  final String? imageUrl;
  final FromWho fromWho;

  Message({
    required this.text,
    this.imageUrl,
    required this.fromWho,
  });
}

```

## Provider - gesto de estado
- Un gestor de estado permite manejar el estado de la aplicación de forma centralizada.
- Se tienen los siguientes:
  - Provider (recomendado por Flutter)
  - Riverpod.
  - InheritedWidget & inheritedModel
- Se crea la carpeta presentation -> providers
  - Es psible incluso crear carpetas como chat -> providers en caso de que el provider sea exclusivo para esa sección.
- Muchas de las funcionalidades de Provider ya vienen integradas en Flutter, por lo que no hace falta hacer instalaciones adicionales.

### Instalación
En pub.dev se busca provider, se hace click en el botón de copiar.
  - Al descargar un paquete se debe verificar la plataforma, ya que al momento del despliegue si la plataforma deseada no esá incluida en esa lista entonces la app no servirá.
- Se puede descargar por medio del comando dado por provider en pub.dev
``` bash
flutter pub add provider
```
- Al descargarlo así, se verifica en pubspec.yaml en las dependencias que se encuentra provider ahí.
- Por otro lado, simlemente se puede pegar en las dependencias de pubspec.yaml lo que se copió del botón de copy de pub.dev.
- La definicón de provider se puede colocar en cualquier Widget, solo que el estado dado por provider solo será accesible para los hijos de ese Widget.
  - Se puede colocar en el punto más alto de la apliación 'main.dart'.
  - Se envuelve a MaterialApp con el Widget MultiProvider.
    - MultiProvider permite en el caso de tener varios proveedores de información(más de una clase (chat_provider.dart)), compartir información.
      - Se utiliza su campos de providers para definir a los proveedores.
      - En este caso solo se tiene un Provider que se encarga de notificar cambios se usa ChangeNotifierProvider.
        - En la propiedad create de este Widget se debe pasar la instancia del proveedor, el cual es ChatProvider.
        - Si en el argumento el valor dado no se usa entonces se coloca _. (_) => 

### ChangeNotifier
- Le permite a un Widget notificar si hay cambios.

``` dart
import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> messagesList = [
    Message(text: 'Holi', fromWho: FromWho.me),
    Message(text: 'Cui cui?', fromWho: FromWho.me),
  ];
}

```

### Mostrar mensaje de provider (Reading a value)
- Provider le extiene a context métodos como watch, read, y select.
  - Watch sirve para poder estar al pendiente de un Widget cuando el provider cambie.
- ChatView es correcto que sea stateless, ya que quien gestiona el estado es provider.
- En la función build de ChatView
  - Se usa Watch de context.
  - Se especifia la instancia de Multiprovider que se desea buscar (ChatProvider).

``` dart
class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: chatProvider.messagesList.length,
            itemBuilder: (context, index) {
              final message = chatProvider.messagesList[index];
              return (message.fromWho == FromWho.hers
                  ? FriendMessageBubble()
                  : MyMessageBubble(message: message));
            },
          )),
          MessageFieldBox()
        ],
      ),
    ));
  }
}
```

### Añadir mensaje al Provider
- Se crea un método en el Provider para añadir el mensaje del usuario.
- El método retornar Future<void>, ya que no retorna nada pero es una función asíncrona.

``` dart
import 'package:flutter/material.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> messagesList = [
    Message(text: 'Holi', fromWho: FromWho.me),
    Message(text: 'Cui cui?', fromWho: FromWho.me),
  ];

  Future<void> sendMessage(String text) async {
    final newMessage = Message(text: text, fromWho: FromWho.me);
    messagesList.add(newMessage);
    notifyListeners();
  }
}
```
- Se utiliza notifyListeners();, el cual es homóloho a setState, pero para Provieder.
  - Le iindica a Flutter que algio del provider cambió.

- Luego, es posible colocar la lectura de provider en message_field_box.dart por medio del método read.
  - Usar read sería útil para tener la instancia del provider y ocupar sus métodos.
  - Esto presenta la desventaja de que el Widget está amarrado a un povider en específico.
- Se toma el ejemplo de la definición de onFieldSubmitted al hacer CTRL + click sobre ese campo.
  - Se aprecia que es de tipo ValueChanged<String>? onFieldSubmitted.
  - ValueChanged es la firma para callbacks que retornan un valor.
  - Se define la variable final onVlue en MessageFieldBox (message_field_box).

``` dart
class MessageFieldBox extends StatelessWidget {
  final ValueChanged<String> onValue;

  const MessageFieldBox({
    super.key,
    required this.onValue,
  });


   final inputDecoration = InputDecoration(
      hintText: 'End you message with a "?"',
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      filled: true,
      suffixIcon: IconButton(
        onPressed: () {
          final textValue = textController.value.text;
          textController.clear();
          onValue(textValue);
        },
        icon: const Icon(
          Icons.send_outlined,
        ),
      ),
    );

  onFieldSubmitted: (value) {
    textController.clear();
    focusNode.requestFocus();
    onValue(value);
  },
```
- Luego, en chat_screen al momento de lamar a MessageFieldBox se pasa onValue, el cual es una callback que llama al método del provider para mandar el mensaje.

``` dart
          )),
          MessageFieldBox(
            onValue: chatProvider.sendMessage,
          )
        ],
```

### Mover Scroll al final
- Se usa el controller del ListView.
  - Ese controller debe ser notificado cuando hay un nuevo mensaje.
  - En el controlador del ChatProvider se define la variable de tipo ScrollController.
    - Esta variable permite tener el control de un único scroll.
  - En el ListView deseado se pasa esa variable.

``` dart
            child: ListView.builder(
              controller: chatProvider.chatScrollController,
              itemCount: chatProvider.messagesList.length,
              itemBuilder: (context, index) {
```

- Al hacer lo anterior se luga el scroll definido en el provider con el de ListView.
  - Entonces, en el ChatProvider se crea la función para mover el scroll.
  - Ser puede usar el método jumpTo, el cual no tiene animación. Por otro lado, se usa animateTo para tener una animación.

``` dart
  void moveScrollToBottom() {
    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut);
  }
```

- Por medio de chatScrollController.position.maxScrollExtent se define el offset, el cual permite navegar hasta el fondo del scroll permitido.
- Luego, se llama esta función en la función de SendMessage para ir moviendo el Scroll cada que se añada un nuevo mensaje.

``` dart
  Future<void> sendMessage(String text) async {
    final newMessage = Message(text: text, fromWho: FromWho.me);
    messagesList.add(newMessage);
    notifyListeners();
    moveScrollToBottom();
  }

```

### Respuesta de YesNo API (uso de dio)
- Se crea config -> helpers -> get_yes_no_answer.dart
- En pub.dev se tiene el paquete http y dio.
- Se prefie el uso de dio ya que es más ligero.
- Dio hacer la serialización del mapa.
  - Es decir, al obtener la respuesta se puede usar inmediatamente el atributo data sobre la variable que tiene la respuesta http.

- En ChatProvider se crea el método herReply para llamar a la respuesta http.
  - Este método se debe llamar cada que el mensaje del usuario termine con signo de interrogación.

#### Mappers
- Se toma data que viene en un formato y se convierte de otra forma para manipularla en la aplicación.
- Se debe hacer un mapeo entre los campos de la respuesta de la API con la que se desea retornar en la aplicación.
- Se crea una clase que se encargue de esa tarea.
- Se crea la carpeta insfrastructure -> models -> yes_no_model.dart
  - El modelo ayuda a trabajar con una implementación del API, en donde si la estructura de la API llega a cambiar fácilmente se puede actualizar el modelo.
    - El modelo solo se va a icupar apara controlar las peticiones de que se hacen hacia la API.
    - En todo lugar se va atrabajr con la entidad local Message.
    - De esta forma, se crea un capa de protección en el código, ya que solo se debe cambiar el modelo si algo llega a cambiar en la API.
  - Se crea el modelo para tener en un lugar centralizado el modelo y ocuparlo en los lugares necesarios de la app.
  - Este modelo va a tener la estructura de la respuesta de la api.
  - Se permite poder recibir un Mapa y a partir de este poder cerar la instancia.
    - Se crea un constructor con nombre, el cual va a ser de tipo factory (factory constructor).
    - El factory permite que cuando se llame ese constructor con nombre va a crear una nueva instancia, la cual es la que se necesita.

``` dart
class YesNoModel {
  String answer;
  bool forced;
  String image;

  YesNoModel({
    required this.answer,
    required this.forced,
    required this.image,
  });

  factory YesNoModel.fromJsonMap(Map<String, dynamic> json) => YesNoModel(
        answer: json['answer'],
        forced: json['forced'],
        image: json['image'],
      );
}

```

- De esta forma, se llama esta clase en get_yes_no_answert.dart

#### QuickType.io
- Se va ala página de este sitio.
- Se selecciona el lenguaje de dart, y se habilitan las opciones de null safety y final properties.
- Se copia la respuesta del API que se necesita mapear.
- Se pega en quicktype.
- Se copia el código generado y se coloca en yes_no_model

``` dart
import 'dart:convert';

YesNoModel yesNoModelFromJson(String str) => YesNoModel.fromJson(json.decode(str));

String yesNoModelToJson(YesNoModel data) => json.encode(data.toJson());

class YesNoModel {
    final String answer;
    final bool forced;
    final String image;

    YesNoModel({
        required this.answer,
        required this.forced,
        required this.image,
    });

    factory YesNoModel.fromJson(Map<String, dynamic> json) => YesNoModel(
        answer: json["answer"],
        forced: json["forced"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "answer": answer,
        "forced": forced,
        "image": image,
    };
}
```

- Se crea un método para crear una instancia del mensaje. Este método es el mapper.

``` dart
  // Mapper
  Message toMessageEntity() => Message(
        text: answer == 'yes' ? 'Si' : 'No',
        fromWho: FromWho.hers,
        imageUrl: image,
      );
}
```

- Finalmente, en get_yes_no_answer se usa el mapper creado en el modelo para retornar.

``` dart
import 'package:dio/dio.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/infrastructure/models/yes_no_model.dart';

class GetYesNoAnswer {
  final _dio = Dio();

  Future<Message> getAnswer() async {
    final response = await _dio.get('https://yesno.wtf/api');

    final yesNoModel = YesNoModel.fromJsonMap(response.data);

    return yesNoModel.toMessageEntity();
  }
}

```

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
- ListView contiene scroll, por lo que de alguna manera debe proporcional el control. 
  - Así como con TextFormField que se tiene el control TextEditingController, entonces el ListView y cualquier otro elemento con Scroll en Flutter proporciona un controlador.