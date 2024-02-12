# Instalación en Linux
Video guía.
https://www.youtube.com/watch?v=CD1Y2DmL5JM&t=24s

Página de Flutter para instalación.
https://docs.flutter.dev/get-started/install

Se instala usando ***SNAPD***, el cual ya viene preinstalado en versiones de Ubuntu a partir de la 18.04.

![[Pasted image 20230724080122.png]]

![[Pasted image 20230724080540.png]]

## Problema: WARNING: DART ON YOUR PATH RESOLVES TO ...

### Solución definitiva
Se eliminó la carpeta de Flutter del sistema y se vuelve a ejecutar flutter sdk-path.

![[Pasted image 20230725085943.png]]


### Descripción problema
Al ejecutar el comando de flutter doctor es posible tener el siguiente error, el cual se puede corregir eliminando la carperta de cache en flutter y volviendo a ejectuar el comando.

![[Pasted image 20230724082333.png]]

### Soluciones

![[Pasted image 20230724082431.png]]

O

![[Pasted image 20230724082457.png]]


![[Pasted image 20230724080839.png]]

![[Pasted image 20230724082542.png]]

![[Pasted image 20230724082807.png]]

Ubuntu utiliza .bashrc, el cual puede ser editado al correr code . en el directorio de user.

![[Pasted image 20230725091106.png]]


## Instalación de Android Studio
https://www.youtube.com/watch?v=5cVOnXchj2g

# Instalación Windows
## Android Studio
- Se descarga desde el sitio oficial: https://developer.android.com/studio/?hl=es-419.
https://www.udemy.com/course/flutter-cero-a-experto/learn/lecture/36195920#overview

## Error: Unable to find git in path
https://codingislove.com/unable-to-find-git-path-flutter/

- This happens because of a security update from git where Git now checks for ownership of the folder trying to ensure that the folder you are using Git in has the same user as the owner as your current user account.
- Git considers all repos as unsafe be default on Windows because of this security update.
- To fix this, we need to mark our repos as safe using the following command:

``` bash
git config --global --add safe.directory '*'
```

- Restart your terminals and VS Code after running this command. This should fix the issue
- If you don’t want to mark all the repos as safe, then you can mark only the flutter repo as safe by passing the flutter path instead of *.

``` bash
git config --global --add safe.directory C:\Users\someUser\flutter\.git\
```

- The above fix will work if you have git installed along with it added to PATH environment variable.
- If you don’t have git installed, then install it and make sure that the git folder’s path is mentioned in the PATH environment variable.

### Ignorar
- Para poder ejecutar flutter doctor en terminal, usando PowerShell, se debe abrir la terminal como admin.
    - Por otro lado, si lo anterior no funciona también se agregó el bin de git al PATH de Windows.

## Emuladores - Windows
https://www.udemy.com/course/flutter-cero-a-experto/learn/lecture/36198690?start=15#overview
- El emulador con lo que se pudo correr fue pie, android 9.0

## Testeo
- Con CTRL + SHIFT + P para abrir la paleta de comando y escribir Flutter: New Project.
- Se abre de nuevo la paleta de comando y se selecciona la opción: Flutter: Select Device.
    - En caso de que el emulador deseado estuviera apagado se puede prender desde ahí.
- Se preisona F5 para iniciar el desarrollo. Si no es posible, se corre como Without Debugging desde el botón que aparece en el lado superio derecho teniendo el archivo del proyecto abierto.

## Extensiones VS
- Dart
- Flutter

## Android Físico
https://www.udemy.com/course/flutter-cero-a-experto/learn/lecture/36229146#overview
- Se debe habilitar Developer Mode en el celular.
- Se habulita USB Debugging en celular y Staw Awake.
- Se conecta el celular a la computadora, se selecciona SELECT DEVICE y se corre la aplicación.
- En caso de no poder lanzar la aplicación se tienen las siguiente recomendaciones para xiaomi.
https://stackoverflow.com/questions/47239251/install-failed-user-restricted-android-studio-using-redmi-4-device

<img src='Images\xiaomi.png'></img>

