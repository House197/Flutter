# Arquitectura Limpia
## Entidades
- Son las representaciones que la empresa necesita.
    - Una entidad se refiere a un fragmento de información, carácter, palabra, objeto o unidad abstracta que puede abarcar distintos usos dependiendo su uso.
- Se puede pensar en ellas como objetos o entes que son y serán idénticos entre diferentes aplicaciones de nuestra empresa.
- Por ejemplo, pueden ser tomando la aplicación de Cinemapedia:
    - Clientes.
    - Productos.
    - Películas.
- Los conceptos en la lista de ejemplo anterior son conceptos elevados en las reglas de negocio.
- Un cliente en la aplicación 'A', es el mismo que en la aplicación 'B', 'C', 'D' etc.
    - Deberían ser iguales o casi idénticos.

## Datasource
- Fuente de datos.
- No debería importar de dónde venga la data.

### Abstractos
- Se definen las reglas de negocio que todas las implementaciones deben seguir.

### Implementaciones
- Es el código que termina llamando a la API.

## Repositories
- Llaman los origeners de datos.
- Deben ser flexibles para poder cambiarlos en cualquier momento sin afectar a la aplicación.
- Si en el futuro se desea cambiar el origen de dato, el repositorio fácilmente debe permitir el cambio.

### Abstractos
- Se definen las reglas de negocio que todas las implementaciones deben seguir.

### Implementaciones
- Es la clase instanciada que se va a usar.
- Normalmente recibe como argumento el datasource o varios de éstos.
- La implementación es la clase que implementa el mecanismo que se desea.

## Gestor de estado
- Sirve de puente entre casos de uso (en este caso el repositorio) y realizan los cambios visuales en los Widgets.
- En caso de una implementación completa de arquitectura limpia, el gesto de estado llama casos de uso, y éstos al repositorio.
- Cuando se habla de gestor de estado normalmente se habla de la comunicación que hay entre la UI y las capas anteriores mencionadas.

# Resumen
- Las entidades son atómicas.
    - Son la unidad más pequeñas.
    - Usualmente no debería haber herencia.
- Los repositorios (la implementación)  llaman Datasources.
- Las implementaciones de los Datasources son quienes hacen el trabajo.
- El gestor de estado es el puente que ayuda a realizar los cambios en el UI.