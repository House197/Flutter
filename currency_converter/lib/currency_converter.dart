import 'package:flutter/material.dart';

class CurrencyConverterMaterialPage extends StatelessWidget {

  const CurrencyConverterMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ColoredBox(
        color: Colors.blueGrey, // Color de Center
        child: Center(
          child: ColoredBox(
            color: Color.fromARGB(111, 32, 104, 199), // Color de Column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,        
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Currency Converter', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10
                )),
                Text('Converter Page', style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold
                )),
                TextField(
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                  decoration: InputDecoration(
                    label: Text('Converter', style: TextStyle(color: Colors.black)),
                    hintText: 'Enter the amount to be converted.',
                    prefixText: 'Amount: ',
                    prefixIcon: Icon(Icons.monetization_on),
                    prefixIconColor: Colors.white,
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignOutside
                      ),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(60)
                        )
                    )
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