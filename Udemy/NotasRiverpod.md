# Provider Type
## Provider
- Retorna cualquier tipo.
- Sive para regresar un valor en específico.
- Puede verse como crearse una referencia a algún objeto o variable, y ase puede obtener esa info por medio de ref.
- Es inmutable.

## StateProvider
- Retorna cualquier tipo.
- Realiza la configuración en automático para manejar algún String, algún objeto, etc.

## ChangeNotifierProvider
- Retorna una subclasse de una ChaneNotifier.
- Brinda más flexibilidad a la manera en cómo puede cambiar el estado.
    - Se pueden crear evento de cómo cuando el inputs del email cambia o el password, y después se va a querer ejecutar algo cuando se hace el submit del formulario.

# Snippets
- Se tienen con la extensión Flutter Riverpod Snippets

# Uso de watch y read
- En funciones se debe usar read, no watch.
- En providers se debe usar watch.