# Dart
- Lenguaje del lado del cliente optimizado para aplicaciones.
    - Está optimizado para UI.
    - Permite Hot Reload.
    - Rápido en todas las plataformas (ARM y x64)

## Características
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

## Diferencia entre const y late
- Late asigna el valor a la variable en tiempo de ejecución.
- Const asigna el valor a la variable en tiempo de construcción.
- El uso de final al declarar variable es más rápido, ya que no viene la parte de los Setters para cambiar su valor.

## Variables
### Uso de ?
- Especifica que una variable puede ser nula.
``` dart
int? a = null;
```

### Listas
- Si no se especifica el tipo de datos de una lista entonces Dart lo infiere.

``` dart
final abilities = ['impostor']
```

- Se especifica el tipo usando <> antes del valor que se asigna. De igual forma, se puede colocar List<> antes del nombre de la variable.

``` dart
final abilities = <String>['impostor'];
final List<String>abilities = ['impostor'];
```