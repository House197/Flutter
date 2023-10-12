# Dart
## Classes
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

### Constructores
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

### Private variables
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

### Getters y Setters
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

### Static functions and Static variables
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

### Herencia
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

#### Override
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

#### Implements
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

#### Abstract Classes
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
### Object Oriented Programming (OOP)