# Table of Contents
1. [Dart](#Dart)
    1. [Clases](#Classes)
        1. [Constructores](#Constructores)    
        2. [Variables privadas](#PrivateVariables)
        3. [Getters y Setters](#GettersSetters)
        4. [Funciones y variables estáticas](#StaticFunctionsVariable)
        5. [Herencia](#Inheritance)
        6. [Override](#Override)
        7. [Implements](#Implements)
        8. [Clases Abstractas](#AbstractClasses)
        9. [Mixin y With](#Mixin-With)
        10. [Object](#Object)
        11. [Class Modiffiers](#ClassModifiers)
    2. [Listas](#Listas)
        1. [Métodos](#Métodos)
            1. [Add](#add)
            2. [Insert](#insert)
            3. [Remove](#remove)
            4. [Filter](#filtrado)
    3. [Map (diccionario)](#Map)
        1. [Lista de objetos](#ListMaps)
        2. [Métodos](#Métodos)
            1. [Add All](#addAll)
            2. [Remove](#RemoveMap)
            3. [Keys y ToList](#KeysToList)
            4. [For Each](#forEachMaps)
            5. [Map](#mapFunc)
    4. [Enums](#Enums)
        1. [Enhanced Enums](#EnhancedEnums)
    5. [Exception Handling](#TryCatch)
    6. [Future (Promises)](#Promises)
    7. [Llamados a API](#LlamadosAPI)
    8. [Streams](#Stream)
        1. [Stream Controller](#StreamController)
    9. [Records](#Records)
        1. [Pattern Matching (uso para clsaes)](#PatternMatching)
    10. [Variables](#Variables)
    
2. [Flutter](#Flutter)

# Dart <a id="Dart"></a>
## Classes <a id="Clases"></a>
- Se usa la palabra reservada class para definir a una clase.
- La convención para una función o variables es camelCase, pero para una clase se usa la notación PascalCase.
- Se definen propiedades usando variables.
- Se crea una instancia de una clase al invocar la clase con ().
     - El tipo de dato que se define a la variable es el nombre de la clase o usar **final**.
- Se pueden acceder a los métodos y atributos de la clase con la notación de punto. 
- No es necesario usar la palabra reservada new para crear un clase, ya que Dart ya allocate memoria cada que se crea una instancia de clase a diferencia de Java.

``` Dart
void main() {
    Cookie cookie = Cookie();
    print(cookie.shape);
    cookie.baking();
    final isCookieCooling = cookie.isCooling();
    print(isCookieCooling);
}

class Cookie {
    // variables
    String shape = 'Circle';
    double size = 15.2; // cm

    // method
    void baking() {
        print('Baking has started');
    }

    bool isCooling() {
        return false;
    }
}
```

### Constructores <a id="Constructores"></a>
- Se utiliza para poder personalizar la instancia de la clase.
- No se requiere mencionar el tipo de dato del valor que retorna.
- Debe llevar el mismo nombre de la clase.
- Se coloca en el nivel superior de la clase.
- Debido al Scope de las funciones, los atributos se deben definir antes del constructor.
- Si no se usa this dentro de los parámetros del constructor entonces éste crearía nuevas variables.
- A diferencia de lenguajes como Python, en este caso basta solo con definir los parámetros del constructor para poder personalizar la instancia de la clase.
    - Por otro lado, es posible no usar this en los parámetros de los argumentos y definir nuevas variables, las cuales deben asignarse a los atributos como se muestra en el segundo código.

``` Dart
void main() {
    final cookie = Cookie('Hello', 20);

    print(cookie.shape);
    print(cookie.size);
    
}

class Cookie {
    // Atributes
    // Se usa ? para especificar que también puede ser null.
    String? shape;
    double? size;

    Cookie(this.shape, this.size) {
        print('Baking has started.')
    }

    // method
    void baking() {
        print('Baking has started');
    }

    bool isCooling() {
        return false;
    }
}
```

``` Dart
void main() {
    final cookie = Cookie('Hello', 20);

    print(cookie.shape);
    print(cookie.size);
    
}

class Cookie {
    // Atributes
    // Se usa ? para especificar que también puede ser null.
    String? shape;
    double? size;

    Cookie(String shape, double size) {
        this.shape = shape;
        this.size = size;
    }

    // method
    void baking() {
        print('Baking has started');
    }

    bool isCooling() {
        return false;
    }
}
```

- Los código anteriores permiten modificar los atributos usando la notación punto, lo cual no es recomendable.
    - Se puede solucionar colocan final al momento de definir a los atributos, lo cual formaría una clase inmutable una vez que se crea la instancia y se personaliza con el constructor.
    - Se igual forma se puede usan métodos y setters (esto no se coloca en el siguiente código).

``` Dart
void main() {
    final cookie = Cookie('Hello', 20);

    cookie.shape = 'Rect';
}
```

``` Dart
void main() {
    final cookie = Cookie(shape: 'Hello', size: 20);

    print(cookie.shape);
    print(cookie.size);
    
}

class Cookie {
    // Atributes
    // Se usa ? para especificar que también puede ser null.
    final String shape;
    final double size;

    Cookie({required this.shape, required this.size}) {
        this.shape = shape;
        this.size = size;
    }

    // method
    void baking() {
        print('Baking has started');
    }

    bool isCooling() {
        return false;
    }
}
```

### Private variables <a id="PrivateVariables"></a>
- Son variables que solo son accesibles dentro de la clase.
- Se definen con _.
- En Dart, las variables privadas lo son para un archivo, no son privadas solo para una clase.
    - Entonces, no importa que se defina una variabla privada dentro de la clase, será accesible dentro de todo el archivo.

``` Dart
void main() {
    final cookie = Cookie(shape: 'Hello', size: 20);

    print(cookie.shape);
    print(cookie.size);
    
}

class Cookie {
    // Atributes
    // Se usa ? para especificar que también puede ser null.
    final String shape;
    final double size;

    Cookie({required this.shape, required this.size}) {
        this.shape = shape;
        this.size = size;
    }

    // Private variables
    int _height = 4;
    int _width = 5;

    // method
    int calculateSize() {
        return _height*_width
    }
}
```

### Getters y Setters <a id="GettersSetters"></a>
- Se utilizan para retornar un valor.
- Al usar getter, se debe colocar la palabra reservada get.
- Al usar setter, se coloca la palabra reservada set.

``` Dart
void main() {
    final cookie = Cookie(shape: 'Hello', size: 20);

    print(cookie.height); // Acá se llama al getter.
    cookie.setHeight = 15;
    print(cookie.size);
    
}

class Cookie {
    // Atributes
    // Se usa ? para especificar que también puede ser null.
    final String shape;
    final double size;

    Cookie({required this.shape, required this.size}) {
        this.shape = shape;
        this.size = size;
    }

    // Getters
    int get height => _height;

    // Setters
    set setHeight(int h) {
        _height = h;a
    }

    // Private variables
    int _height = 4;
    int _width = 5;

    // method
    int calculateSize() {
        return _height*_width
    }
}
```

### Static functions and Static variables <a id="StaticFunctionsVariable"></a>
- Las variables estáticas pueden ser accedidas como método de clase y no de instancia.
- No hace falta instancias la clase, por lo que el constructor tampoco será llamado.
- Ayudan a guardar memoria ya que no se deben instanciar las clases.
- Al declarar atributos no es posible seguir este enfoque, ya que los miembros de instancia no pueden ser accedidos desde métodos estáticos. 
    - Los atributos de clase se inicializan cuando se crea una instancia.

``` Dart
void main() {
    print(Constants.greeting);
    print(Constants.bye);
}

class Constants {
    static String height = 10;
    static String greeting = 'Hello';
    static String bye = 'Bye'

    static int giveSomeValue() {
        return height;
    }
}
```

### Herencia <a id="Inheritance"></a>
- Se permite heredar de una clase.
- Se utiliza la palabra reservada extends.
    - Una clase solo puede heredar una vez, no se puede aplicar extends más de una vez sobre una clase.
    - En Dart esto se debe a que de las dos clases que se desea heredar hay probabilidad de que puedan compartir algunos atributos, por lo que el compilador no sabe cuál debería tomar de esas opciones.

``` Dart
void main() {
    Car car = Car();

    print(car.isEngineWorking);
    print(car.noOfWheels);
}

class Vehicle { 
    int speed = 10;
    bool isEngineWorking = false;
    bool isLightOn = true;

    void accelerate() {
        speed+=10;
    }
}

class Car extends Vehicle {
    int noOfWheels = 4;

    void printSomething() {
        print(noOfWheels);
    }
}
```

- Al instanciar la clase de Car se usó el tipo Car, sin embargo, también es posible usar el tipo Vehicle.
    - Al hacer esto, cuando se intenta acceder a los atributos de car se debe usar la palabra reservada **as** y especificar el tipo de dato de la clase correspondiente.

``` Dart
void main() {
    Vehicle car = Car();

    print((car as Car).isEngineWorking);
    print((car as Car).noOfWheels);
}
```

#### Override <a id="Override"></a>
- En caso de que una case posea un mismo método que de la clase que hereda pero se desea modificar, entonces se puede usar @override.

``` Dart

class SomeClass {
    int speed = 10;

    void accelerate() {
        speed+=30;
    }
}

class Vehicle extends SomeClass { 
    int speed = 10;
    bool isEngineWorking = false;
    bool isLightOn = true;

    @override
    void accelerate() {
        speed+=10;
    }
}

```

- Es posible modificar el contenido de la clase padre en la subclase usando super, el cual solo está disponible cuando se usa extends.

``` Dart
class Vehicle { 
    int noOfWheels = 10;
    bool isEngineWorking = false;
    bool isLightOn = true;

    void accelerate() {
        print('accelerating');
    }
}

class Car extends Vehicle {
    @override
    void accelerate() {
        super.accelerate();
        super.isEngineWorking = true;
        print('accelerating the car');
    }
}
```

#### Implements <a id="Implements"></a>
- Se usa la palabra reservada implements.
- Permite obtener todas las propiedades que se desean implementar, por lo que no se tiene acceso a super.
- Implements puede se usado si se desea crear una implementación propia de otra clase o interfaz.
    - Cuando la clase a implementa clase b, todas las funciones definidas en clase b deben ser implementadas.
    - Cuando se implementa otra clase, no se hereda el código de la clase, solo se hereda el tipo.

```
Every class implicitly defines an interface containing all the instance members of the class and of any interfaces it implements. If you want to create a class A that supports class B’s API without inheriting B’s implementation, class A should implement the B interface.
```

``` Dart
class Vehicle { 
    int noOfWheels = 10;
    bool isEngineWorking = false;
    bool isLightOn = true;

    void accelerate() {
        print('accelerating');
    }
}

class Car implements Vehicle {
    @override
    bool isEngineWorking = true;

    @override
    bool isLightOn = true;

    @override
    int noOfWheels = 4;

    @override
    void accelerate() {
        print('accelerating the car');
    }
}

class Truck implements Vehicle {
    @override
    bool isEngineWorking = true;

    @override
    bool isLightOn = true;

    @override
    int noOfWheels = 6;

    @override
    void accelerate() {
        print('accelerating the truck');
    }
}
```

- En este código no se puede usar super, ya que el método accelerate (por ejemplo) siempre es abstracto en el supertype.

#### Abstract Classes <a id="AbstractClasses"></a>
- Se usa la palabra reservada abstract.
- Con Abstract no se requiere definir el bloque de código del método, solo especifica su nombre.
- Si se usa extends con una clase abstracta dará error, ya que se debe sobrescribir los métodos para definir el bloque de código.

``` Dart
abstract class Vehicle { 
    void accelerate();
}

class Car implements Vehicle {
    @override
    void accelerate() {
        print('accelerating the car');
    }
}
```
### Mixin with <a id="Mixin-With"></a>
- No establece una relación de padre e hijo.

``` Dart
void main() {
    final anim = Animal();

    anim.fn();
}

mixin Jump {
    int jumping = 10;
}

class Animal with Jump {
    void fn() {
        print(jumping);
    }
}

class Cat extends Animal {
    // Cat puede accede a Jump, ya que Animal también puede.
    void fn() {
        print(jumping);
    }
}
```

### Object <a id="Object"></a>
- Es clase base para todo en Dart a exepción de null.

``` Dart
void main() {
    Object anim = 105;
}
```

### Class Modifiers <a id="ClassModifiers"></a>
sealed
final
base
interface
mixin

## Listas <a id="Listas"></a>
- Se usa la palabra reservada List.
- Las listas almacenan tipos dinámicos.

``` Dart
void main() {
    List list = [1,4,6];

    print(list[2]);
}
```

- Se puede especificar que una lista solo tendrá un tipo de dato usando <> (generics <T>).

``` Dart
void main() {
    List<double> list = [1,4,6];

    print(list[2]);
}
```

### Métodos <a id="Métodos"></a>
#### add <a id="add"></a>
- Permite agregar elementos a una lista en la última posición.

``` Dart
void main() {
    List<Student> students = [
        Student('Rivaan'),
        Student('Naman'),
        Student('Rakesh')
    ];

    print(students);

    students.add(Student('New Kid'));

    print(students);

}

class Student {
    final String name;

    Student(this.name);

    // Se pueden sobrescribir métodos definidos por Dart usando override
    @override
    String toString = () => 'Student: $name';
}
```

#### insert <a id="insert"></a>
- Permite agregar elementos a un lista en la posición deseada.
- El primer argumento es el índice en donde se va a insertar el elemento, el cual se especifica en la segunda posición.

``` Dart
void main() {
    List<Student> students = [
        Student('Rivaan'),
        Student('Naman'),
        Student('Rakesh')
    ];

    print(students);

    students.insert(2, Student('New Kid'));

    print(students);

}

class Student {
    final String name;

    Student(this.name);

    // Se pueden sobrescribir métodos definidos por Dart usando override
    @override
    String toString = () => 'Student: $name';
}
```

#### remove <a id="remove"></a>
- Permite quitar elementos de una lista.
- Ya que en este ejemplo se están usando instancias de clase para llenar la lista, se guarda en una variable la referencia de la clase a eliminar para poder usarla.


``` Dart
void main() {
    // Se guarda la referencia de la instancia de la clase en una variable.
    final rivaanStudent = Student('Rivaan');

    List<Student> students = [
        rivaanStudent,
        Student('Naman'),
        Student('Rakesh')
    ];

    print(students);

    students.insert(2, rivaanStudent);

    print(students);

}

class Student {
    final String name;

    Student(this.name);

    // Se pueden sobrescribir métodos definidos por Dart usando override
    @override
    String toString = () => 'Student: $name';
}
```

#### Filtrado <a id="filtrado"></a>
##### Usando for in

``` Dart
void main() {

    List<Student> students = [
        Student('Rivaan', 12),
        Student('Naman', 5),
        Student('Rakesh', 20)
    ];

    List<Student> filteredStudents = [];

    for(final student in students) {
        if(student.marks >= 20) {
            filteredStudents.add(student)
        }
    }

}

class Student {
    final String name;
    final int marks;

    Student(this.name, this.marks);

    // Se pueden sobrescribir métodos definidos por Dart usando override
    @override
    String toString = () => 'Student: $name';
}
```

##### Usando where

``` Dart
void main() {

    List<Student> students = [
        Student('Rivaan', 12),
        Student('Naman', 5),
        Student('Rakesh', 20)
    ];

    final filteredStudents = student s.where((student) => student.marks >= 20);

    print(filteredStudents.toList());
}

class Student {
    final String name;
    final int marks;

    Student(this.name, this.marks);

    // Se pueden sobrescribir métodos definidos por Dart usando override
    @override
    String toString = () => 'Student: $name';
}
```

## Map (Objetos o diccionarios) <a id="Map"></a>
- Si no se especifica el tipo de dato se le asingna dynamic tanto a la llave como el valor.
- Se usa null operator (?) para poder usar los métodos del tipo de dato del valor de map, ya que existe la posibilidad de que se accede a una key que no existe.

``` Dart
void main() {
    Map marks = {
        'Rivaan': 10,
        'Naman': 15,
        'student': 4,
    };

    print(marks['student']);
}
```

- Se puede asignar el tipo de dato de la siguiente manera:

``` Dart
void main() {
    Map<String, int> marks = {
        'Rivaan': 10,
        'Naman': 15,
        'student': 4,
    };

    print(marks['student']?.isEven); // Se usa null operator para poder acceder a los métodos del tipo de dato que se usa.
}
```

### Lista de objetos <a id="ListMaps"></a>

``` Dart
void main() {
    List<Map<Strubgm int>> marks = [
        {
            'Math': 26;
            'CS': 30;
            'English': 15;
        },
                {
            'Math': 16;
            'CS': 10;
            'English': 20;
        },
    ];
}
```

### Métodos <a id="Métodos"></a>
#### addAll <a id="addAll"></a>
- Es un método que también está disponible para listas.
- Permite insertar valores, siendo en este caso definiendo un diccionario en el argumento.

``` Dart
void main() {
    Map<String, int> marks = {
        'Rivaan': 10,
        'Naman': 15,
        'student': 4,
    };

    marks.addAll({
        'student2': 10,
        'student3': 30
    })

    print(marks['student']?.isEven); // Se usa null operator para poder acceder a los métodos del tipo de dato que se usa.
}
```

#### remove <a id="RemoveMap"></a>
- Permite eliminar elementos tanto de listas como de maps.
- Se requiere pasarle la llave.

``` Dart
void main() {
    Map<String, int> marks = {
        'Rivaan': 10,
        'Naman': 15,
        'student': 4,
    };

    marks.remove('Rivaan')

    print(marks['student']?.isEven); // Se usa null operator para poder acceder a los métodos del tipo de dato que se usa.
}
```

#### keys y toList <a id="KeysToList"></a>
- Keys retorna las llaves del objeto.
- En conjunto con toList, se convierte en una lista iterable a las llaves retornadas por keys.

``` Dart
void main() {
    Map<String, int> marks = {
        'Rivaan': 10,
        'Naman': 15,
        'student': 4,
    };

    for(int i=0; i<marks.keys.length; i++){
        print(marks.keys.toList()[i]);
    }

}
```

#### forEach <a id="forEachMaps"></a>
- Permite iterar objetos.

``` Dart
void main() {
    Map<String, int> marks = {
        'Rivaan': 10,
        'Naman': 15,
        'student': 4,
    };

    marks.forEach((key, val) {
        print('$key: $val');
    })
}
```

#### map <a id="mapFunc"></a>
- Permite iterar en los elementos de una lista.

``` Dart
void main() {
    List<Map<Strubgm int>> marks = [
        {
            'Math': 26;
            'CS': 30;
            'English': 15;
        },
                {
            'Math': 16;
            'CS': 10;
            'English': 20;
        },
    ];

    marks.map((e) {
        e.forEach((key, val) {
            print('$key: $val'); 
        })
    }).toList();
}
```

## Enums <a id="Enums"></a>
- Guardan una lista de posibles opciones a utilizar en el programa.
- En el siguiente ejemplo se utiliza para limitar la cantidad de opciones que se pueden asignar a los argumentos de una clase al inicializarla.

``` Dart
void main() {
    final employee1 = Employee('Rivaan', EmployeeType.swe);
    final employee2 = Employee('Rivaan', EmployeeType.finance);

}

enum EmployeeType {
    swe,
    finance,
    marketing
}

class Employee {
    final String name;
    final EmployeeType type;

    Employee(this.name, this.type);
}
```

### Enhanced Enums <a id="EnhancedEnums"></a>
- Se introdujeron en la versión 3.0 o 3.0.1.
- Permite pasar atributos a las opciones definidas por enums.

``` Dart
void main() {
    final employee1 = Employee('Rivaan', EmployeeType.swe);
    final employee2 = Employee('Rivaan', EmployeeType.finance);

}

enum EmployeeType {
    swe(200000),
    finance(250000),
    marketing(150000);

    final int salary;
    const EmployeeType(this.salary);
}

class Employee {
    final String name;
    final EmployeeType type;

    Employee(this.name, this.type);

    void fn() {
        switch(type) {
            case EmployeeType.swe:
                print(type.salary);
            case EmployeeType.finance:
                print(type.salary);
            case EmployeeType.marketing:
                print(type.salary);
        }
    }
}
```

## Exception Handling (try catch) <a id="TryCatch"></a>

``` Dart
void main() {
    try{
        print(10~/3); // da 3.
        print(10~/0);
    } catch(e) {
        print(e);
    } finally {
        // Este bloque siempre se va a ejecutar.
    }
}
```

## Futures (Promises) <a id="Promises"></a>
- Se usa la palabra reservada Future en conjunto con async.
    - Si se usa Future<void> entonces los eventos asíncronos se disparan y se escucha hasta que terminen.
    - (Investigar más sobre esto) Si solo se usa void entonces los eventos asíncronos se disparan pero el programa los olvida.
- Se especifica el tipo de dato que Future retorna con <>.
- async se puede omitir si se retorna un Future.
    - Async solo se usa cuando se desea usar la palabra reservada await.

``` Dart
Future<void> main() async {

    final result = await giveResultAfter2Sec();



    print('1');
    print('2');
    print('3');
}

Future<String> giveResultAfter2Sec() {
    return Future(() {
        return 'Hey';
    }) 
}
```

- Se puede colocar un delay a Future.
- Si no se desea usar await entonces se puede usar then.

``` Dart
void main() {

    giveResultAfter2Sec().then((val) {
        print(val);
    })



    print('1');
    print('2');
    print('3');
}

Future<String> giveResultAfter2Sec() {
    return Future.delayed(Duration(seconds: 2), () {
        return 'Hey'; 
    })
}
```

## Llamados a API <a id="LlamadosAPI"></a>
- En dart se tiene el paquete http 0.13.6.
- Se puede leer más de esto en pubspec.yaml.
- En Dart Pad se puede usar de la siguiente manera.

``` Dart
import 'package:http/htpp.dart' as http;
import 'dart:convert'; // Se usa para usar jsonEncode o jsonDecode en la respuesta de la API.

void main() async {
    var url = Uri.https('jsonplaceholder.typicode.com', 'users')
    // o var url = Uri.https('jsonplaceholder.typicode.com', 'users/1')

    try {
        final response = await http.get(url);

        print(jsonDecode(res.body as Map));
    } catch(e) {
        print(e);
    }

}

```

- En el ejemplo anterior, se está obteniendo un arreglo en la respuesta de la API, por lo que se trata al resultado como as Map para indicar que se trata de un arreglo. En caso de que se obtiene un objeto en la respuesta, jsonDecode funcionaría sin usar as.

## Stream <a id="Stream"></a>
- Permite suscribirse a eventos. Es un generador asíncrono.
- Para retornar se debe usar la palabra reservada yield.
    - Esto es en el caso de usar async, pero se puede retornar solo un STREAM si no se coloca async.
``` Dart
Stream<int> countDown() {
    return Stream.periodic(Duration(seconds: 1), (val) {
        return val;
    });
}
```
- Se debe usar async en conjunto con el símbolo *.
    - El objeto que se retorna posee varias propiedades para leer los valores que se retornan.
    - Se usa el método listen para tener una stream subscription.

``` Dart
import 'package:http/htpp.dart' as http;
import 'dart:convert'; // Se usa para usar jsonEncode o jsonDecode en la respuesta de la API.

void main() async {
    countDown().listen((val) {
        print(val);
    }, onDone: () {
        print('It is complete ')
    })
}

Stream<int> countDown() async* {
    for(int i = 5; i>0; i--) {
        yield i;
        await Future.delayed(Duration(seconds: 1));
    }
}

```

### Stream Controller <a id="StreamController"></a>
- Permite controlar el Stream al pasar un método que pueda añadir valores a un stream, cancelarlo, pausarlo, etc.
- Se debe importar el paquete dart:async.

``` Dart
import 'dart:async';

void main() async {
    countDown();
}

void countDown() {
    final controller = StreamController<int>();

    controller.sink.add(1);
    controller.sink.add(2);
    controller.sink.add(3);
    controller.sink.add(4);
    controller.sink.close();

    controller.stream.listen((val) {
        print(val);
    }, onError: (err) {
        print(err);
    })

    cosntroller.close();
}

```

## Records <a id="Records"></a>
- Son útiles para la destructuracion de elementos.
- Se puede colocar _ para ignorar valores en la destructuración.

``` Dart
void main() async {
    final list = [1,2,3,4,5,6];
    final [a, b, c, ...] = list;
    print('$a $b $c')
}
```

``` Dart
void main() async {
    final list = [1,2,3,4,5,6];
    final [a, _, c, ...d] = list;
    print('$a $c $d')
}
```

``` Dart
void main() async {
    final jsoned = {
        'id': 2,
        'title': 'ssfdsfds',
        'body': 'dfdafdsfdsa fdsfdsaf'
    }

    if( jsoned case {'userId': int id, 'title': String title}) {
        print(userId);
        print(title);
    } else {
        print('Incorrect JSON')
    }

    // También se puede usar switch en lugar de IF
    switch(jsoned) {
        case {'userId': int id, 'title': String title}:
            print(userId);
        default:
            print('Error');

    }
}
```

### Pattern Matching (uso para clases) <a id="PatternMatching"></a>

``` Dart
void main() async {
    final human = Human('Nice Name', 2);

    final Human(:name, :age) = human;

    print(name);
}

class Human {
    final String name;
    final int age;
    Human(this.name, this.age);
}
```

## Variables <a id="Variables Types"></a>

``` Dart
dynamic v = 123;   // v is of type int.
v = 456;           // changing value of v from 123 to 456.
v = 'abc';         // changing type of v from int to String.

var v = 123;       // v is of type int.
v = 456;           // changing value of v from 123 to 456.
v = 'abc';         // ERROR: can't change type of v from int to String.

final v = 123;       // v is of type int.
v = 456;           // ERROR: can't change value of v from 123 to 456.
v = 'abc';         // ERROR: can't change type of v from int to String.
```


- **dynamic** es el tipo de dato subyacente de todos los objetos de Dart. No se requiere usarlo explícitamente en todos los casos.
    - Permite cambiar el tipo de dato y el valor de una variable.
- var es una palabra clave para indicar a dart que no se desea indicar el tipo.
    - Dart reemplaza la palabra clave con el inicializador type, o lo dejará dinámico por defecto si no hay inicializador.
    - Se usar var si se espera que una asignación de variable cambie durante su lifetime.
    - No permite cambiar el tipo de dato pero sí el valor de una variable.
    
``` Dart
var msg = "Hello world.";
msg = "Hello world again.";
```

- final se usa cuando la asignación de una variable permanecerá igual durante su lifetime.
    - Su uso ayuda a atrapar situaciones en donde accidentalmente se cambia la asignación de una variable cuando no se deseaba hacerlo.
    - No permite cambiar ni el tipo de dato ni el valor de una variable.

``` Dart
final msg = "Hello world.";
```

### Final vs const  <a id="FinalConst"></a>
- Ambos se usan para declarar variables que no puedes ser reasignadas después de su inicialización. Es decir, se usan para declarar variables como inmutables.
- Final es una constante en runtime, lo que significa que su valor puede ser asignado en runtime en lugar de compile-time, lo cual sucede cuando se usa const.
- Las variables const deben ser inicializadas con un valor constante en el tiempo de compilación.
    - Se usa para crear colecciones y objetos como:

``` Dart
const [1,3,4];
const Point(3,4); // En lugar de new Point(2,3)
```

- Aquí, const significa que todo el estado profundo del objeto puede ser determinado completamente en tiempo de compilación y que el objeto será congelado y completamente inmutable. const modifica valores.
    - No se puede usar para casos en donde el valor se conoce hasta el runtime (ejemplo: new Datetime.now()).
    - Si el valor se conoce en el tiempo de compilación (ejemplo: const a = 1) entonces se debe usar const en lugar de final.

- Final se usa cuando no se conoce el valor de una variable en el tiempo de compilación y se conocerá hasta el runtime. 
    - Por ejemplo:
        - Una respuesta HTTP que no puede cambiar.
        - Obtener algo de base de datos.
        - Leer de un archivo local.
    - Cualquier cosa que no se conozca en el tiempo de compilación debe ser declarada con final.

# Flutter <a id="Flutter"></a>
