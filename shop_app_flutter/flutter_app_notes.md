# Shopping cart

# Puntos por ver:
- Theming
- Navigation

# Creación del proyecto
- Se ejecuta el comando para crear el proyecto.

``` bash
flutter create <project_name>
```

# Agregar custom fonts
## Método 1
- EN pub.dev se tiene el paquete google_fonts.
    - google_fonts permite usar cualquiera de los fonts que google provee.
- Se agrega el font al Text por medio de la propiedad style.

``` dart
Text(
    'This text',
    style: GoogleFonts.lato(),
)
```

- La desventaja que presenta es que usa una llamada http, lo cual puede tardar para mostrar el resultado deseado en el Widget.

## Método 2
- En el archivo pubspec.yaml hay un apartado llamado fonts.
    - Se descomenta al apartado para poder usarlo.
    - Se coloca el path hacia las fonts.
``` yaml
  fonts:
    - family: Lato # Se puede colocar cualquier nombre
      fonts:
        - asset: assets/fonts/Lato-Bold.ttf
        - asset: assets/fonts/Lato-Light.ttf
          weight: 700 # Lato-Bold solo se activa con un weight de 700
```
- Se debe descargar el font deseado.
- Se crea la carpeta assets/fonts en el root para agregar el paquete de fonts.
- Se puede especificar el fontFamily en el Widget de Text por medio del nombre dado a la familia.

``` dart
Text(
    'Hello World',
    style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
),
```

- Se aplica el font a toda la aplicación al especificarla en el Theme de MaterialApp.

``` dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      home: const HomePage(),
    );
  }
}
```

# Equema de colores.
- En Theme de MaterialApp se usa colorScheme para especificar un solo color del cual los demás se van a derivar.
- Se usa ColorScheme.fromSeed para especificar el color.

``` dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(254, 206, 1, 1)),
      ),
      home: const HomePage(),
    );
  }
}
```

# Generalización de estilo de Text
- En ThemeData también se puede definir el estilo de Text por medio de TextTheme.
- Por defecto, AppBar usa el TextTheme definido por defecto por Flutter.

``` dart
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(254, 206, 1, 1),
            primary: const Color.fromRGBO(254, 206, 1, 1),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            prefixIconColor: Color.fromRGBO(119, 119, 119, 1),
          ),
          textTheme: const TextTheme(
            titleMedium: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            bodySmall: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          )),
      home: const HomePage(),
    );
```

- Para que el Widget toma esta configuración se debe usar Theme.of(context).textTheme.titleMedium
  - En lo anterior el último elemento en la cadena es la propiedad de la que se quiere heredar.

``` dart
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: const Color.fromRGBO(216, 240, 253, 1),
      child: Column(
        children: [
          Text(
            product,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text('\$$price', style: Theme.of(context).textTheme.bodySmall),
          Image.asset(
            image,
            height: 175,
          )
        ],
      ),
    );
```

# AppBarTheme
- Se establece el diseño general de AppBar.

``` dart
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(fontSize: 20, color: Colors.black)),
```

# Home Page
## AppBar personalizado
- Se realiza directamente en body de Scaffold.

### SafeArea Widget
- Permite colocar Widgets de tal forma que no chocarán con los elementos del celular, tal como el top notch.
- Se coloca un text y un TextField.
    - TextField es un elemento que ocupa todo el width de la pantalla, así que por sí solo dará un error. Se debe limitar su ancho.

### Expanded
- Simula el width 100% o flex 1 de CSS para un elemento, permitiendole espeicficar que ocupe el espacio que tiene disponible.
- Se modifica el flex de un determinado Widget (p/e: un widget tengla felx de 2 mientras otros de 1) con el Widget Spacer.

``` dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Shoes\nCollection',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Diseño de TextField
- Se usa decoration: InputDecoration.
- Se define el estilo para las Input en MaterialApp Theme.
    - Se usa la propiedad inputDecorationTheme.

#### Diseño de Border para TextField
- Se coloca en el Widget deseado.
- Se usa la propiedad border en conjunto con la clase abstracta OutlinedInputBorder.
    - Se tienen dos propiedades para dar estilo al border:
        - borderSize.
        - borderRadius.
    - Se puede guardar el estilo en una variable y pasarla a la propiedad de border.

``` dart
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(50),
      ),
    );
```
- Se usa enabledBorder para asegurar que los colores dados apliquen.
    - A esta propiedad se le asigna la variable de border que guarda el estilo.
    - Luego, a la propuedad de focusedBorder también se le pasa el estilo de border para asegurar que no sea diferente al hacer focus al Widget.

``` dart
Expanded(
    child: TextField(
    decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(
        Icons.search,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
    ),
    ),
)
```
## Filtros de objetos
### Método 1. Uso de ListView.builder
- Se crea una lista dentro en el nivel superior de la clase para poder definir los filtros.

#### Widget Chip
- Permite definir el 'botón' para el filtro.
- Chip cuenta con varias propiedades para el estilo, tales como:
    - label.
    - labelStyle.
    - backgroundColor.
    - side (se da estilo usando BorderSize).
    - padding.
    - shape (se le da estilo con RoundedRectangleBorder), lo que permite por ejemplo modificar el borderRadius.

##### Dar estilo diferente a Chip según el filtro seleccionado.
- Por medio de un estado se guarda el valor seleccionado.
- Se sabe qué valor se va seleccionando por medio de un Gesture Detector que cuenta con la propiedad onTap.
    - Gesture Detector no es algo con lo que Chip cuente, por lo que se envuenlve en el componente GestureDetector.
- Se debe convertir el Widget de Home_Page a un Stateful Widget.
- En el tema de la aplicación se sobrescribe el color primario para poder usarlo por medio de Theme.of(context).colorScheme.primary.

``` dart
            SizedBox(
              width: double.infinity,
              height: 120,
              child: ListView.builder(
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Chip(
                        label: Text(
                          filter,
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        backgroundColor: selectedFilter == filter
                            ? Theme.of(context).colorScheme.primary
                            : const Color.fromRGBO(245, 247, 249, 1),
                        side: const BorderSide(
                          color: Color.fromRGBO(245, 247, 249, 1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
```

## Cartas de artículos
- Para poder utilizar las imagenes colocadas en assets/images se debe modificar el archivo pubsec.yaml.
  - Se descomenta la sección de assets para imágenes y se enlistan las imágenes que se desean usar.
  - Por otro lado se puede especificar el path de la carpeta que contiene a las imágenes.

``` yaml
  # To add assets to your application, add an assets section, like this:
   assets:
     - assets/images/

```

- Al pasar los parámetros que requiere el Widget creado se debe especificar el tipo de dato, ya que en global variables la variable products que se definió tiene el tipo de dato:

``` dart
List<Map<String, Object>>
```

- Entonce, flutter piensa que es un objeto, por lo que se le debe indicar que se está seguro que es un valor.

``` dart
           Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index]['title'];
                  final price = products[index]['price'];
                  final image = products[index]['imageUrl'];
                  return ProductCard(
                    product: product as String,
                    price: price as double,
                    image: image as String,
                  );
                },
              ),
            )
```

### Uso de imágenes
- Se usa el Widget Image.
  - Requiere el uso de
- En Flutter se crearon las clases abstractas cuando hay varios tipos que se le pueden pasar. Por ejemplo para la image:
  - La imagen puede venir de assets.
  - De internet.
- En este caso se usa AssetImage.
- Image tiene la propiedad de Height.

``` dart
class ProductCard extends StatelessWidget {
  final String product;
  final double price;
  final String image;
  const ProductCard(
      {super.key,
      required this.product,
      required this.price,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: const Color.fromRGBO(216, 240, 253, 1),
      child: Column(
        children: [
          Text(product),
          Text('\$$price'),
          Image(
            image: AssetImage(image),
            height: 175,
          ),
        ],
      ),
    );
  }
}
```

- Una alternativa más corta para el uso de imagen es con Image.asset(image, height)

``` dart
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: const Color.fromRGBO(216, 240, 253, 1),
      child: Column(
        children: [
          Text(product),
          Text('\$$price'),
          Image.asset(
            image,
            height: 175,
          )
        ],
      ),
    );
  }
```

## Product Details Page
### Spacer
- Así como SizedBox, permite dejar espacio entre elementos usando flex.

### ElevatedButton
- Se le da estilo con style: ElevatedButton.styleFrom()

## Navigation
- Navigator es responsable de la gestión de la navegación de stack y el manejo de transiciones entre diferentes pantallas o rutas en la navegación.
- Se usa Navigator.of(context).
  - Al usar esto en el fondo se usa InheritedWidget, y retorna el primer Widget Navigator en el tree que contiene el build context.
  - Al entontrar al Navigator Widget retorna una instancia del Navigator State.
    - Navigator State permite manipular el Navigator Stack (push, pop, etc.).
  - Build Context se encarga de localizar al Navigator State Widget correcto. 
- Navigator trabaja con el concepto de Stack.
  - Detrás de escenas mantiene un stack de objetos Route que representan las diferentes ventanas o rutas en la app.
- Navigator puede ser usado para mostrar popups.
- El código en este caso se coloca onTap de GestureDetector que nvuelve al Widget de ProductCard.
- Se tienen las siguientes opciones:

### pop
- Con este método se remueve la primera pila del Stack.

### push
- Agrega una pila al stack.

### pushReplacement
- Reemplaza la pila actual con otra.

- Para la aplicación se usa push para agregar el Widget a mostrar sobre el que se tiene actualmente.
- En el argumento se puede pasar MaterialAppRoute, CupertninoAppRoute, PageRouteBuilder, o cualquier cosa que extienda a Route.
- Simplemente se retorna el Widget que se desea mostrar.

``` dart
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index]['title'];
                  final price = products[index]['price'];
                  final image = products[index]['imageUrl'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return ProductDetails(product: products[index]);
                        }),
                      );
                    },
                    child: ProductCard(
                      product: product as String,
                      price: price as double,
                      image: image as String,
                      backgroundColor: index.isOdd
                          ? const Color.fromRGBO(245, 247, 249, 1)
                          : const Color.fromRGBO(216, 240, 253, 1),
                    ),
                  );
                },
              ),
            )
```

## Guardar articulos en carrito de compra (State Management)
- El carrito de compra esta en otro stack.
- State Management es accesible por todos los stacks. Puede verse como el pilar de la aplicacion (18:56:19)

## CartPage
### ListTitle
- Se usa en conjunto con ListView.builder.
- Tiene las siguientes propiedades.
  - leading. Permite colocar un Widget al inicio.
  - title. Coloca el titulo de este Widget.
  - subtitle. Coloca elemento por debajo de title.

### CircularAvatar
- Permite colocar una imagen en un borde circular.
- Requiere la propiedad backgroundImage, la cual no pide un Widget como Image.asset, sino un Image Provider como AssetImage.


### Navegacion a carrito
- En Scaffold se tiene otra propiedad, la cual es bottomNavigationBar.
- Se coloca en el Scaffol de home_page.
- Se mantiene regustro de la pagina que se ve actualmente por medio de la creacion de la variable currentPage de tipo entero.
  - BottomNavigation requierede currentIndex y de una funcion (onTap).
    - La function onTap de este Widget provee del argumento que da el indice del boton seleccionado, lo que permite actualizar la variable que lleva registro de la ventana que se visita.
- Se extrae la lista de productos definida en home_page y se coloca en un Widget separado con la finalidad de poder switchear entre el Widet del carrito y la lista de productos.
- Se crea una lista de Widgets para almacenar las dos paginas con las que se hara esta navegacion (ProductsList, CartList).
  - Por medio de la variable currentPage se conmuta la pagina a mostrar usando esta variable como indice del arreglo de Widgets creado.
  - Se usa IndexedStack, el cual permite que el state se mantenga (por ejemplo, el scroll que se tenia en un Widget no se perdera).

``` dart
import 'package:flutter/material.dart';
import 'package:shop_app_flutter/cart_page.dart';
import 'package:shop_app_flutter/product_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  List<Widget> pages = const [
    ProductList(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Cart'),
        ],
      ),
    );
  }
}
```

# Container y Decoration
- Por medio de decoration es posible dar un radio a los bordes de un contenedor.
- Si se usa decoration, entonces no es posible usar color en las propiedades de Container, ya que color ahora debe estar definido en Decoration.
- BoxDecoration no es exclusivo de Container.
- Esto se aplicó para el Widget ProductCard.

# State Management
- Flutter cuenta con un elemento Root, el cual renderiza al Widget principal que corresponde con MaterialApp.
- MaerialApp almacena ThemeData.
- En Widgets hijos es posible usar Theme.of(context), lo cual ayuda a evitar tener que pasar la data de Theme al constructor de los Widgets padre hasta llegar al Widget deseado (homólogo a prop drilling en React.)
  - Con lo anterior dicho, se está usando Theme, por lo que va a buscar al primer Widget con el theme data definido.
  - Theme.of(context) empieza a buscar desde el Widget en donde se llama hasta encontrar al padre que contenga ThemeData definido, por lo que si se tienen varios Widgets así, tomará al primero más cercano al Widget hijo.
  - En caso de no definir ThemeData entonces irá hasta MaterialApp, ya que por defecto establece un ThemeData.
  - En otras palabras, puede verse como la API useContext en React.
- En el fondo se usa el Widget llamado _InheritedTheme, el cual se extiende de InheritedWidget.

## Provider
- Es una libreria en pub.dev que ayuda con la gestion de estado para no tener que escribir codio usando Inerited Widget.
- Se coloca el link dado en pub.dev para colocarlo en las dependencias de pubspec.yaml
- ES Read-Only, por lo que se usa ChangeNotifierProvider para poder manipular el estado.
- Tambien se tiene: FutureProvider y StreamProvider.

``` yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
```
- Se envuelve a Material App principal (main.dart) con Provider.
- Se empieza a crear el estado con la propiedad create.
- El estado se accede por medio de:

``` dart
Widget build(BuildContext)
  print(Provider.of<TIPO DE DATO>(context))
```

- Busca el Provider mas cercano en el Widget Tree. 

### ChangeNotifierProvider
- Permite modificar el estado.
- Entonces, en lugar de envolver a Material App con Provider, se utiliza esta opcion.
- La opcion no acepta un tipo de dato generico.
  - Se debe usar ChangeNotifier().
    - VIene de Flutter, no de Provider.
    - Provee de una notificacion de cambio a lo que esta escuchando.
  - Se debe crear un ChangeNotifier personzalizado, por lo que se crea un nuevo archivo (cart_provider.dart).

``` dart
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> cart = [];

  void addProduct(Map<String, dynamic> product) {
    cart.add(product);
  }

  void removeProduct(Map<String, dynamic> product) {
    cart.remove(product);
  }
}
```

- La funcion de agregar al carrito se utiliza en el ElevatedButton ubicado en ProductsList.
  - El tipo del Provider sera CartProvider.
  - El producto no puede ser accedido en un stateful Widget, pero state provee de widget para poder acceder a elementos del constructor del Stateful Widget.
  - Ya que solo se esta llamando a una funcion, se debe colocar listen false.

``` dart
  onPressed: () {
  Provider.of<CartProvider>(context, listen: false)
      .addProduct(widget.product);
  },
```

- En un Stateful Widet el context se provee por State, por lo que context se mantiene el mismo en todo lado del Widget posibilitando su uso incluso fuera de la funcion build.
- De esta forma, se puede declarar la funcion de addProduct fuera de build para poder definir liste a false.
  - Por defecto esta en true, ya que eso indica que continuamente escucha los cambios.
- Por medio de ScaffoldMessenger y SnackBar se indica al usuario si el producto ha sido agregado de forma correcta o no.

``` dart
class _ProductDetailsState extends State<ProductDetails> {
  late int selectedSize;

  void onTap() {
    if (selectedSize != 0) {
      Provider.of<CartProvider>(context, listen: false).addProduct(
        {
          'id': widget.product['id'],
          'title': widget.product['title'],
          'price': widget.product['price'],
          'imageUrl': widget.product['imageUrl'],
          'company': widget.product['company'],
          'size': selectedSize
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a size!'),
        ),
      );
    }
  }


  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      minimumSize: const Size(double.infinity, 50),
    ),
    onPressed: onTap,
    child: const Row(
```

Para obtener los datos del estado en CartPage se utiliza Provider.

``` dart
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cart;
    return Scaffold(
      appBar: AppBar(
```

## InheritedWidget
- Se usa para State Management en Flutter.
- Crea una 'tienda' en el tope del arbol de Widgets, la cual es accesible en todos lados.

19:49:40
