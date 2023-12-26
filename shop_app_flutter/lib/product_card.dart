import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String product;
  final double price;
  final String image;
  final Color backgroundColor;
  const ProductCard(
      {super.key,
      required this.product,
      required this.price,
      required this.image,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text('\$$price', style: Theme.of(context).textTheme.bodySmall),
          Center(
            child: Image.asset(
              image,
              height: 150,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
