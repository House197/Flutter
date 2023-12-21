import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_flutter/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
    //final cart = Provider.of<CartProvider>(context).cart;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final cartItem = cart[index];
          final title = cartItem['title'].toString();
          final size = cartItem['size'];
          final image = cartItem['imageUrl'] as String;

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(image),
            ),
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Delete Product',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      content: const Text(
                          'Are you sure you want to remove this product?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<CartProvider>()
                                .removeProduct(cartItem);
                            //Provider.of<CartProvider>(context, listen: false)
                            //   .removeProduct(cartItem);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            subtitle: Text('Size: $size'),
          );
        },
      ),
    );
  }
}
