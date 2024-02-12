# Flutter
- Es un SDK portable - Open source framework - UI Widget Library.
- Está inspirado en React.
- Se utiliza para crear hermosas aplicaciones compiladas de forma natriva, multi-plataforma con un único código base.
- Cuando se crea un widget que puede tener utilidad para la comunidad se puede empaquetar y subir a pub.dev.
- Pub-dev es un repositorio de varios paquetes que la comunidad sube.
- Con Flutter se pueden crear aplicaciones para Web, Windows, Linux y Mac. Así como iOS, Android y embebido.
    - Estose puede hacer con un solo código base.
    - Se recomienda hacer un código base tanto para:
        - Web.
        - Windows, Linux y Mac.
        - iOS y Android.
        - Embebido.
    - Hacer esto garantiza evitar problemas de compatibilidad, ya que si se desea solo para iOS puede que haya problemas de compatibilidad para la Web o demás opciones.

# Hello World App
- Se presiona CTRL + SHIFT + P para abrir la terminal y poder seleccionar Flutter: Create Project.

## Explicación de archivos
### Carpeta .dart_tool
- La carpeta es usada por "Pub", es un CLI.
- Se puede ver como una forma de dar seguimiento a los paquetes.
- Usualmente solo tiene configuraciones usadas por los paquetes y configuraciones de Dart para el proyecto.
- No es requerido manipular la carpeta.

### Carpeta .idea
- Contiene las configuraciones recomendadas si se desea trabajar con "IntelliJ IDEA"
- No es requerido manipular la carpeta, ya que no se está trabajando con ese editor de código o ese IDE.
- Se exluye del gitignore por defecto.

### Carpeta Android
- Se puede ver como una carpeta macro. Es básicamente la aplicación de Android.
- Físicamente es el código de Android en el cual están los códigos de Java y Kotlin.
- Se modifica si se desean ciertas configuraciones en la aplicación de Flutter en Android.
    - Por ejemplo, el uso de la cámara.

### Carpeta ios
- Es básicamente un proyecto de Xcode.
- Se hace el build para iOS, el cual va a crear archivos necesarios para correr la aplicación en iOS directamente, ya sea en el simulador usando Xcode y para publicar la aplicación en la Apple App Store.

### Carpeta lib
- Carpeta en donde más se trabaja.
- Contiene el código fuente personalizado por el usuario.

### Carpeta linux, macos, web, windowsñ
- Es lo mismo que con iOS y Android.

### Carpeta test
- Se recomienda ir creando la misma estructura que en lib para hacer el testing automático de la aplicación.

### Archivo .metadata
- Le da seguimiento a las propiedades del proyecto.
- Se usa por Flutter tool.
- Permite hacer comparaciones y análisis del proyecto.
- No se edita manualmente.

### Archivo analysis_options.yaml
- Configura el analyzer.
- Se usa para analizar o indicarle a Dart cómo analizar el código.
- También ayuda a configuraciones del linter.

### Archivo hello_world_app.iml
- Es utilizado por los proyectos IntelliJ IDEA.

### Archivo pubspec.lock
- Da seguimiento a las versiones del proyecto contra versiones más recientes que se acaban de desplegar.
- No se edita manualmente.
- Da seguimiento a las dependencias del proyecto.
- Permite instalar dependencias cuando se descarga el proyecto de lugares como GitHub.

### Archivo pubspec.yaml
- Es un archivo que se visita periódicamente.
- Es un archivo de configuración.
- Cuando se edita qse ejecuta un proceso en automático para revisar si hay una nueva dependencia o si se elimina una para poder actualizar pubspec.lock y también el dart_tool.

## main.dart
- Es el archivo en donde se encuentra el código para correr la app.
- Toda aplicación de Dart empieza con una función main.
- En Flutter la función main ejecuta un Widget Inicial. Entonces, la función main es el punto de antrada para la aplicación.
    - Esto se realiza con el comando runApp();
- runApp recibe el Widget de entrada, el cual debe ser MaterialApp.

## Scaffold
- Implement aun diseño básico de material, y de las bases para coloca run menú lateral, snack-bars, appbars, bottom sheets y más elementos.
- Puede verse como una nueva pantalla, por lo que debe estar desenlazado de Material App.
- Permite aplicar un botón por medio de floatingActionButton.

## Material App
- Se puede quitar debug por medio de campo debugShowCheckedModeBanner con un valor de false.

## Column
- La razón por la que Column no puede ser const es porque Column, así como otros Widgets, necesitan saber las dimensiones del dispositivo para poder determinar específicamente en runtime esas dimensiones.
- La palabra const se puede colocar en la lista de los Widgets que va a mostrar la columna.
    - De igua manera, se puede colocar en los Widgets que lo requieran dentro de la lista en lugar de a toda la lista.

## Estructura de directorios (estructura de filesystems)
- No es obligatorio seguir la siguiente estructura.
- Folde Presentation: se colocan los Widgets visuales
    - Subfolder screens: son widgets que cubren toda la pantalla.
    - Los Screens van a llevar sus Scaffolds.
    - Cada archivo termina con el nombre _screen.dart


## ThemeData
- Se define en Material App con el campo de theme.
- No es constante porque el tema va a variar dependiendo del dispositivo, ya que hay configuraciones como Light o Dark, los cuales no se conocen de antemano cuál usa el usuario.

### Material Design 3
- Dentro de ThemeData se usa useMaterial3.

### colorSchemeSeed
- Permite definir un color del cual Flutter se encarga de formar la paleta de colores.

## Cambiar estado
- Se tiene el concepto de estado global, el cual es accesible por todos los Widgets en el árbol de Widgets.
- Por otro lado, se tiene el estado de Widget el cual es accesible por todos los Widgets hijos.
- Se debe usar StatefulWidget para crear un estado en un Widget.
    - Este Widget permite mantener un estado interno y ciclo de vida como su inicialización y destrucción.

### StatefulWidget.
- Se compone de dos clases.
- La primera clase es la que extiende de StatefulWidget.
- Maneja el método createState.
    - Esa creación de estado no es más que la invocación de otra clase, la cual corresponde con la segunda clase.
- La segunda clase es la construcción del Widget que se tenía hasta el momento antes de convertirlo en Stateful.
    - Esta clase extiende de State, y la va a manejar el CounterScreen en este ejemplo.
    - Se define el estado como una variable cualquiera, solo que no se coloca const o final.
    - Al momento de actualizar el estado no hace falta usar this 'this.clockCounter', pero sí haría falta si hubiese una variable interna en el scope de la función que compartiera nombre con un atributo de la clase, por lo que this ayudaría a especificar que se desea usar el atributo en lugar de la variable interna del scope de la función.
- Cada que cambia el estado se debe indicar a Flutter que renderice el widget. 
    - Se usa setState.
        - No hace falta colocar la actualización del estado dentro del callback de setState.
- Flutter es eficiente al saber qué se debe renderizar, es decir, lo que fue afectado por el cambio, por lo que no todo el widget se renderiza, solo la parte afectada.
# Notas
- Los nombres de los archivos debe ser en minúscula y separados por guión bajo para dejar espacio entre palabras.
- Un Widgfet no es más que una clase reutilizable que tiene cierta apariencia.
    - Todos los Widgets se crean de un Stateless Widget o Stateful Widget.
- Se debe usar la palabra reservada constpraa los Widgets que jamás van a cambiar.
    - Flutter crea un código especial que está encapsulado de tal manera que no va a poderse modificar.
    - No se modifica desde su construcción. Entonces, mejora el rendimiento de la aplicación al tener Widgets que jamás van a cambiar por lo que Flutter los reconstruye rápidamente cuando toque reconstruir la aplicación.
    - Puede verse como un lego, en donde los Widgets const ya son piezas pegadas, mientras que los Widgets que sí cambian son piezas individuales que se deben pegarse uno por uno.
- El child siempre va al final de cada Widget.
- No se puede usar if else en el return del Widget, solo if.