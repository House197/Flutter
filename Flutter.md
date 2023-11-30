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
- <div style='background:radial-gradient(circle at 10% 20%, rgb(255, 200, 124) 0%, rgb(252, 251, 121) 90%); color:black; font-weight:bold; padding:10px 10px; padding-top:3px; border-radius:10px;'>La convención para una función o variables es camelCase, pero para una clase se usa la notación PascalCase.</div>
- Se definen propiedades usando variables.
- Se crea una instancia de una clase al invocar la clase con ().
     - <div style='background-image: radial-gradient( circle farthest-corner at 10% 20%,  rgba(97,186,255,1) 0%, rgba(166,239,253,1) 90.1% ); color:black; font-weight:bold; padding:10px 10px; padding-top:3px; border-radius:10px;'>El tipo de dato que se define a la variable es el nombre de la clase o usar <strong>final</strong>.</div>
- Se pueden acceder a los métodos y atributos de la clase con la notación de punto. 
- <div style='background:radial-gradient(circle at 10% 20%, rgb(255, 200, 124) 0%, rgb(252, 251, 121) 90%); color:black; font-weight:bold; padding:10px 10px; padding-top:3px; border-radius:10px;'>No es necesario usar la palabra reservada new para crear un clase, ya que Dart ya allocate memoria cada que se crea una instancia de clase a diferencia de Java.</div>

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
- <div style='background:radial-gradient(circle at 10% 20%, rgb(255, 200, 124) 0%, rgb(252, 251, 121) 90%); color:black; font-weight:bold; padding:10px 10px; padding-top:3px; border-radius:10px;'>Si no se usa this dentro de los parámetros del constructor entonces éste crearía nuevas variables.</div>
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
    - Se puede solucionar colocando final al momento de definir a los atributos, lo cual formaría una clase inmutable una vez que se crea la instancia y se personaliza con el constructor.
    - De igual forma se pueden usar métodos getters y setters (esto no se coloca en el siguiente código).

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
- <div style='background:radial-gradient(circle at 10% 20%, rgb(255, 200, 124) 0%, rgb(252, 251, 121) 90%); color:black; font-weight:bold; padding:10px 10px; padding-top:3px; border-radius:10px;'>Se definen con _.</div>
- <div style='background:radial-gradient(circle at 10% 20%, rgb(255, 200, 124) 0%, rgb(252, 251, 121) 90%); color:black; font-weight:bold; padding:10px 10px; padding-top:3px; border-radius:10px;'>En Dart, las variables privadas lo son para un archivo, no son privadas solo para una clase.</div>
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
- <div style='background:radial-gradient(circle at 10% 20%, rgb(255, 200, 124) 0%, rgb(252, 251, 121) 90%); color:black; font-weight:bold; padding:10px 10px; padding-top:3px; border-radius:10px;'>Las variables estáticas pueden ser accedidas como método de clase y no de instancia.<div>
- No hace falta instanciar la clase, por lo que el constructor tampoco será llamado.
- Ayudan a guardar memoria ya que no se deben instanciar las clases.
- <div style='background:radial-gradient(circle at 10% 20%, rgb(255, 200, 124) 0%, rgb(252, 251, 121) 90%); color:black; font-weight:bold; padding:10px 10px; padding-top:3px; border-radius:10px;'> declarar atributos no es posible seguir este enfoque, ya que los miembros de instancia no pueden ser accedidos desde métodos estáticos. 
    - Los atributos de clase se inicializan cuando se crea una instancia.</div>

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
- <div style='background:radial-gradient(circle at 10% 20%, rgb(255, 200, 124) 0%, rgb(252, 251, 121) 90%); color:black; font-weight:bold; padding:10px 10px; padding-top:3px; border-radius:10px;'>Se utiliza la palabra reservada extends.</div>
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
- Una clase abstracta en Flutter es una clase que no puede ser usada para instanciar objectos.
    - Sirve para dos propósitos:
        - Crear interfaces.
        - Definir parcialmente clases implementadas en Dart.
    - Se define colocando la palabra reservada abstract al antes del nombre de la clase.

``` Dart
abstract class Shape {
  void draw(); // Abstract methods
}

abstract class Vehicle { 
    void accelerate(); // Abstract method
}

class Car implements Vehicle {
    @override
    void accelerate() {
        print('accelerating the car');
    }
}
```

- En este ejemplo, accelerate es un método abstracto que no contiene un method body; sin embargo, obliga a concrete classes o clases hijas derivadas de la clase abstracta a proveer de una implementación para este método.
- Ejemplos de un clase derivada o concrete serían:

``` Dart
class Triangle extends Shape { // Class Triangle extends Shape
  void draw() { // own implementation
    print('Drawing Triangle');
  }
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
- Son un tipo especial de clase que se usa para representar un número fijo de valores constantes.

``` dart
enum Color { red, green, blue }
```

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
- Dart permite también enum declarations para declarar clases con campos, métodos y constructores constantes que es´tan limitados a un número fijo de instancias constantes conocidas.
- Para declarar un enhanced enum se sigue una sintaxis similar a las clases, pero con requerimientos extra:
    - Las variables de instancia deben ser final, incluyendo aquellos agregados por mixins.
    - Todos los constructores generativos deben ser constantes.
    - Factory constructors solo pueden retornan uno de los instancias enum fijas y conocidas.
    - No se puede extender ninguna otra clase ya que Enum se extiende automáticamente.
    - No puede haber overrides para index, hashCode, el operador de igualdad ==.
    - No se puede declarar un miembro llamado values en un enum, ya que entraría en conflicto con el getter de valores estáticos generado automáticamente.
    - Todas las instancias del enum deben declararse al principio de la declaración, y debe haber al menos una instancia declarada.
- Permite pasar atributos a las opciones definidas por enums.
- Los métodos de isntancia en un enhanced enum puede usar this para hacer ereferncia al valor enum actual.

- Ejemplo 1:

``` Dart
enum Vehicle implements Comparable<Vehicle> {
  car(tires: 4, passengers: 5, carbonPerKilometer: 400),
  bus(tires: 6, passengers: 50, carbonPerKilometer: 800),
  bicycle(tires: 2, passengers: 1, carbonPerKilometer: 0);

  const Vehicle({
    required this.tires,
    required this.passengers,
    required this.carbonPerKilometer,
  });

  final int tires;
  final int passengers;
  final int carbonPerKilometer;

  int get carbonFootprint => (carbonPerKilometer / passengers).round();

  bool get isTwoWheeled => this == Vehicle.bicycle;

  @override
  int compareTo(Vehicle other) => carbonFootprint - other.carbonFootprint;
}
```

- Ejemplo 2:

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
## Crear aplicación
Se pueden crear aplicaciones de Flutter tanto en Android Studio como en Visual Studio
- Para crear una aplicación desde la terminal se debe correr el siguiente comando.

``` Bash
flutter create <app_name>
```

- El nombre de la aplicación debe estar compuestas solo de minúsculas y separada por giones bajos en lugar de espacios.
- Si se usa VSCode entonces se debe instalar la extensión: Flutter.
- Se pueden importar devices desde Android Studio para usarlos en VSCode. https://www.youtube.com/watch?v=CzRQ9mnmh44, 8:20:00
    - Al tener esta extensión es posible correr la aplicación con las opciones que se muestran por encima de la función VOID MAIN de flutter.
    - De igual manera, se puede correr la aplicación escibiendo flutter run en la terminal.
    - Finalmente, se puede correr la aplicación con la opción 'Run Without Debugging' en las opciones de Run de VSCode.

## Settings de VSCode
- Se presiona cmd + shift + p para poder acceder tanto a los settings como a preferences al escribir:
    - >settings o >preferences¨
- La extension Error Lens permite ver las advertencias directamente en la linea de codigo si tener que hacer hover sobre la linea de codigo.

## Widgets
- Los Widgets son clases.
- Existen los siguientes tipos:
    - StatelessWidget.
        - Implica que el Widget tiene poco estado que gestionar.
        - Una vez que se crea el widget se vuelve inmutable (haciendo referencia que el estado y la data son inmutables).
        - Al extender StatelessWidget se pide que se sobrescriban algunas funciones, lo cual hace referencia a clases abstractas en donde se debe sobrescribir la función y redefinir la implementación.
        - En la definición de StatelessWidget se tiene un constructor que pide una key, ya que StatelessWidget extiende a la clase Widget, la cual solicita esta key para su constructor.
    - StatefulWidet.
    - Inherited Widget.

## Tipos de diseños
- Existen dos popoulares:
    - Material Design (creado por Google).
        - Se usa importando material.dart y retornando MaterialApp en el Widget que se usa como nodo principal de la aplicación.
        - Material App ya se encarga del formato del texto, por lo que en Text ya no es necesario especificar la dirección.
        - Material App provee del:
            - Theming.
            - Navigation.
            - Material Design.
            - Localization.
        - MaterialApp requiere de la propiedad home, la cual se usa en conjunto con scaffold, el cual a su vez requiere de la propiedad body.
        - Scaffold provee lo siguiente:
            - Provee del Layout para una página (Navbar, header, footer, etc.)


``` Dart
import 'package:flutter/material.dart';

void main () {
  // MyApp lleva parentesis porque es una clase, por lo que se esta creando una instancia
  // const indica que el constructor es una constante en el compile time, lo cual indica a Flutter que la instancia de Widget creada no debe ser recreada cada vez. Se debe recrear solo una vez.
  runApp(const MyApp());
}

// Todos los Widget son clases
class MyApp extends StatelessWidget {

  // Se crea el constructor de la clase para pasar la Key solicitadas por StatelessWidge, la cual se la pasa a la clase Widget que extiende.
  const MyApp({super.key}); // Opcionalmente se toman parametros del constructor y se pasan al Widet que se extiende.
  // super.key es un shorthand de lo siguiente:
  // const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se usa el design dado por Google, por lo que se retorna MaterialApp
    return MaterialApp(
      // Se requiere de la propiedad home, la cual requiere de Scaffold que necesita la propiedad de body.
      home: Scaffold(
        // Body puede verse como un DIV que ocupa toda la pantalla. Se usan elementos como Center para controlar la posicion de los elementos.
        body: Center(
          child: const Text('Hello World'),
          ),
      ),
    );
  }
}
```
- Cupertino Design (creado por Apple).

## Build
- Build Context es una clase dada por Flutter.
- Permite indicar a Flutter la ubicación exacta de un Widget en el árbol de Widgets.
- Cada que se wxtiende un Widget (stateful o stateless) se va a tener acceso a build.

## Widget Column
- Widget permite deifnir varios Widget en su propiedad Children por medio de una lista, lo cual permite agregar varios Widgets que se van a acomodar en la pantalla de forma vertical.
- Va a ocupar toda la pantalla verticalmente, pero horizontalmente solo tomará el contenido más largo.
- No se requiere envolver en un Widget Center.
- Maneja sus propias propiedades para centrar a los elementos en el eje vertical (el principal en este caso), y el horizontal.
    - MainAxisAlignment.
    - CrossAxisAlignment.
- Se recalca que MainAxis Alignment es un enum, ya que define un número fijo de valores constantes (center, start, end, etc).

``` Dart
import 'package:flutter/material.dart';

class CurrencyConverterMaterialPage extends StatelessWidget {

  const CurrencyConverterMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,        
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Text 1', style: TextStyle()),
            Text('Converter Page'),
            Text('Text 2')
          ],
        ),
      ),
    );
  }
}
```

## Text
- Widget que permite introducir texto en la aplicación.
- Se puede dar estilo por medio de la propiedad style y la clase TextStyle, lo cual abarca estilos como 
    - font-size.
    - font-weight.
    - Color.
        - Se puede usar la clase de Color para poder usar la opciones como RGBO.
        - Se puede usar la clase Colors para acceder a colores predeterminados por medio de su nombre.

## TextField
- Permite al usuario poder ingresar valores.
- Se puede dar estilo al texto del Widget por medio de la propiedad style y la clase TextStyle.
- Se le da estilo a la estructura por medio de decoration y la clase InputDecoration.
    - Permite definir la label del input.
        - En este caso se presentan dos opciones: label y labelText.
            - Label requiere que se le pase un Widget (Text()) para desplegar la información, lo que permite una mayor pesonalización en el estilo.
            - LabelText solo requiere de un String.
    - El Placeholder está dado por la propiedad hintText.
        - Se le da estilo por medio de hintStyle.
    - Se puede usar la propiedad prefix/suffix para añadir ya sea texto o un icono a la input.
        - Los iconos se agregan usando prefixIcon con ayuda de la clase Icon y Icons como argumento de la clase.
        - Se les da color a los iconos usando prefixIconColor.
    - Se tienen opciones de estilo como fill, focus hover color.
        - Para poder usar fillColor se debe establecer la propiedad filled a true.
    - Se tienen opciones de Border.
        - Se quita el borde azul que trae por defecto el Input por medio de focusedBorder.
            - Se debe usar la clase OutlineInputBorder para especificar el color.
            - Se aprecia que al hacer hover sobre la líena de código de la clase de BorderSide se ve que por defecto la clase ya está asignando el valor del color, el ancho, el estilo y el strokeAlign (permite definir si el borde debe estar dentro del widget, en medio o por fuera).
    - BorderRadius presenta la opcion de BorderRadius.all, el cual es su constructor.
        - <div style='background:radial-gradient(circle at 10% 20%, rgb(255, 200, 124) 0%, rgb(252, 251, 121) 90%); color:black; font-weight:bold; padding:10px 10px; padding-top:3px; border-radius:10px;'>Con el constructor BorderRadius.Circular no se debe usar const, pero al definir const Scaffold (el cual contiene a TextField), todos los Widgets hijos deben ser const.</div>
        - Entonces, si se desea usar BorderRadius.Circular se debe quitar el const de Scaffold pero agregar const a todos los widgets hijos (solo para los hijos que son const) a excepcion a los Widgets que son parents.
        - Si se desea que el borde siempre tenga el estilo y no solo cuando se le haga focus entonces se usa la propiedad enabledBorder y se le coloca el mismo Widget que se uso para focusedBorder.
        - Se puede controlar los valores que se le pueden ingresar al TextField con el parametro keyboardType y TypeTextInput.
    
``` dart
class CurrencyConverterMaterialPage extends StatelessWidget {

  const CurrencyConverterMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {

    // Se pueden guardar Widgets en variables, lo cual ayuda para un factor comun.
    final border = OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignOutside
                      ),
                      borderRadius: BorderRadius.circular(60)
                    );

    return Scaffold(
      body: ColoredBox(
        color: Colors.blueGrey, // Color de Center
        child: Center(
          child: ColoredBox(
            color: Color.fromARGB(111, 32, 104, 199), // Color de Column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,        
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Currency Converter', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10
                )),
                const Text('Converter Page', style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold
                )),
                TextField(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                  decoration: InputDecoration(
                    label: const Text('Converter', style: TextStyle(color: Colors.black)),
                    hintText: 'Enter the amount to be converted.',
                    prefixText: 'Amount: ',
                    prefixIcon: const Icon(Icons.monetization_on),
                    prefixIconColor: Colors.white,
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Padding y Container
- Padding se encarga unicamente de dar el espaciado entre el contenido y el contenedor, mientras que Container se compone de varios Widgets, incluyendo el de Padding.

## Botones
- Se pueden pasar funciones anonimas.
``` Dart
    TextButton(
        onPressed: () {
            print('I was clicked');
        },
        child: Text('Press Me')
    )
```
- Los botones requieren de funciones void y que no aceptan parametros.
- Se clasifican en:
    - Raised ()
    - Appears like a text (TextButton, ElevatedButton)
- Se les da estilo con la propiedad style en conjunto con MaterialStatePropertyAll, en donde se pueden ingresar los valores que se pondrian para los campos de color, textStyle, etc. 
- En los botones, el color de texto se da con la propiedad de foregroundBackground en el estilo del boton.
- Un boton puede abarcar todo el ancho usando la propiedad minimumSize, Size y pasando double.infinity en la parte de width.

``` Dart
ElevatedButton(
    onPressed: () {
        print('I was clicked');
    },
    style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.amber),
        foregroundColor: MaterialStatePropertyAll(Colors.blueAccent),
        minimumSize: MaterialStatePropertyAll(Size(double.infinity, 50.0)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))
        ))
    ),
    child: const Text('Convert',)
),
```

- Se puede evitar usar MaterialStatePropertyAll todo el tiempo al usar en style: NombreBotonWidget.styleFrom
    - Esta opcion es una funcion, por lo que no se le puede poner const. 

``` Dart
ElevatedButton(
    onPressed: () {
        print('I was clicked');
    },
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.blueAccent,
        minimumSize: const Size(double.infinity, 50.0),
        shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))
        )
    ),
    child: const Text('Convert',)
),
```

## AppBar con Scaffold
- Scaffold acepta la propiedad appBar ademas de body.
- Se usa el Widget AppBar, el cual cuenta con las propiedades:
    - backgroundColor.
    - elevation.
    - title.
- El estilo del texto se da en la propiedad de style en lugar de hacerlo directamente en el Widget de Text.

``` Dart
Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 114, 188, 224),
        elevation: 0, // Quita linea de bottom que le da 
        title: const Text('Currency Converter', 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 10
        )),
      ),
)
```

## Logica de conversion
- En un StatelessWidget no se puede colocar una variable como int variableName
    - Si se desea hacer eso entonces la variable se debe colocar dentro de la funcion build en lugar del nivel superior de la clase.
    - Se puede colocar una variable en el nivel superior de una funcion, se debe declarar como final.
- Recuperar un valor de un TextField.
    - Se requiere de un Text Editing Controller, el cual se define en el nivel superior de la funcion Build
    - Se coloca ahi debido a que TextEditingController no es un constructor constante, por lo que colocarlo en el nivel superio de la clase provocaria tener que quitar const del constructor principal y de la instanciacion del Widget.
    - TextEditingController puede pasarse a Text, ya que este cuenta con una propiedad dedicada para esa finalidad.
    - TextEditingController contiene el valor escrito en el TextField.
    - A continuacion, se debe colocar el valor contenido en textEditingController en el Widget Text, el cual ya no es const debido a que va a tener un valor mutable segun lo que se escriba.
    - El valor de textEditingController puede almacenarse en una variable al momento de ejecutar el codigo del boton colocado.
    - A modo de poder ver el texto en el Widget de Text se debe crear un estado. Si se hace rebuild al Widget las variables se vuelven a inicializar, por lo que se sigue sin poder ver el valor del TEXT con lo que se escribio en TextInput.
        - Por esta razon se debe usar un Widget con estado (StatefulWidget).

``` Dart
class CurrencyConverterMaterialPage extends StatelessWidget {

  const CurrencyConverterMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    double result = 0;
    final TextEditingController textEditingController = TextEditingController();
    print('hi');

    // Se pueden guardar Widgets en variables, lo cual ayuda para un factor comun.
    final border = OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignOutside
                      ),
                      borderRadius: BorderRadius.circular(60)
                    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 114, 188, 224),
        elevation: 0, // Quita linea de bottom que le da 
        title: const Text('Currency Converter', 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 10
        )),
      ),
      body: ColoredBox(
        color: const Color.fromARGB(255, 104, 167, 199), // Color de Center
        child: Center(
          child: ColoredBox(
            color: const Color.fromARGB(111, 32, 104, 199), // Color de Column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,        
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                result.toString(), 
                style: const TextStyle(
                  color: Color.fromARGB(255, 243, 244, 245),
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: TextField(
                    controller: textEditingController,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    decoration: InputDecoration(
                      label: const Text('Converter', style: TextStyle(color: Colors.black)),
                      hintText: 'Enter the amount to be converted.',
                      prefixText: 'Amount: ',
                      prefixIcon: const Icon(Icons.monetization_on),
                      prefixIconColor: Colors.white,
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                       result = double.parse(textEditingController.text);
                       build(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                    ),
                    child: const Text('Convert',)
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
```

## StatefulWidget y State
- Al extender la clase se debe crear un estado.
- Al definir el estado se debe extender la clase abstracta State y colocar la implementacion de build para poder definir el estado.
    - Luego, en la implementacion de createState de la extension de StatefulWidget se crea una instancia de la clase creada a partir de state.
    - Esto se hace porque no se pueden tener variable mutables dentro de la extension de StatefulWidget, pero si dentro de la extension de la clase State.

``` Dart
class CurrencyConverterMaterialPagee extends StatefulWidget {

  const CurrencyConverterMaterialPagee({super.key});

  @override
  State createState() => _CurrencyConverterMaterialPageState();
}

// State es una clase abstracta, por lo que se debe instanciarla. Se hace privada para que no pueda ser accedida fuera de este archivo.
// Se indica que la clase esta relacionada con la de StatefulWidget al colocarle el tipo de la funcion por medio de <>

class _CurrencyConverterMaterialPageState extends State<CurrencyConverterMaterialPagee> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

```

- Por medio de initState se asegura que el codigo definido en ese bloque se ejecute antes de la funcion build.
    - Es util cuando se tienen llamados a API o valores futuros, pero para la aplicacion actual en donde se tiene una variable que cambia de acuerdo a lo escrito en el Input no es necesario.
-  La funcion BUILD debe ser lo menos expensive posible, ya que es lo que se puede ejecutar un gran numero de veces.
    - La logica asincrona debe colocarse en el nivel superior de la clase.
- En lugar de usar build(context) para volver a correr el BUILD se usa setState, en donde se ajusta el valor de la variable que se desea modificar.
    - setState no debe ser llamado para eventos asincronos.
    - No es necesario colocar las variables que se actualizan dentro, ya que setState indica a Flutter que debe volver a hacer BUILD al Widget y ajustar las variables necesarias.git pu
12:30
``` Dart
import 'package:flutter/material.dart';

class CurrencyConverterMaterialPage extends StatefulWidget {

  const CurrencyConverterMaterialPage({super.key});

  @override
  State<CurrencyConverterMaterialPage> createState() {
    print('createState');
    return _CurrencyConverterMaterialPageState();
  }
}

// State es una clase abstracta, por lo que se debe instanciarla. Se hace privada para que no pueda ser accedida fuera de este archivo.
// Se indica que la clase esta relacionada con la de StatefulWidget al colocarle el tipo de la funcion por medio de <>

class _CurrencyConverterMaterialPageState extends State<CurrencyConverterMaterialPage> {
  
  double result = 0;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Se pueden guardar Widgets en variables, lo cual ayuda para un factor comun.
    final border = OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignOutside
                      ),
                      borderRadius: BorderRadius.circular(60)
                    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 114, 188, 224),
        elevation: 0, // Quita linea de bottom que le da 
        title: const Text('Currency Converter', 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 10
        )),
      ),
      body: ColoredBox(
        color: const Color.fromARGB(255, 104, 167, 199), // Color de Center
        child: Center(
          child: ColoredBox(
            color: const Color.fromARGB(111, 32, 104, 199), // Color de Column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,        
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                result.toString(), 
                style: const TextStyle(
                  color: Color.fromARGB(255, 243, 244, 245),
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: TextField(
                    controller: textEditingController,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    decoration: InputDecoration(
                      label: const Text('Converter', style: TextStyle(color: Colors.black)),
                      hintText: 'Enter the amount to be converted.',
                      prefixText: 'Amount: ',
                      prefixIcon: const Icon(Icons.monetization_on),
                      prefixIconColor: Colors.white,
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                       setState(() {
                          result = double.parse(textEditingController.text);
                       });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                    ),
                    child: const Text('Convert',)
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- Todos los Widgets son inmutables (StatefulWidget y StatelessWidget), pero con StatefulWidget el State es el que lo hace mutable.
- Const ayuda a que los Widgets definidos con esto no se vuelvan a renderizar cuando haya un Rebuild del Widget padre.
    - Se usa SizedBox en lugar de Container para dejar un espacio entre Widgets, ya que SizedBox es const mientras Container no.

## Ejectuar codigo segun su se esta en debug, release o profile
- Flutter provee de la variable kDebugMode. 
``` Dart
    TextButton(
        onPressed: () {
            if(kDebuMode){
                print('I was clicked');
            }       
        },
        child: Text('Press Me')
    )
```

## Buenas practicas
- La propiedad child en un Widget siempre tiene que estar al final de la lista en las propiedades.

# Clonar repositorio de proyecto Flutter
- Se clona el repositorio usando git glone.
- Se corre el comando flutter pub get para instalar las dependencias del proyecto, lo cual es similar a npm install.
- Si se desea hacer push de los cambios al repositorio pero usando otra cuenta, entonces se cambia el origen del remote.
https://stackoverflow.com/questions/2432764/how-do-i-change-the-uri-url-for-a-remote-git-repository

git remote set-url origin new.git.url/here

En donde el origin debe lucir de la siguiente manera segun se haya establecido en el archivo config en la carepta .shh

git@github.com-work:kaththy/Test.git

# Extras
## Agregar segunda cuenta de Git
- Se siguen los pasos de este <a href=''>https://code.tutsplus.com/quick-tip-how-to-work-with-github-and-multiple-accounts--net-22574t</a>
    - Al momento de crear la SSH Key se corre el siguiente comando agregando el email deseado.
ssh-keygen -t ed25519 -C "your@email.com"
    11:07