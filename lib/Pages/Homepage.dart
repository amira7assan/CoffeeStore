import 'package:ecommerce/Auth.dart';
import 'package:ecommerce/DataBaseService.dart';
import 'package:ecommerce/Model/Products_model.dart';
import 'package:ecommerce/Pages/ProductDetails.dart';
import 'package:ecommerce/Pages/signIn.dart';
import 'package:ecommerce/Search.dart';
import 'package:ecommerce/Services.dart';
import 'package:ecommerce/Widgets/inputs/AuthTextField.dart';
import 'package:ecommerce/Pages/signUp.dart';
import 'package:ecommerce/Widgets/inputs/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  String? selectedCategoryKey;
  String? selectedCategoryName;
  final Databaseservice _firebaseService = Databaseservice();
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  List<Map<String, dynamic>> products = [];
  List<Product> allProducts = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    try {
      final data = await _firebaseService.getAllProducts();
      setState(() {
        allProducts = data;
        for (var i = 0; i < allProducts.length; i++) {
          print(allProducts[i].category);
        }
      });
    } catch (e) {
      print("Error handling all products");
    }
  }

  Future<void> fetchProducts(String categoryKey) async {
    try {
      final data = await _firebaseService.getProducts(categoryKey);
      setState(() {
        products = data;
        print("length ${data.length}");
      });
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  Future<void> fetchCategories() async {
    try {
      final data = await _firebaseService.getCategories();
      setState(() {
        categories = data;
        if (categories.isNotEmpty) {
          selectedCategoryKey = categories.first['key'];
          selectedCategoryName = categories.first['name'];
          fetchProducts(selectedCategoryKey!);
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        print("error loading data from database: $e");
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.sizeOf(context).width;
    double deviceheight = MediaQuery.sizeOf(context).height;
    TextEditingController addCategoryController = TextEditingController();
    TextEditingController updateCategoryController = TextEditingController();
    TextEditingController addProductNameController = TextEditingController();
    TextEditingController addProductPriceController = TextEditingController();
    TextEditingController updateProductPriceController =
        TextEditingController();
    TextEditingController updateProductNameController = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 100,
          elevation: 1,
          leading: IconButton(
            onPressed: () async {
              try {
                Auth().signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Signed out successfully!")));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => signIn()),
                    (Route<dynamic> route) => false);
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.message!)));
              }
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
          actions: const [
            Icon(
              Icons.account_circle,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(
              width: 15,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Find the best\ncoffee for you",
                  style: TextStyle(
                      fontSize: 32,
                      fontFamily: "poppins",
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 54,
                  width: 351,
                  child: GestureDetector(
                    onTap: () {
                      showSearch(
                          context: context,
                          delegate: ProductSearchDelegate(
                              products: allProducts,
                              selectedCategoryKey: selectedCategoryKey!,
                              selectedProductKey: products[0]['key']));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: AppColors.textFieldFillColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/search.png",
                            scale: 2,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Find your coffee...",
                            style: TextStyle(
                                fontFamily: "poppins",
                                color: AppColors.textFieldHintColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  // color: Colors.red,
                  height: 40,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected =
                                selectedCategoryKey == category['key'];
                            return GestureDetector(
                                onLongPress: () {},
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedCategoryKey = category['key'];
                                      selectedCategoryName = category['name'];
                                    });
                                    products = [];
                                    fetchProducts(selectedCategoryKey!);
                                    print(
                                        "Selected Category Key: $selectedCategoryKey");
                                  },
                                  child: Text(
                                    category['name'],
                                    style: TextStyle(
                                        color: isSelected
                                            ? AppColors.primaryColor
                                            : AppColors.disabledCategoryColor,
                                        fontFamily: "poppins",
                                        fontSize: 16),
                                  ),
                                ));
                          }),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: 310,
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : (selectedCategoryKey != null
                            ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetails(
                                                    selectedProductKey:
                                                        product['key'],
                                                    selectedCategoryKey:
                                                        selectedCategoryKey!,
                                                    category:
                                                        selectedCategoryName!,
                                                    name: product['name'],
                                                    stock: product['stock'],
                                                    price: product['price'],
                                                    Description:
                                                        product['description'],
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      height: 300,
                                      width: 200,
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                tileMode: TileMode.mirror,
                                                colors: <Color>[
                                                  Color.fromRGBO(
                                                      56, 55, 55, 1.0),
                                                  Color.fromRGBO(
                                                      17, 16, 16, 0.99),
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(29)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              "assets/images/capp1.png",
                                              scale: 1,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6.0),
                                              child: Text(
                                                selectedCategoryName!,
                                                style: const TextStyle(
                                                    fontFamily: "poppins",
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6.0),
                                              child: Text(
                                                product['name'],
                                                style: const TextStyle(
                                                    fontFamily: "poppins",
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 0.51),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6.0),
                                                  child: Row(
                                                    children: [
                                                      Text("\$",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "poppins",
                                                              color: AppColors
                                                                  .primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16)),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "${product['price']}",
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                "poppins",
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                product['rate'] != null
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Icon(
                                                            Icons.star,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "${product['rate']}",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .yellow),
                                                          ),
                                                        ],
                                                      )
                                                    : const Text(
                                                        "  No Ratings",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.yellow),
                                                      ),
                                                Expanded(
                                                  child: IconButton(
                                                    onPressed: () {
                                                      if (product['stock'] >
                                                          0) {
                                                        Auth().addToCart(
                                                            context,
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!,
                                                            selectedCategoryName!,
                                                            product['name'],
                                                            product['price'],
                                                            1,selectedCategoryKey!, product['key'],);

                                                        Databaseservice().updateStock(
                                                            selectedCategoryKey!,
                                                            product['key'],
                                                            product['stock'] -
                                                                1);
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        "This item is out of stock")));
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        size: 30,
                                                        Icons
                                                            .add_shopping_cart),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                            : const Center(
                                child: Text(
                                  "Select a Cateogy",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Special For you",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: AppColors.productContainerColor,
                      borderRadius: BorderRadius.circular(29)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/capp1.png",
                        scale: 3,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "5 Coffee beans for you\nMust try",
                        style: TextStyle(
                            fontFamily: "poppins",
                            color: Colors.white,
                            fontSize: 15),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}





















// class CategoryItem extends StatelessWidget {
//   final String name;

//   const CategoryItem({super.key, required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 5),
//       child: Center(
//           child: SizedBox(
//               width: 150,
//               child: TextButton(
//                   onPressed: () {},
//                   child: Text(
//                     name,
//                     style: TextStyle(
//                         color: AppColors.disabledCategoryColor,
//                         fontFamily: "poppins",
//                         fontSize: 16),
//                   )))),
//     );
//   }
// }

// class ProductItem extends StatelessWidget {
//   final String image;
//   final String title;
//   final String subtitle;
//   final String price;

//   const ProductItem(
//       {super.key,
//       required this.image,
//       required this.title,
//       required this.subtitle,
//       required this.price});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300,
//       width: 200,
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//             color: AppColors.productContainerColor,
//             borderRadius: BorderRadius.circular(29)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               image,
//               scale: 1,
//             ),
//             const SizedBox(
//               width: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 6.0),
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                     fontFamily: "poppins",
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 20),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 6.0),
//               child: Text(
//                 subtitle,
//                 style: const TextStyle(
//                     fontFamily: "poppins",
//                     color: Color.fromRGBO(255, 255, 255, 0.51),
//                     fontWeight: FontWeight.w400,
//                     fontSize: 14),
//               ),
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 6.0),
//                   child: Row(
//                     children: [
//                       Text("\$",
//                           style: TextStyle(
//                               fontFamily: "poppins",
//                               color: AppColors.primaryColor,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16)),
//                       const SizedBox(
//                         width: 4,
//                       ),
//                       Text(
//                         price,
//                         style: const TextStyle(
//                             fontFamily: "poppins",
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 34,
//                   width: 36,
//                   decoration: BoxDecoration(
//                       color: AppColors.primaryColor,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: const Icon(
//                     Icons.add,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

