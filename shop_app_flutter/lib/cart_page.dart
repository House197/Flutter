import 'package:flutter/material.dart';
import 'package:shop_app_flutter/global_variables.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
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
