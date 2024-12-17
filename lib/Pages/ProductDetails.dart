import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Auth.dart';
import 'package:ecommerce/DataBaseService.dart';
import 'package:ecommerce/Model/Products_model.dart';
import 'package:ecommerce/Widgets/inputs/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetails extends StatefulWidget {
  final String category;
  final String name;
  final int stock;
  final String price;
  final String Description;
  final String selectedCategoryKey;
  final String selectedProductKey;
  // final String rates;
  const ProductDetails(
      {super.key,
      required this.name,
      required this.stock,
      required this.price,
      required this.Description,
      required this.category,
      required this.selectedCategoryKey,
      required this.selectedProductKey});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final Databaseservice _firebaseService = Databaseservice();
  Map<String, dynamic> product = {};
  bool _isExpanded = false;
  double rating = 0;

  @override
  void initState() {
    super.initState();
    fetchSpecificProduct(widget.selectedCategoryKey, widget.selectedProductKey);
  }

  Future<void> fetchSpecificProduct(
      String categoryKey, String productKey) async {
    try {
      final DatabaseReference productRef = FirebaseDatabase.instance
          .ref('Categories/$categoryKey/products/$productKey');

      final DataSnapshot snapshot = await productRef.get();

      if (snapshot.exists) {
        setState(() {
          product = Map<String, dynamic>.from(snapshot.value as Map);
        });
        setState(() {
          rating = product['rate'] != null ? product['rate'].toDouble() : 0.0;
        });

        print("Rating is$rating");
        print("Fetched Product: $product");
      } else {
        print("Product not found!");
      }
    } catch (e) {
      print("Error fetching product: $e");
    }
  }

  //   final Databaseservice _firebaseService = Databaseservice();
  // String? selectedCategoryKey;

  //   List<Map<String, dynamic>> categories = [];

  // final bool _isSSelected = false;
  // final bool _isMSelected = false;
  // final bool _isLSelected = false;
  // Color SFillColor = AppColors.defaultSizeButtonColor;
  // Color MFillColor = AppColors.defaultSizeButtonColor;
  // Color LFillColor = AppColors.defaultSizeButtonColor;
  // Color SborderColor = Colors.transparent;
  // Color MborderColor = Colors.transparent;
  // Color LborderColor = Colors.transparent;
  // Color SColor = Colors.white.withOpacity(0.52);
  // Color MColor = Colors.white.withOpacity(0.52);
  // Color LColor = Colors.white.withOpacity(0.52);
  //  Future<void> fetchCategories() async {
  //   try {
  //     final data = await _firebaseService.getCategories();
  //     setState(() {
  //       categories = data;
  //       if (categories.isNotEmpty) {
  //         selectedCategoryKey = categories.first['key'];
  //       }

  //     });
  //   } catch (e) {
  //       print("error loading data from database: $e");

  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // print(widget.selectedCategoryKey);
    // print( widget.selectedProductKey);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                    // color: Colors.red,
                    height: 500,
                    width: MediaQuery.sizeOf(context).width,
                    child: Image.asset(
                      fit: BoxFit.contain,
                      "assets/images/cappuccino.png",
                      height: 500,
                    )),
                SizedBox(
                  height: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        height: 137,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromRGBO(30, 14, 0, 0.67),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.category,
                                      style: const TextStyle(
                                        fontFamily: "poppins",
                                        fontSize: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      widget.name,
                                      style: TextStyle(
                                        fontFamily: "poppinslight",
                                        fontSize: 18,
                                        color: Colors.white.withOpacity(0.51),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 25,
                                          color: AppColors.primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        const Text(
                                          "4.5",
                                          style: TextStyle(
                                              fontFamily: "poppins",
                                              fontSize: 20,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 43,
                                              width: 46,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/beans.png",
                                                    scale: 2,
                                                  ),
                                                  Text(
                                                    "Coffee",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white
                                                            .withOpacity(0.51),
                                                        fontFamily:
                                                            "poppinslight"),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 43,
                                              width: 46,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/drop.png",
                                                    scale: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          height: 33,
                                          width: 117,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Center(
                                            child: Text(
                                              "Made With Love",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "poppinslight",
                                                  color: Colors.white
                                                      .withOpacity(0.51)),
                                            ),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 20, top: 40),
                  decoration: const BoxDecoration(color: Colors.transparent),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          height: 40,
                          width: 42,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromRGBO(56, 56, 56, 1),
                                    Color.fromRGBO(50, 50, 57, 1),
                                    Color.fromRGBO(45, 45, 52, 1),
                                    Color.fromRGBO(0, 0, 0, 1),
                                  ]),
                              borderRadius: BorderRadius.circular(8)),
                          child: IconButton(
                            onPressed: () {
                              Auth().addToFavorites(
                                  context,
                                  FirebaseAuth.instance.currentUser!,
                                  widget.category,
                                  widget.name,
                                  widget.price);
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Color.fromRGBO(255, 255, 225, 0.6),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              // color: Colors.green,
              padding: const EdgeInsets.only(right: 20),
              height: 100,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.83),
                        fontSize: 16,
                        fontFamily: "poppins"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(widget.Description,
                            maxLines: _isExpanded ? 3 : 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.83),
                                fontSize: 14,
                                fontFamily: "poppinslight")),
                      ),
                      if (!_isExpanded)
                        TextButton(
                          child: Text(
                            "read more",
                            style: TextStyle(
                                fontSize: 14, color: AppColors.primaryColor),
                          ),
                          onPressed: () {
                            setState(() {
                              _isExpanded = true;
                            });
                          },
                        ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 20),
              height: 120,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rate",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.51),
                        fontSize: 13,
                        fontFamily: "poppinlight"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$rating",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "poppinlight"),
                      ),
                    ],
                  ),
                  Center(
                    child: RatingBar.builder(
                        initialRating: rating,
                        allowHalfRating: true,
                        unratedColor: AppColors.disabledCategoryColor,
                        itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: AppColors.primaryColor,
                            ),
                        onRatingUpdate: (rate) {
                          setState(() {
                            rating = rate;
                          });
                          print(rating);
                          Databaseservice().updateRate(
                              widget.selectedCategoryKey,
                              widget.selectedProductKey,
                              rating);
                        }),
                  )
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Container(
                  //       width: 110,
                  //       height: 37,
                  //       decoration: BoxDecoration(
                  //           color: SFillColor,
                  //           border: Border.all(width: 1, color: SborderColor),
                  //           borderRadius: BorderRadius.circular(8)),
                  //       child: TextButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               _isSSelected = true;
                  //               SFillColor = Colors.black;
                  //               MFillColor = AppColors.defaultSizeButtonColor;
                  //               LFillColor = AppColors.defaultSizeButtonColor;
                  //               SborderColor = AppColors.primaryColor;
                  //               MborderColor = Colors.transparent;
                  //               LborderColor = Colors.transparent;
                  //               SColor = AppColors.primaryColor;
                  //               MColor = Colors.white.withOpacity(0.52);
                  //               LColor = Colors.white.withOpacity(0.52);
                  //             });
                  //           },
                  //           style: const ButtonStyle(
                  //             padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  //           ),
                  //           child: Text(
                  //             "S",
                  //             style: TextStyle(
                  //                 fontSize: 20,
                  //                 color: SColor,
                  //                 fontFamily: "poppins"),
                  //           )),
                  //     ),
                  //     Container(
                  //       width: 110,
                  //       height: 37,
                  //       decoration: BoxDecoration(
                  //           color: MFillColor,
                  //           border: Border.all(width: 1, color: MborderColor),
                  //           borderRadius: BorderRadius.circular(8)),
                  //       child: TextButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               _isMSelected = true;
                  //               MFillColor = Colors.black;
                  //               SFillColor = AppColors.defaultSizeButtonColor;
                  //               LFillColor = AppColors.defaultSizeButtonColor;
                  //               MborderColor = AppColors.primaryColor;
                  //               SborderColor = Colors.transparent;
                  //               LborderColor = Colors.transparent;
                  //               MColor = AppColors.primaryColor;
                  //               SColor = Colors.white.withOpacity(0.52);
                  //               LColor = Colors.white.withOpacity(0.52);
                  //             });
                  //           },
                  //           style: TextButton.styleFrom(
                  //             padding: EdgeInsets.zero,
                  //           ),
                  //           child: Text(
                  //             "M",
                  //             style: TextStyle(
                  //                 fontSize: 20,
                  //                 color: MColor,
                  //                 fontFamily: "poppins"),
                  //           )),
                  //     ),
                  //     Container(
                  //       width: 110,
                  //       height: 37,
                  //       decoration: BoxDecoration(
                  //           color: LFillColor,
                  //           border: Border.all(width: 1, color: LborderColor),
                  //           borderRadius: BorderRadius.circular(8)),
                  //       child: TextButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               _isLSelected = true;
                  //               LFillColor = Colors.black;
                  //               SFillColor = AppColors.defaultSizeButtonColor;
                  //               MFillColor = AppColors.defaultSizeButtonColor;
                  //               LborderColor = AppColors.primaryColor;
                  //               MborderColor = Colors.transparent;
                  //               SborderColor = Colors.transparent;
                  //               LColor = AppColors.primaryColor;
                  //               MColor = Colors.white.withOpacity(0.52);
                  //               SColor = Colors.white.withOpacity(0.52);
                  //             });
                  //           },
                  //           style: TextButton.styleFrom(
                  //             padding: EdgeInsets.zero,
                  //           ),
                  //           child: Text(
                  //             "L",
                  //             style: TextStyle(
                  //                 fontSize: 20,
                  //                 color: LColor,
                  //                 fontFamily: "poppins"),
                  //           )),
                  //     )
                  //   ],
                  // )
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Price",
                          style: TextStyle(
                              fontFamily: "poppinslight",
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.51)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "\$",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 24,
                                  fontFamily: "poppins"),
                            ),
                            Text(
                              widget.price,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: "poppinslight",
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 74,
                        width: 220,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    AppColors.primaryColor),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)))),
                            onPressed: () {
                              if (widget.stock > 0) {
                                Auth().addToCart(
                                    context,
                                    FirebaseAuth.instance.currentUser!,
                                    widget.category,
                                    widget.name,
                                    widget.price,
                                    1,widget.selectedCategoryKey,widget.selectedProductKey);
                                     Databaseservice().updateStock(
                                                            widget.selectedCategoryKey,
                                                            widget.selectedProductKey,
                                                            product['stock'] -
                                                                1);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("This item is out of stock")));
                              }
                            },
                            child: const Text(
                              "Add to Cart",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "poppins",
                                  color: Colors.white),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
