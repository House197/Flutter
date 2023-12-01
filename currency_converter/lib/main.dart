import 'package:currency_converter/currency_converter.dart';
import 'package:currency_converter/currency_converter_cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main () {
  // MyApp lleva parentesis porque es una clase, por lo que se esta creando una instancia
  // const indica que el constructor es una constante en el compile time, lo cual indica a Flutter que la instancia de Widget creada no debe ser recreada cada vez. Se debe recrear solo una vez.
  runApp(const MyCupertinoApp());
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
    return const MaterialApp(
      // Se requiere de la propiedad home, la cual requiere de Scaffold que necesita la propiedad de body.
      home: CurrencyConverterMaterialPage()
    );
  }
}

class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: CurrencyConverterCupertinoPage(),
    );
  }
}