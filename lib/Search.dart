import 'package:ecommerce/Pages/ProductDetails.dart';
import 'package:ecommerce/Widgets/VoiceToText.dart';
import 'package:ecommerce/Widgets/barcode.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/Model/Products_model.dart';

// import 'package:mobile_project/pages/details.dart';
// import 'package:mobile_project/widget/VoiceToText.dart';
class ProductSearchDelegate extends SearchDelegate<Product> {
  final List<Product> products;
  final String selectedCategoryKey;
  final String selectedProductKey;
  // final Function(Product) onProductSelected;
  // final Function(Product) onAddToCart;
  // final Function(Product) onAddToFavorites;
  // final Map<Product, bool> isFavorite;

  ProductSearchDelegate({
    required this.products,
    required this.selectedCategoryKey,required this.selectedProductKey,
    // required this.onProductSelected,
    // required this.onAddToCart,
    // required this.onAddToFavorites,
    // required this.isFavorite,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
    ));
  }

  @override
  String? get searchFieldLabel => "Search for coffee and donuts";
  @override
  InputDecorationTheme? get searchFieldDecorationTheme =>
      const InputDecorationTheme(
        outlineBorder: BorderSide(color: Colors.black),
        fillColor: Colors.black,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      );

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
        color: Colors.white,
        fontSize: 15,
      );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
      VoiceSearchWidget(
        onQueryChanged: (newQuery) {
          query = newQuery;
        },
      ),
      IconButton(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BarcodeScannerScreen()));
          },
          icon: const Icon(Icons.barcode_reader)),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase()) ||
            product.barcode.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: results
            .map(
              (product) => ListTile(
                title: Text(product.title),
                onTap: () {
                  // onProductSelected(product);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          selectedCategoryKey: selectedCategoryKey,
                          selectedProductKey: selectedProductKey,
                              category: product.category,
                              name: product.title,
                              stock: product.stock,
                              price: product.price,
                              Description: product.description,
                            )),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase()) ||
            product.barcode.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: suggestions
            .map(
              (product) => ListTile(
                title: Text(
                  product.title,
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
                onTap: () {
                  // onProductSelected(product);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetails(
                              selectedCategoryKey: selectedCategoryKey,
                              selectedProductKey: selectedProductKey,
                              category: product.category,
                              name: product.title,
                              stock: product.stock,
                              price: product.price,
                              Description: product.description,
                            )),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
