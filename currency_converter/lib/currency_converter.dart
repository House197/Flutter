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
      body: ColoredBox(
        color: const Color.fromARGB(255, 104, 167, 199), // Color de Center
        child: Center(
          child: ColoredBox(
            color: const Color.fromARGB(111, 32, 104, 199), // Color de Column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,        
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('0', style: TextStyle(
                  color: Color.fromARGB(255, 243, 244, 245),
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}