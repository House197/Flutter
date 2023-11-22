import 'package:flutter/material.dart';

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