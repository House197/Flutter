# Dart
- Lenguaje del lado del cliente optimizado para aplicaciones.
    - Está optimizado para UI.
    - Permite Hot Reload.
    - Rápido en todas las plataformas (ARM y x64)
- Todos los elementos en Dart son objetos, por lo que se pueden usar métodos y propiedades en elementos como listas, iterable y mapas

# Características
- Futures, Async-Await, código non-blocking, Streams al abrirlo de la caja.
- Toda aplicación de Dart ejecuta una función inicial llamada main().
``` dart
void main() {

}
```
- Sintaxis familiar:
    - C#
    - Java
    - TypeScript

<img src='ImagenesNotas\ReactNvsFlutter.png'></img>

# Diferencia entre const y late
- Late asigna el valor a la variable en tiempo de ejecución.
- Const asigna el valor a la variable en tiempo de construcción.
- El uso de final al declarar variable es más rápido, ya que no viene la parte de los Setters para cambiar su valor.

# Variables
## Uso de ?
- Especifica que una variable puede ser nula.
``` dart
int? a = null;
```

## Listas
- Si no se especifica el tipo de datos de una lista entonces Dart lo infiere.

``` dart
final abilities = ['impostor']
```

- Se especifica el tipo usando <> antes del valor que se asigna. De igual forma, se puede colocar List<> antes del nombre de la variable.

``` dart
final abilities = <String>['impostor'];
final List<String>abilities = ['impostor'];
```

## Dynamic type
- Se recoienda su uso en llamadas API en donde se tienen varios campos y subcampos en el json para evitar tener que definir cada uno de ellos.
- Por defecto es null.

``` dart
// dynamic == null
dynamic errorMessage = 'Hola';
errorMessage = () => true;
errorMessage = null;
errorMessage = { 1,2,3,4,5,6 }
```

- Las variables definidas con dynamic siempre van a ser dynamic, nunca se va a inferir su tipo de datos.
- Se especifica el dato por medio de Map<datatypeKey, datatypeValue>

## Maps (objetos)
``` dart
void main() {
    final Map<String, dynamic> pokemon = {
        'name': 'Ditto',
        'hp': 10,
    };

    final Map<int, String> pokemon2 = {
        2: 'Ditto',
        3: '10',
    };

    print('Name: $pokemon["name"]')
}
```

- Se acceden a las propiedades por medio de ['key'] y no por punto, ya que con el punto se acceden a los métodos de los Maps.

# Estructuras de colecciones
## List, Iterables y Sets
- Con un objeto de lista se tiene la propiedad reversed, la cual retornar a un iterable con el contenido de la lista pero inverso.
- Algunos métodos de lista retornan iterables.

### Iterable
- Es una colección de elementos que se puede leer de manera secuencial.
- Es un objeto que puede contar elementos que se encuentran dentro de él, como listas, sets, arreglos, etc.
- Se usan paréntesis para encerrar a sus elementos.

``` dart
final iterableExample = (1,2,3,4);
```

- La diferencia con una lista es que con el iterable no se puede garantizar que leer elementos con índice será eficiente.

``` dart
Iterable<int> iterable = [1, 2, 3];
iterable[1]; // NO HACER
// Usar esto
int value = iterable.elementAt(1);
```

- Los iterables tienen su propio set de métodos que permiten barrer y controlarlo

``` dart
String element =
iterable.firstWhere(
 (element) => element.length > 5
);
```

### Set
- Su valores son únicos.
- Se usan {}

``` dart
final setExample = {1,2,3,4};
```

# Funciones y parámetros
- Se debe especificar el tipo de dato que retorna la función.
    - Si no se especifica entonces por defecto se le asigna dynamic.
- Se recomienda siempre seguir el tipado estricto en los parámetros de una función.

``` dart
int addTwoNumbers( int a, int b ) {
    return a + b;
}
```

## Lambda functions o arrow functions
- Se debe retornar inmediatamente:

``` dart
String greet() => 'Hello everyone!';

int addTwoNumbers( int a, int b ) => a + b;

```

## Parámetros opcionales
- El parámetro opcional debe envolverse entre llaves cuadradas [] y usar el operador ? para indicar que es un opcional.
    - En el cuerpo de la función se puede usar el operador de valor nulo ?? para asignarle valor al parámetro si es que es nulo

``` dart
int addTwoNumbersOptional( int a, [ int? b ] ) {
    b = b ?? 0;
    // También se pede usar: b ??= 0
    return a + b;
}
```

- Por otro lado, se puede asignar el valor por defecto directamente en la definición del parámetro.

``` dart
int addTwoNumbersOptional( int a, [ int b = 0 ] ) {
    return a + b;
}
```

## Parámetros con nombres
- En lugar de dependener del orden de definición de los parámetros **(parámetros posicionales)** para pasar valores, se pueden usar parámetros con nombre.
- Se envuelven los parámetros con {}, lo cual también indica que pueden ser opcionales.
- Se utiliza la palabra reservada **required** para los parámetros que sí son obligatorios.
- En esencia es como pasarle un diccionario al momento de invocar la función, solo que se omiten las llaves {}.

``` dart

void main() {
    print( greetPerson( name: 'A', message: 'Haa' ) ) // 'A, Haa'
}

int greetPersons({ required String name, String message = 'Hola'  }) {
    return '$message, $name';
}
```

# Clases
- Se usa la palabra reservada class para definir **clases**.
- Se puede colocar la palabra reservada **new** al momento de instanciar la clase, pero se recomienda obviarla.
- El constructor es la función de invocación que se llama al principio de la inicialización de una clase.
    - Debe tener el mismo nombre de la clase.
    - Se utiliza para asignarles valores a los atributos.
    - La palabra reservada this para los atributos hace referencia a los atributos definidos en la clase al momentos de usarlos en el constructor.
        - No siempre es necesario, ya que Dart deferencia cuándo se hace referencia a los atributos y cuándo se hace referencia a los argumentos.
    
- Para instanciar una clase se usa el operador de instancia ().

``` dart

void main() {
    final Hero spiter = Hero(name:'Spiter', power: 'web');

    print( spiter ); // Instance of 'Hero'
    print( spiter.name ); // Spiter
    print( spiter.power ); // web
}

class Hero {
    String name;
    String power;

    // Forma 1. La siguiente forma del constructor marca error, ya que al momento de instanciar ya es muy tarde para el constructor ejecutarse.
    Hero( String pName, String pPower) 
    {
        //this.name = pName;
        //this.power = pPoser
        name = pName;
        power = pPoser
    }

    // Forma 2. 
    Hero( String pName, String pPower) 
        : name = pName,
          poser = pPower;

    // Forma 3. Parámetros posicionales.
    Hero( this.name, this.power );

    // Forma 4. Más común, cear parámetros con nombres
    Hero({ required this.name, this.power = 'Sin poder'});
}
```

- Cuando un parámetro con nombre no es requerido se debe omitir la palabra reservada required y asignarle un valor por defecto.

## @override
``` dart

void main() {
    final Hero spiter = Hero(name:'Spiter', power: 'web');

    print( spiter ); // Hola Mundo
    print( spiter.name ); // Spiter
    print( spiter.power ); // web
}

class Hero {
    String name;
    String power;

    Hero({ required this.name, this.power = 'Sin poder'});

    String toString() { // The member 'toString' overrides an inherited member but isn't annotated with @override
        return 'Hola Mundo';
    }
}
```

- Aunque se tiene la advertencia por el método toString va a a funcionar, en donde hacer print a la instancia de la clase inmediatamente usa el método sin tener que llamarlo.
    - Se invoca de forma automática ya que con print se le maneja a la instancia como un strin automáticamente invoca el método.
    - Es buena práctica colocar @override para indicar que se está sobrescribiendo algo, así como para indicarle a terceras personas que se está haciendo un override.
    - No es obligatorio su uso, pero como se mencionó, su uso es buena práctica.
    - En este ejemplo, hacerle override a toString permite reemplazara 'Instance of ...' al momento de hacerle print a una instancia.

``` dart

void main() {
    final Hero spiter = Hero(name:'Spiter', power: 'web');

    print( spiter ); // Hola Mundo
    print( spiter.name ); // Spiter
    print( spiter.power ); // web
}

class Hero {
    String name;
    String power;

    Hero({ required this.name, this.power = 'Sin poder'});

    @override
    String toString() {
        return '$name - $power';
    }
}
```

## Constructores con nombre
- Se pueden tener múltiples constructores, y dependiendo de sus argumentos, se pueden crear instancias basadas en esos argumentos.
    - En otras palabras, es una forma de crear instancias con diferentes tipos de argumentos. (Similar en C# con el overload signature).
- En este ejemplo se toma como consideración crear instancias de la clase en función de una petición HTTP, en donde cabe la posibilidad que algunos de los campos requeridos venga como null.
    - Entonces, para evitar que usar ?? en cada argumento de la instancia para verificar si es null, se crea un constructor con nombre que reciba el objeto (la petición HTTP) y tenga toda la validación de crear ese objeto.
``` dart

void main() {

    final Map<String, dynamic> rawJson = {
        'name': 'Spiter',
        'power': 'web',
        'isAlive': true
    }

    final Hero spiter = Hero.fromJson( rawJson );

    //final Hero spiter = Hero(
    //    name: rawJson['name'] ?? 'default', 
    //    power: 'web', 
    //    isAlive: true
    //);

    print( spiter ); 
}

class Hero {
    String name;
    String power;
    bool isAlive;

    Hero({ required this.name, required this.power, required this.isAlive});
    // Constructor con nombre. En este casi se usa la forma corta (:) en lugar de usar {}
    Hero.fromJson( Map<String, dynamic> json )
        : name = json['name'] ?? 'No name found',
          power = json ['power'] ?? 'No power found',
          isAlive = json['isAlive'] ?? 'No isAlive found';

    @override
    String toString() {
        return '$name, $power isAlive ${ isAlive ? 'YES!' : 'Nope' }';
    }
}
```

- Para crear un constructor con nombre se le coloca el mismo nombre que la clase seguido de .nombreDeseado.
    - Del constructor se debe:
        1. Crear una instancia de la clase.
        2. Recibir la cantidad de argumentos que se desean.
- Al momento de invocar la clase, se debe colocar todo el nombre del constructor: (Hero.fromJson( rawJson ))
- Es buena práctica siempre manejar un campo de un json de una respuesta HTTP como posible null.

## Getters y setter
- Otorgan un mayor control en la manipulación de la información de una clase.
    - Permiten controlar la forma cómo establecer los valores.
- En el ejemplo se crear la clase de Cuadrado.
- Se tiene el parámetro de side.
- Se implementar varias restricciones:
    - Side no puede ser negativo.
    - Si no se tiene una propiedad
- Se definen propiedades privadas por medio de guión bajo.
    - Las propiedades privadas solo son accesibles en el scope de la clase.
    - Con propiedades privadas ya no se debe usar this en los parámetros del constructor, ya que ahora el constructor espera que se provea de argumentos para asignarlos a la variable privada.
- Por medio de la palabra reservada set se define una 'función', la cual se usa para cambiar el valor a la variable.
- Por medio de la palabra reservada get se define la propiedad de área, la cual retorna el cálculo del área.
    - No requiere de parámetros.


``` dart
void main () {
    final mySquare = Square( side: 10);

    print( 'área: ${ mySquare.area }' );
}

class Square {
    double _side;

    Square({ required double side })
        : _side = side;

    double get area {
        return _side * _side;
    }

    set side( double value ) {
        if( valaues < 0 ) throw 'Value must be greater than 0';
        _side = value;
    }

    double calculateArea() {
        return _side * _side;
    }
}
```

## Aserciones
- En el ejemplo anterior con set se establecen condiciones para evitar asignar valores inválidos a la propiedad side.
    - Estos no van a aplicar cuando se pasa el valor al instanciar la clase, ya que las condiciones están definidas solo para el setter.
- La aserciones son reglas de negocio.
- Se colocan en el constructor.
- Es buena práctica colocar las aserciones antes de las asignaciones, ya que si no se cumple una aserción no se ejecutan las siguientes líneas.
- Se definen con la palabra reservada assert.
    - En el primer argumento se coloca la condición.
    - El segundo argumento es opcional, y se utiliza para definir el mensaje de error.

``` dart
void main () {
    final mySquare = Square( side: 10);

    print( 'área: ${ mySquare.area }' );
}

class Square {
    double _side;

    Square({ required double side })
        : assert(side >= 0, 'side must be greater than 0'), 
        _side = side;

    double get area {
        return _side * _side;
    }

    set side( double value ) {
        if( valaues < 0 ) throw 'Value must be greater than 0';
        _side = value;
    }

    double calculateArea() {
        return _side * _side;
    }
}
```

## Clases abstractas y enumeraciones
- Las clases abstractas puede ver como un molde que se puede usar para crear otros moldes.
- Las clases abstractas no se pueden instanciar.
- En las clases abstractas no se debe colocar la implementación de los métodos, solo se define la signature.
    - De esta forma, cada que se extienda esta clase se tiene la obligación de implementar esos métodos en las clases que heredan.
- Se usan para aplicar diferentes patrones de arquitectura o patrones que se desean hacer a lo largo de la aplicación.
- Los enum permiten definir un conjunto de opciones.
    - No terminan con punto y coma.
    - Sus valores se definen como un set, en donde a partir del nombre del enum se define.
    - Cada que se define un enum se obtiene como tipo de dato especial.
    - Los atributos en la clase que lo ocupan se les debe definir con el tipo del enum, el cual corresponde con el nombre del enum definido.

``` dart
void main() {

}

enum PlantType { nuclear, wind, water }

abstract class EnergyPlant {
    double energyLeft;
    PlantType type;

    EnergyPlant({
        required this.energyLeft,
        required this.type
    });

    void consumeEnergy( double amount );

}
```

### Extends
- Permite heredar de otra clase.
- Al heredar una clase abstracta se heredan:
    - Constructor.
    - Atributos.
    - Los signature de los métodos.
- A modo de inicializar el constructor del padre se usa super.
    - Si se tuviera un constructor con nombre entonces a super se le agrega por medio de punto, p/e: super.
    - En los parámetros de super se inicializan las propiedades del padre.
    - El constructor de la clase hija no usa this, ya que como se vio con las propiedades privadas, los argumentos pasado al constructor se pasan al cuerpo para inicializar las propiedades deseadas.
    - Para los parámetros que son de un tipo ENUM no se requieren pedir al usuario, solo se definen en el argumento del constructor.
- En la implementación del método lo que tiene que ser igual es:
    - Tipo de dato de retorno.
    - Número de parámetros y el tipo (el nombre puede cambiarse).
    - Nombre del método.
- Al implementar los métodos es buena práctica colocar @override.

``` dart
void main() {
    final windPlant = WindPlant( initialEnergy: 100 );

    print( 'wind: ${ chargePhone( windPlant )}' ); // 90
}

// Ejemplo de uso de clases que heredan de una abstracta. Garantiza que puedan ser usadas en métodos más generales, ya que estas funciones esperan un tipo del tipo del clase deseada, por lo que se sabe de antemano qué estructura tiene esa clase.
double chargePhone( EnergyPlant plant ) {
    if( plant.energyPlant < 10 ) {
        throw Exception('Not enough energy');
    }

    return plant.energyLeft - 10;
}

enum PlantType { nuclear, wind, water }

abstract class EnergyPlant {
    double energyLeft;
    PlantType type;

    EnergyPlant({
        required this.energyLeft,
        required this.type
    });

    void consumeEnergy( double amount );

}

class WindPlant extends EnergyPlant {
    WindPlant({ required double initialEnergy })
        : super( energyLeft: initialEnergy, type: PlantType.wind);

    @override
    void consumeEnergy( double amount ) {
        energyLeft -= amount;
    }
}
```

- En el ejemplo anterior se define el método chargePhone (revisar comentario colocado en el código).
    - La idea de esa función es que aplique el principio de inversión de dependencias.
        - Esto quiere decir que fácilmente puede crearse otro tipo de planta de energía y esta función no va a ser afectada, ya que cada instancia de la clase que hereda de la clase abstracta presenta la misma estructura (métodos y atributos).
        - Se pueden depender de abstracciones, y así el código no sufra ninguna modificación a futuro.

### Implements
- Implements ayuda a colocar cada campo de la clase abstracta de forma explícita.
    - Con Extends, se definen los atributos propios de la clase que hereda, los cuales se pasan al constructor para inicializar los atributos de la clase abstracta.
    - Con Implements se definen directamente los campos de la clases abstracta, haciendo un @override.
- Implements y extends sirven para la herencia.
    - Cuando se desea que una clase implemente un método en lugar de heredar todo de otra clase, entonces se usa implements.
    - En otras palabras, implements ayuda a tomar secciones específicas de una clase abstracta en lugar de heredar todo.

``` dart
void main() {
    final windPlant = WindPlant( initialEnergy: 100 );
    final nuclearPlant = NuclearPlant( energyLeft: 1000 );

    print( 'wind: ${ chargePhone( windPlant )}' ); // 90
    print( 'nuclear: ${ chargePhone( nuclearPlant )}' ); // 990
}

// Ejemplo de uso de clases que heredan de una abstracta. Garantiza que puedan ser usadas en métodos más generales, ya que estas funciones esperan un tipo del tipo del clase deseada, por lo que se sabe de antemano qué estructura tiene esa clase.
double chargePhone( EnergyPlant plant ) {
    if( plant.energyPlant < 10 ) {
        throw Exception('Not enough energy');
    }

    return plant.energyLeft - 10;
}

enum PlantType { nuclear, wind, water }

abstract class EnergyPlant {
    double energyLeft;
    final PlantType type; // El Enum sugiere que este atributo podría cambiar, lo cual no es el caso. Por esa razón se le coloca final,
    // ya que una vez que se define qué tipo de planta es nunca va a cambiar.

    EnergyPlant({
        required this.energyLeft,
        required this.type
    });

    void consumeEnergy( double amount );

}

class WindPlant extends EnergyPlant {
    WindPlant({ required double initialEnergy })
        : super( energyLeft: initialEnergy, type: PlantType.wind);

    @override
    void consumeEnergy( double amount ) {
        energyLeft -= amount;
    }
}

// Sección de implements
class NuclearPlant implements EnergyPlant {
    @override
    double energyLef;
    
    @override
    final PlantType type = PlantType.nuclear;

    NuclearPlant({ required this.energyLeft });

    @override
    void consumeEnergy( double amount ) {
        energyLeft -= (amount * 0.5);
    }
}
```

## Mixins
- Permite definir clases especializadas que cumplan con una condición en particular.
- En Dart cada clase (a exepción de Object) tiene exctamente una superclase.
- Los Mixins son una manera de reutilizar el códi de una clase en múltiples jerarquías de clase.
- Restricciones a partir de Dart 3.0
    - Mixins no pueden declarar un constructor.
    - Mixins no pueden extenders clases u otros Mixins.

<img src='Udemy\Images'></img>

- Los Mixins permiten definir la 'especialización' de la clase correspondiente.
    - Se pueden ver como un nivel de especialización de la clase.
- Se definen por medio de clases abstractas, en donde los métodos se implementan directamente.
- Se especifican en la clase deseada por medio de la palabra reservada **with**.
    - Si se tienen varios Mixins, se empiezan a enlistar con coma después de la palabra reservada **with**.

``` dart
abstract class Animal {}

abstract class Mamifero extends Animal {}
abstract class Ave extends Animal {}
abstract class Pez extends Animal {}

abstract class Volador {
    void volar() => print('estoy volando!');
}

abstract class Caminante {
    void caminar() => print('estoy caminando!');
}

abstract class Nadador {
    void nadar() => print('estoy nadando!');
}

// Delfin es un mamifero, pero puede nadar.
class Delfin extends Mamifero with Nadador {}

// Miercilago es un mamifero, pero puede volar Y caminar.
class Murcielago extends Mamifero with Volador, Caminante {}

// Gato es mamifero, pero puede caminar.
class Gato extends Mamifero with Caminante {}


//Paloma es una ave. Puede caminar y volar.
class Paloma extends Ave with Caminante, Volador {}

// Pato es una ave. Puede volar, caminar Y nadar.
class Pato extends Ave with Caminante, Volador, Nadador {}


// Tiburón es un Pez. Puede nada
class Tiburon extends Pez with Nadador {}

// Pez Volador es un Pez Puede nadar y volar
class FlyingFish extends Pez with Nadador, Volador {}


void main() {
    final flipper = Delfin();
    // Delfín tiene acceso a los métodos de Nadador
    flipper.nadar(); // estoy nadando!

    final batman = Murcielago();
    batman.volar();
    batman.caminar();

    final namor = Pato();
    namor.caminar();
    namor.volar();
    namor.nadar();
}

```

# Future
- Representa el resultado de una operación asíncrona.
- Son un acuerdo de que en el futuro se tendrá el valor para ser usados.
- Es una promesa, así como en JavaScript.
    - La promesa puede fallar, por lo que se debe manejar la exepción.
- Se puede generar de varias maneras (con funciones, objetos). 
    - En el ejemplo se crea por medio de la simulación de una petición HTTP GET.
- Se tiene el tipo de objeto **Future**, el cual puede ser cualquier valor (Future<dynamic>).
- La palabra reservada Futuro presenta ciertos objetos y métodos.

``` dart
void main() {

    print('Inicion del programa');

    print('Fin del programa');
}

Future<String> httpGet( String url ){

    return Future.delayed();

}
```