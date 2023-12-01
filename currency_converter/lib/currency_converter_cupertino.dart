import 'package:flutter/cupertino.dart';

class CurrencyConverterCupertinoPage extends StatefulWidget {
  const CurrencyConverterCupertinoPage({super.key});

  @override
  State<CurrencyConverterCupertinoPage> createState() => _CurrencyConverterCupertinoPageState();
}

class _CurrencyConverterCupertinoPageState extends State<CurrencyConverterCupertinoPage> {

  double result = 0;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.activeBlue,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor:CupertinoColors.activeOrange,
        middle: Text('Currency Converter', 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 10
        )),
      ),
      child: ColoredBox(
        color: const Color.fromARGB(255, 104, 167, 199), // Color de Center
        child: Center(
          child: ColoredBox(
            color: const Color.fromARGB(111, 32, 104, 199), // Color de Column
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,        
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                result.toString(), 
                style: const TextStyle(
                  color: Color.fromARGB(255, 243, 244, 245),
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: CupertinoTextField(
                    controller: textEditingController,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true
                    ),
                    placeholder: 'Pleaser enter the amount in USD',
                    prefix: const Icon(CupertinoIcons.money_dollar),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CupertinoButton(
                    onPressed: () {
                       setState(() {
                          result = double.parse(textEditingController.text);
                       });
                    },
                    color: CupertinoColors.black,
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