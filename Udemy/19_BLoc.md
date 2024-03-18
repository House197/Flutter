# Sección 19. BLoC (Business Logic Component) - FlutterBloc y Cubits
- Son gestores de estado.
- BLoC es una forma de trabajar el estado de la app separado en eventos, en estado y en una clase que controla los eventos y los estados.
- Opcional, tener extensión bloc para poder crear cubits y bloc dando click derecho sobre una carpeta y seleccionando la opción correspondiente.
- Flutter BLoC permite especificar que solo se redibuje una cierta sección que va cambiar, dejando a lo demás intacto.
  - A diferencia de Riverpod que también distingue qué cambia pero por medio de condiciones.
  - Con Bloc se envuelve al Widget que va a cambiar con BlocBuilder para pasarle el estado.
- Los cubits son Blocs.
- Se pueden crear aplicaciones usando tanto como cubit como blocs.

## Temas
1. BLoC
2. Flutter Bloc
3. Cubits
4. Equatable
5. Eventos
6. Estado

## 1. Inicio de la aplicación - Estilo, Router y HomeScreen
1. Abrir paleta de comandos con CTRL + SHIFT + P.
2. Escribir Flutter: New Project.
3. Seleccionar opción Application.
4. main.dart, en MaterialApp solocar en false debugShowCheckedModeBanner.
5. config -> theme -> app_theme.dart
    1. Se usa el campo listTileTheme de ThemeData para poder darle estilo a determindos Widgets de forma global.
6. Instalar go_router
7. config -> router -> app_router.dart
8. Agregar router en MaterialApp, main.dart
    1. Convertir MaterialApp a MaterialApp.router.
    2. Agregar campo routerConfig para colocar variable appRouter proveniente de app_router.dart.
    3. Quitar campo de home en MaterialApp.
9. presentation -> screens -> home_screen.

## 2. CubitCounterScreen
1. presentation -> screens -> cubit_counter_screen.dart
    1. Definir en el Scaffold floatingActionButton.
    2. Colocar campo heroTag a FloatingActionButton.
        - Cuando se tiene más de un FloatingActionButton se le debe indicar a Flutter el FloatingActionButton que se anima por defecto entre Scaffolds.

## 3. Cubits
1. Instalar flutter_bloc.
    - Cubits ya viene incluido en Flutter BLoC.
2. presentation -> blocs
3. Al tener la extensión bloc se hace click derecho sobre la carpeta de blocs y crear nuevo cubit, lo cual crea la carpeta de cubics y los archivos necesarios.
4. Renombrar carpeta cubit por counter_cubit.
5. Modificar counter_state.dart.
    - Se define cómo se desea luzca el estado.
    - Cuando se define el estado (clase con propiedades). se debe crear una forma de emitir un nuevo estado (crear una copia del estado).
    - Un nuevo estado es una nueva instancia del estado creado (CounterState)

``` dart
part of 'counter_cubit.dart';

class CounterState {
  final int counter;
  final int transactionCount;

  CounterState({this.counter = 0, this.transactionCount = 0});

  copyWith({
    int? counter,
    int? transactionCount,
  }) =>
      CounterState(
        counter: counter ?? this.counter,
        transactionCount: transactionCount ?? this.transactionCount,
      );
}

```

6. Llamar instancia en counter_cubit.dart
    - En este archivo se pueden crear propiedades y métodos que no están amarradas al estado.
7. Definir método para incrementar el estado.
    - Se puede hacer de la manera cómo se muestra en el código siguiente, sin embargo, gracias a copyWith se puede hacer como se tiene en el segundo código.
    - Con state.copyWith ya no se tiene la obligación de mandar algunos de los valores, ya que esto se maneja cuando se definió copyWith en el estado, en donde se maneja el estado anterior si es que no se pasa el campo.
``` dart
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(counter: 5));

  void increaseBy(int value) {
    emit(
      CounterState(
          counter: state.counter + value,
          transactionCount: state.transactionCount + 1),
    );
  }

  void reset() {}
}
```

``` dart
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(counter: 5));

  void increaseBy(int value) {
    emit(
      state.copyWith(
          counter: state.counter + value,
          transactionCount: state.transactionCount + 1),
    );
  }

  void reset() {}
}
```

## 4. Consumir y utilizar el CounterCubit
- Es idéntico a cómo se usa Provider.
- En donde se coloque el cubit define el alcance que va a tener en la aplicación.

1. Envolver todos los widgets que pueden tener acceso al estado de Cubit en un **BlocProvider**.
2. Definir campo create para crear instancia del estado (CounterCubit).

``` dart
class CubitCounterScreen extends StatelessWidget {
  const CubitCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const _CubitCounterView(),
    );
  }
}

class _CubitCounterView extends StatelessWidget {
  const _CubitCounterView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
```

3. Envolver el widget deseado con un BlocBuilder.
  - En el primer tipado se coloca la clase, mientras que en el segundo es el estado.
  - Se tiene el campo buildWhen, en donde se especifica que cambie cuando se cumple una condición.
  - buildWhen solo debería usarse cuando se tiene una condición muy específica.
``` dart
Center(
          child: BlocBuilder<CounterCubit, CounterState>(
            //buildWhen: (previous, current) => current.counter != previous.counter
              builder: (context, state) =>
                  Text('Counter value: ${state.counter}')))
```

- Existe la otra opción de escuchar las opciones que tiene el counter al definirlo en el nivel superior de la función build, tal como se hace con Riverpod.
  - A partir de la variable que escucha al estado se puede extraer información.

``` dart
    final counterState = context.watch<CounterCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cubit Counter: ${counterState.transactionCount}'),
```

4. Llamar métodos.
  - Se debe usar read en lugar de watch, ya que no se desea estar pendiente del valor del estado.
  - Se pueden ocupar las funciones directamente, pero se puede limpiar el código al generar una función que llame a las funciones de cubit.

``` dart
  void increaseCounterBy(BuildContext context, [int value = 1]) {
    context.read<CounterCubit>().increaseBy(value);
  }
```

## 5. Equatable para optimizar código
- Por el momento se va a redibujar el Widget a pesar de que el estado se mantenga igual, como es el caso de presionar reset varias veces.
- Se le debe indicar a cubit que no renderice de nuevo si el estado no cambia.
- Equatable permite comparar dos objetos para poder comparar si son iguales en sus valores.
1. Instalar equatable.
2. Comentar la variable que llama a context.watch en el nivel superior de la función build.
3. Crear instancia de Equatable, colocar constructor como constante y crear una lista de propiedades que son usadas para compararlo.
  - La instancia va a ser CounterState, la cual solo debe extender de Equatable.
``` dart
class CounterState extends Equatable {
final int counter;
final int transactionCount;

const CounterState({this.counter = 0, this.transactionCount = 0});

copyWith({
  int? counter,
  int? transactionCount,
}) =>
    CounterState(
      counter: counter ?? this.counter,
      transactionCount: transactionCount ?? this.transactionCount,
    );

@override
List<Object> get props => [counter, transactionCount];
}
```
4. En counter_cubit también se debe colocar constante a la instancia del estado.

``` dart
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState(counter: 5));

```
- Con estos cambio ya se aplica la funcionalidad de Equatable.
- Se puede seguir usando la referencia al estado en el nivel superior de la función.
  - Si no se desea tener esa función en el nivel superior y se más específico al momento de leer el estado, se puede usar context.select() para estar pendiente de un solo 'bloc'.
    - Context.select permite obtener todo el cubit, de tal manera que se pueden usar streams u otras cosas.
    - El Stream de cubit es el flujo de nuevas emisiones de estados.

``` dart
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (CounterCubit value) =>
              Text('Cubit Counter: ${value.state.transactionCount}'),
        ),
```

- Con esta técnica context.select va a retornar la primera instancia en el BuildContext de ese Cubit, lo cual puede ser un problema si se tuvieran más cubits.
  - Por ejemplo, en la app de películas se tenía el mismo provider, pero cambiaba el estado y el nombre.
  - Esta es una limitante de Provider, no tanto de Bloc Y Flutter BLoC.
- El código anterior es equivalente a BlocBuilder<CounterCubit, CounterState>

## 1. BLoC y Flutter BLoC
1. Crear Bloc por medio de extensión Bloc en la carpeta de Blocs.
  - Si ya se tiene Equatable entonces esta extensión ya coloca el código para implementarlo. (No pasó eso en este caso.)
  - Esto crea tres archivos:
    1. counter_bloc.dart
      - Similar a Cubit, en donde se gestiona el state.
    2. counter_state.dart
      - Se define cómo luce el estado.
    3. counter_event.dart
      - Para emitir nuevos estados se hace basado en eventos.
      - Se similar a Redux en donde las modificaciones se hacen basada en eventos.
        - P/e: se llama el evento incremetar, el cual es recibido por bloc y éste sabe qué hacer cuando se recibe un evento de ese tipo.
2. Crear estado en counter_state.dart
  - Se pueden tener varios states en counter_state.dart
``` dart
part of 'counter_bloc.dart';

class CounterState extends Equatable {
  final int counter;
  final int transactionCount;
  const CounterState({
    this.counter = 10,
    this.transactionCount = 0,
  });

  CounterState copyWith({
    int? counter,
    int? transactionCount,
  }) =>
      CounterState(
        counter: counter ?? this.counter,
        transactionCount: counter ?? this.counter,
      );

  @override
  List<Object> get props => [counter, transactionCount];
}

}

final class CounterInitial extends CounterState {}
```

3. Crear eventos en counter_event.dart
4. Implementar archivos en counter_bloc.dart

``` dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState()) {
    on<CounterEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
```
- El constructor de CounterBloc llama al constructor de la clase que hereda para colocar el estado inicial.
  - El cuerpo del constructor del padre en donde se define un handler o un manejador de un CounterEvent.

``` dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState()) {
    on<CounterIncreased>((event, emit) {
      emit(
        state.copyWith(
          counter: state.counter + event.value,
          transactionCount: state.transactionCount + 1,
        ),
      );
    });
  }
}

```

### Simplificar handler de BLoC
- Se define un método que contiene la lógica.

``` dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState()) {
    on<CounterIncreased>(_onCounterIncreased);
  }

  void _onCounterIncreased(CounterIncreased event, Emitter<CounterState> emit) {
    emit(
      state.copyWith(
        counter: state.counter + event.value,
        transactionCount: state.transactionCount + 1,
      ),
    );
  }
}
```

## 2. Utilizar Counter Bloc
1. Se debe envolver a los widgets con el provider, lo cual permite tener la primera instancia del provedor.
``` dart
class BlocCounterScreen extends StatelessWidget {
  const BlocCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => CounterBloc(), child: BlocCounterView());
  }
}
```
2. Usar context.select para escoger el bloc deseado y leer su valor.

``` dart
Center(
          child: context.select((CounterBloc counterBloc) =>
              Text('Counter values: ${counterBloc.state.counter}'))),
```

3. Crear método para invocar evento de incremento de contador.
  - Con el uso de context.read se busca la instancia de CounterBloc en el árbol de componentes, en donde se tiene el método add que permite disparar eventos.

``` dart
  void increaseCounterBy(BuildContext context, [int value = 1]) {
    context.read<CounterBloc>().add(CounterIncreased(value));
  }
```

4. Invocar método en componentes deseados.

## Opcional. Disparar eventos dentro del BLoC
- Se crea un método dentro de counter_bloc.
- add es un método que ya viene heredado de bloc.

``` dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState()) {
    on<CounterIncreased>(_onCounterIncreased);
    on<CounterReset>(_onCounterReset);
  }

  void _onCounterIncreased(CounterIncreased event, Emitter<CounterState> emit) {
    emit(
      state.copyWith(
        counter: state.counter + event.value,
        transactionCount: state.transactionCount + 1,
      ),
    );
  }

  void _onCounterReset(CounterReset event, Emitter<CounterState> emit) {
    emit(
      state.copyWith(
        counter: 0,
      ),
    );
  }

  void increaseBy([int value = 1]) {
    add(CounterIncreased(value));
  }

  void resetCounter() {
    add(CounterReset());
  }
}

```

- Estos métodos son los que se llaman en los Widgets.

``` dart
  void increaseCounterBy(BuildContext context, [int value = 1]) {
    //context.read<CounterBloc>().add(CounterIncreased(value));
    context.read<CounterBloc>().increaseBy(value);
  }
```

# Sección 20. Manejo de formularios
## Temas
1. Tradicionales Stateful (Forms, TextFormField + Keys)
2. Con gestor de estado
3. Con gestor de estado + Data Input fields personalizados

## Funcionamiento
1. Se crea una llave que lleva referencia al estado del form y que se asocia al formulario, de forma que se usa para saber el formulario que se desea evaluar.
2. La llave se coloca en un stateful widget, ya que colocarlo en build haía que el estado se reinicia cada vez.
3. Se tiene el Widget Form.

## TextFormField vs TextField
1. TextFormField tiene una relación con un formulario, mientras que el otro no.

## Consideraciones con inputs y scroll
1. Al usar TextFormField se debe considerar la posición de este widget y la del teclado, ya que puede ser molesto que el teclado lo desplace.
  - Por otro lado, puede causar overflows so hay mucho contenido en la pantalla.
  - Se puede resolver lo anterior con SingleChildScrollView.

## Diseño del campo de texto
1. presentation -> screens -> register_screen.dart
- Se podría colocar el diseño en app_theme, sin embargo ese diseño sería el por defecto para todos.
- Se crea un Stateless Widget para darle el diseño deseado.
- Con el Widget de Form se tiene el control con el formulario.

2. presentation -> widgets -> inputs -> customs_text_form_field.dart

### TextFormField
- Se recomienda tener una variable el estilo para enabledBorder y focusedBorder.
- Entre sus campos se tiene:
  1. onChanged, el cual se invoca cada que se escribe en el input.
  2. validator, es un callback que validará el elemento cuando se dispare la validación.
  3. decoration, el cual recibe InputDecoration.
    - enabledBorder, estilo que se le da al border cuando se tiene seleccionado el elemento.
  4. isDense para hacer menos denso el input.
  5. label, el cual indica el nombre del input.
  6. hintText, recibe un string y es un placeholder.
  7. prefixIcon y suffixIcon.
  8. errorText, recibe un string y aparece apenas haya un error.
  9. errorBorder, se usa para dar estilo al input cuando hay error.
  10. obscureText, el cual se usa para contraseñas.

``` dart
class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final bool obscureText;
  final String? errorMessage;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.onChanged,
    this.validator,
    required this.obscureText,
  });
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
  );

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.primary),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
        label: label != null ? Text(label!) : null,
        hintText: hint,
        errorText: errorMessage,
      ),
      validator: validator,
    );
  }
}
```

## Formulario tradicional
1. presentation -> screens -> register_screen.dart
2. Convertir en un statefulWidget al formulario.
3. Definir key en nivel superio del estado.
4. Enlazar key con el Form.

``` dart
class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
```

5. Definir parámetros que se desean recuperar de los CustomTextField, los cuales se actualizan por medio de onChanged.

``` dart
class _RegisterFormState extends State<_RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        CustomTextFormField(
          label: 'username',
          onChanged: (value) => username = value,
        ),
        const SizedBox(
          height: 20,
```

6. Definir validaciones.
``` dart
        CustomTextFormField(
          label: 'username',
          onChanged: (value) => username = value,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Campo Requerido';
            if (value.trim().isEmpty) return 'Campo Requerido';
            if (value.length < 6) return 'Más de 6 letras';
            return null;
          },
        ),
```

7. En onPressed del botón que se tiene se usa la key para llamar a las validaciones.
  - se usa _formKey.currentState.validate();

``` dart
        FilledButton.tonalIcon(
          onPressed: () {
            final isValid = _formKey.currentState!.validate();
            if (!isValid) return;
          },
          icon: const Icon(Icons.save),
          label: const Text('Crear Usuario'),
        ),
```

- Expresión regular para validar email.

## Cubit
### 1. Register Form Cubit

- Con Cubit es posible ir viendo las validaciones cada que se va escribiendo en el input.
  - Esto es posible sin usar gestor de estado, pero simpifica la lógica.
  - Se usa Cubit acá ya que es algo pequeño.
1. presentation -> blocs 
  - Crar cubit register.
2. estado de cubit (register_state.dart)
  - En una sola clase se gestiona el estado del formulario.
  - Se crea una enumeración para los posibles resultados.

3. Definir copyWith para poder emitir un nuevo estado.

``` dart
part of 'register_cubit.dart';

enum FormStatus { invalid, valid, validating, posting }

class RegisterFormState extends Equatable {
  final FormStatus formStatus;
  final String username;
  final String email;
  final String password;

  const RegisterFormState({this.username = '', this.email = '', this.password = '', this.formStatus = FormStatus.invalid});

  RegisterFormState copyWith({
    FormStatus? formStatus,
    String? username,
    String? email,
    String? password,
  }) =>
      RegisterFormState(
        formStatus: formStatus ?? this.formStatus,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  List<Object> get props => [formStatus, username, email, password];
}

```

5. Definior método en reguster_cubit.dart para saber cuándo cambian los campos.

``` dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterFormState> {
  RegisterCubit() : super(const RegisterFormState());

  void onSubmit() {
    print('Submit: $state');
  }

  void usernameChanged(String value) {
    emit(state.copyWith(username: value));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }
}

```

## 2. Conectar cubit con formulario
1. Conectar register_cubit con register_screen.dart
2. Envolver _RegisterView (se puede hacer en cualquier lado de este árbol de widgets, pero se escoge el punto más alto) con BlocProvider.

``` dart
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo usuario'),
      ),
      body: BlocProvider(create: (context) => RegisterCubit(), child: const _RegisterView()),
    );
  }
}
```

3. Eliminar parámetros de username ... propios del formulario, ya que cubit se ocupa de eso ahora.
4. Escucha registerCubit con context.watch
5. Invocar métodos de RegisterCubit para actualizar los campos necesarios.

``` dart
class _RegisterFormState extends State<_RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.watch<RegisterCubit>();
    return Form(
      key: _formKey,
      child: Column(children: [
        CustomTextFormField(
          label: 'username',
          onChanged: registerCubit.usernameChanged,
          ...
```

## Centralización de validaciones - formz
- Se considera que en lugar de tener a los campos username, email y password como Strings se haga una clase para cada uno.
1. Instalar formz.
2. Infrastructure -> inputs -> username.dart
3. Copiar código de muestra de Formz y cambiar nombre de la clase así como el nombre de la enum que enlista los errores que se van a manejar.
  - La clase de FormzInput especifica que el estado es un String y el enum de errores.
  - Si en enum de errores es nulo entonces pasa la validaciones por defecto.
  - Se llama a la clase padre con pure para inicializar el estado.
  - Con dirty es la forma de especificar cómo se desea cambia el valor.
    - Se especifica si se reciben argumentos de forma posicional o con nombre.

``` dart
import 'package:formz/formz.dart';

// Define input validation errors
enum UsernameError { empty, lenght }

// Extend FormzInput and provide the input type and error type.
class Username extends FormzInput<String, UsernameError> {
  // Call super.pure to represent an unmodified form input.
  const Username.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Username.dirty({String value = ''}) : super.dirty(value);

  // Override validator to handle validating a given input value.
  @override
  UsernameError? validator(String value) {
    return value.isEmpty ? UsernameError.empty : null;
  }
}
```

4. Definir valifaciones.

``` dart
import 'package:formz/formz.dart';

// Define input validation errors
enum UsernameError { empty, lenght }

// Extend FormzInput and provide the input type and error type.
class Username extends FormzInput<String, UsernameError> {
  // Call super.pure to represent an unmodified form input.
  const Username.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Username.dirty(String value) : super.dirty(value);

  // Override validator to handle validating a given input value.
  @override
  UsernameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return UsernameError.empty;
    if (value.length < 6) return UsernameError.lenght;
    return null;
  }
}
```

### Usar inputs personalizados
- Se colocan en RegisterState de cubit.
  - username ya no es String, ahora es de tipo Username, y llamar Username.pure para inicializar.

``` dart
part of 'register_cubit.dart';

enum FormStatus { invalid, valid, validating, posting }

class RegisterFormState extends Equatable {
  final FormStatus formStatus;
  final bool isValid;
  final Username username;
  final String email;
  final String password;

  const RegisterFormState({
    this.isValid = false, // Por defecto los formularios son inválidos.
    this.username = const Username.pure(),
    this.email = '',
    this.password = '',
    this.formStatus = FormStatus.invalid,
  });

  RegisterFormState copyWith({
    FormStatus? formStatus,
    Username? username,
    bool? isValid,
    String? email,
    String? password,
  }) =>
      RegisterFormState(
        formStatus: formStatus ?? this.formStatus,
        isValid: isValid ?? this.isValid,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  List<Object> get props => [formStatus, username, email, password];
}

```

- Usar Username.pure al momento de actualizar el estado en RegisterCubit.
- Se usa el constructor con mobre validate de Formz para especificar los campos a validar.
  - Pide el listado de data de tipo FormsInput (Username), y manda a llamar la validación de cada uno.
  - Se deben colocar todos los campos del formulario para que pueda determinar si el formulario es válido. Por el momento solo s epone username, pero debe estar también password y email.

``` dart
  void usernameChanged(String value) {
    final username = Username.dirty(value);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([username]),
      ),
    );
  }

```

- Comentar líneas de key para validación en botón de submit en register_screen, ya que ahora esa parte se maneja en el estado.

``` dart
        FilledButton.tonalIcon(
          onPressed: () {
            //final isValid = _formKey.currentState!.validate();
            //if (!isValid) return;

            registerCubit.onSubmit();
          },
          icon: const Icon(Icons.save),
          label: const Text('Crear Usuario'),
        ),
```

### Centralizar errores en el input
1. Se crea un getter opcional en la clase de username, password y email.
  - Se tienel a propiedad displayError, la cual debe pasarse a toString.
  - Usar en las condiciones isPure (username.isPure) para evitar que el campo se marque como error al momento de hacerle click y esperar a que el usuario empiece a interactuar con él.

``` dart
  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == UsernameError.empty) return 'El campo es requerido';
    if (displayError == UsernameError.length) return 'Mínimo 6 caracteres';

    return null;
  }
```

### Mostrar errores en la pantalla
- RegisterScreen, ReigsterForm
  - Ya no se necesita el key para el formulario, ya que eso se delega para el gestor de estado.
  - El Stateful Widget se convierte en Stateles
1. Se leen los estados de registerCubit
``` dart
class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.watch<RegisterCubit>();
    final username = registerCubit.state.username;
    final password = registerCubit.state.password;
    final email = registerCubit.state.email;

```
2. Quitar callback de validatos de CustomTextFormField y definir errorMessage.
``` dart
        CustomTextFormField(
          label: 'username',
          onChanged: registerCubit.usernameChanged,
          errorMessage: username.errorMessage,
        ),
```
3. Definir función onSubmit en regiser_cubit.dart.

``` dart
  void onSubmit() {
    emit(
      state.copyWith(
          formStatus: FormStatus.validating,
          username: Username.dirty(state.username.value),
          password: Password.dirty(state.password.value),
          email: Email.dirty(state.email.value),
          isValid: Formz.validate([state.username, state.password, state.email])),
    );
  }
```

# Notas
## Part y part of
- Se utilizan para indicar que los archivos son parte de un único archivo, tal como se presenta en:
  - counter_cubit.dart
  - counter_state.dart
## buildWhen de BlocBuilder
- buildWhen solo debería usarse cuando se tiene una condición muy específica.
## Crear blocs y cubits con extensión bloc.
- Se debe modificar la importación que por defecto deja la extensión de bloc o cubit por flutter bloc o flutter cubit.
## Cubit
- Es correcto hacer varios emisiones de estado, tal cómo hacerlo en una función de onSubmit,ya que es eficiente el proceso.
## Clean Code
- No se aconseja colocar el nombre de la implementación en la clase:
- MAL
``` dart
import 'package:formz/formz.dart';

// Define input validation errors
enum UsernameError { empty, lenght }

// Extend FormzInput and provide the input type and error type.
class UsernameInput extends FormzInput<String, UsernameError> {

}
```

- BIEN
``` dart
import 'package:formz/formz.dart';

// Define input validation errors
enum UsernameError { empty, lenght }

// Extend FormzInput and provide the input type and error type.
class Username extends FormzInput<String, UsernameError> {

}
```

- Por defecto un formulario no es válido al inicio, ya que están vacíos los campos.