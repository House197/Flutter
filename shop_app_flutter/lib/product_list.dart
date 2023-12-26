import 'package:flutter/material.dart';
import 'package:shop_app_flutter/global_variables.dart';
import 'package:shop_app_flutter/product_card.dart';
import 'package:shop_app_flutter/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const ['All', 'Adidas', 'Nike', 'Bata'];
  late String selectedFilter;
  // No se puede inicializar un valor inicializado para inicializar a otro, por ello se coloca late para poder incializaro en initState.

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    selectedFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size; // (Inherited Widget)
    //final size = MediaQuery.sizeOf(
    //   context); // Solo se escucha por cambios en el size en lugar de cambios en todas las opciones que tiene MediaQuery. (Inherited Model)
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(50),
      ),
    );

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Shoes\nCollection',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 120,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Chip(
                      label: Text(
                        filter,
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      backgroundColor: selectedFilter == filter
                          ? Theme.of(context).colorScheme.primary
                          : const Color.fromRGBO(245, 247, 249, 1),
                      side: const BorderSide(
                        color: Color.fromRGBO(245, 247, 249, 1),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 650) {
                return GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Dos Rows
                    childAspectRatio:
                        2, // Permite definir el radio entre width y height de las grid
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index]['title'];
                    final price = products[index]['price'];
                    final image = products[index]['imageUrl'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return ProductDetails(product: products[index]);
                          }),
                        );
                      },
                      child: ProductCard(
                        product: product as String,
                        price: price as double,
                        image: image as String,
                        backgroundColor: index.isOdd
                            ? const Color.fromRGBO(245, 247, 249, 1)
                            : const Color.fromRGBO(216, 240, 253, 1),
                      ),
                    );
                  },
                );
              }
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index]['title'];
                  final price = products[index]['price'];
                  final image = products[index]['imageUrl'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return ProductDetails(product: products[index]);
                        }),
                      );
                    },
                    child: ProductCard(
                      product: product as String,
                      price: price as double,
                      image: image as String,
                      backgroundColor: index.isOdd
                          ? const Color.fromRGBO(245, 247, 249, 1)
                          : const Color.fromRGBO(216, 240, 253, 1),
                    ),
                  );
                },
              );
            },
          ))
        ],
      ),
    );
  }
}
