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

# Notas
- Los nombres de los archivos debe ser en minúscula y separados por guión bajo para dejar espacio entre palabras.
- Un Widgfet no es más que una clase reutilizable que tiene cierta apariencia.
    - Todos los Widgets se crean de un Stateless Widget o Stateful Widget.