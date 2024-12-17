import 'dart:io';

import 'package:ecommerce/Auth.dart';
import 'package:ecommerce/DataBaseService.dart';
import 'package:ecommerce/Model/Products_model.dart';
import 'package:ecommerce/Pages/admin.dart';
import 'package:ecommerce/Pages/signIn.dart';
import 'package:ecommerce/Services.dart';
import 'package:ecommerce/Widgets/String.dart';
import 'package:ecommerce/Widgets/inputs/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Adminhomepage extends StatefulWidget {
  const Adminhomepage({super.key});

  @override
  State<Adminhomepage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Adminhomepage> {
  String? selectedCategoryKey;
  String? selectedCategoryName;
  final Databaseservice _firebaseService = Databaseservice();
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    listenForCaegoryChanges();
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

  void listenForProductChanges(String categoryKey) {
    if (categoryKey.isEmpty) return;

    final DatabaseReference productsRef = FirebaseDatabase.instance
        .ref()
        .child(AppStrings.chilCategory)
        .child(categoryKey)
        .child("products");

    productsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;

      if (data != null) {
        setState(() {
          products = data.entries.map((e) {
            return {
              "key": e.key,
              ...Map<String, dynamic>.from(e.value),
            };
          }).toList();
        });
      } else {
        setState(() {
          products = [];
        });
      }
    }, onError: (error) {
      setState(() {
        print("Error fetching products: $error");
      });
    });
  }

  void listenForCaegoryChanges() {
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref().child(AppStrings.chilCategory);

    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          categories = [];
          categories = data.entries.map((e) {
            return {
              "key": e.key,
              ...Map<String, dynamic>.from(e.value),
            };
          }).toList();
          if (selectedCategoryKey == null && categories.isNotEmpty) {}
        });
      } else {
        setState(() {
          categories = [];
          isLoading = false;
        });
      }
    },
        onError: (error) => {
              setState(() {
                print("error fetching real time database: $error");
                isLoading = false;
              })
            });
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdminProfile()));
              },
              icon: const Icon(
                Icons.account_circle,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(
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
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Image.asset(
                          "assets/images/search.png",
                          scale: 2,
                        ),
                        filled: true,
                        fillColor: AppColors.textFieldFillColor,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Find your coffee...",
                        hintStyle: TextStyle(
                            fontFamily: "poppins",
                            color: AppColors.textFieldHintColor)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 100,
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
                            return Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Databaseservice()
                                        .deleteCategory(category['key']);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Item deleted successfully")));
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.white,
                                ),
                                GestureDetector(
                                    onLongPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) =>
                                              showUpdateCategoryDialog(
                                                  context,
                                                  updateCategoryController,
                                                  category['key'],
                                                  category['name']));
                                    },
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedCategoryKey = category['key'];
                                          selectedCategoryName =
                                              category['name'];
                                        });
                                        fetchProducts(selectedCategoryKey!);
                                        print(
                                            "Selected Category Key: $selectedCategoryKey");
                                      },
                                      child: Text(
                                        category['name'],
                                        style: TextStyle(
                                            color: isSelected
                                                ? AppColors.primaryColor
                                                : AppColors
                                                    .disabledCategoryColor,
                                            fontFamily: "poppins",
                                            fontSize: 16),
                                      ),
                                    )),
                              ],
                            );
                          }),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadiusDirectional.circular(25)),
                    width: deviceWidth,
                    child: IconButton(
                        color: Colors.black,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => showAddCategoryDialog(
                                  context, addCategoryController));
                        },
                        icon: const Icon(Icons.add))),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 310,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return
                                //  ProductItem(
                                //     catekey: selectedCategoryKey!,
                                //     image: "assets/images/capp1.png",
                                //     title: selectedCategoryName!,
                                //     subtitle: product['name'],
                                //     prokey: product['key'],
                                //     price: "${product['price']}");

                                GestureDetector(
                              onTap: () {
                                print("pressed pro");
                                showDialog(
                                    context: context,
                                    builder: (_) => showUpdateProductDialog(
                                          categoryKey: selectedCategoryKey!,
                                          productKey: product['key'],
                                        ));
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
                                            Color.fromRGBO(56, 55, 55, 1.0),
                                            Color.fromRGBO(17, 16, 16, 0.99),
                                          ]),
                                      borderRadius: BorderRadius.circular(29)),
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
                                        padding:
                                            const EdgeInsets.only(left: 6.0),
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
                                        padding:
                                            const EdgeInsets.only(left: 6.0),
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0),
                                            child: Row(
                                              children: [
                                                Text("\$",
                                                    style: TextStyle(
                                                        fontFamily: "poppins",
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16)),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  "${product['price']}",
                                                  style: const TextStyle(
                                                      fontFamily: "poppins",
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
                                                      style: const TextStyle(
                                                          color: Colors.yellow),
                                                    ),
                                                  ],
                                                )
                                              : const Text(
                                                  "  No Ratings",
                                                  style: TextStyle(
                                                      color: Colors.yellow),
                                                ),
                                          Expanded(
                                            child: IconButton(
                                              onPressed: () {
                                                Databaseservice().deleteProduct(
                                                    selectedCategoryKey!,
                                                    product['key']);
                                              },
                                              icon: const Icon(Icons.delete),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadiusDirectional.circular(25)),
                    width: deviceWidth,
                    child: IconButton(
                        color: Colors.black,
                        onPressed: () {
                          try {
                            if (selectedCategoryKey == null) {
                              throw Exception("No category selected");
                            }
                            showDialog(
                              context: context,
                              builder: (_) => showAddProductDialog(
                                  categoryKey: selectedCategoryKey!),
                            );
                            listenForProductChanges(selectedCategoryKey!);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Select a Specific Category"),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.add))),
              ],
            ),
          ),
        ));
  }
}

class showAddProductDialog extends StatefulWidget {
  final String categoryKey;
  const showAddProductDialog({super.key, required this.categoryKey});

  @override
  State<showAddProductDialog> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<showAddProductDialog> {
  File? _selectedImage;
  Future<bool> requestGalleryPermission() async {
    PermissionStatus status;
    if (await Permission.photos.isGranted ||
        await Permission.photos.isLimited) {
      return true;
    }
    status = await Permission.photos.request();
    return status.isGranted || status.isLimited;
  }

  Future<void> _pickImageFromGallery() async {
    if (await requestGalleryPermission()) {
      try {
        final pickedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          setState(() {
            _selectedImage = File(pickedImage.path);
          });
        } else {
          print("No image selected.");
        }
      } catch (e) {
        print("Error picking image: $e");
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController addProductNameController = TextEditingController();
    TextEditingController addProductPriceController = TextEditingController();
    TextEditingController addProductStockController = TextEditingController();
    TextEditingController addProductBarcodeController = TextEditingController();
    TextEditingController addProductDescritpionController =
        TextEditingController();
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          "Add Product",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: SizedBox(
          height: 800,
          width: (MediaQuery.sizeOf(context).width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      scale: 10,
                    )
                  : Image.asset(
                      "assets/images/capp1.png",
                      scale: 3,
                    ),
              Column(
                children: [
                  TextButton(
                      onPressed: () {
                        _pickImageFromGallery();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Pick Image from gallery",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        _pickImageFromCamera();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Pick Image from camera",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              ),
              TextField(
                controller: addProductNameController,
                cursorColor: AppColors.primaryColor,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  labelText: "Product Name",
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: addProductPriceController,
                cursorColor: AppColors.primaryColor,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  labelText: "Product Price",
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: addProductStockController,
                cursorColor: AppColors.primaryColor,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  labelText: "Quantity in Stock",
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: addProductBarcodeController,
                cursorColor: AppColors.primaryColor,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  labelText: "Barcode",
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                maxLines: 5,
                controller: addProductDescritpionController,
                cursorColor: AppColors.primaryColor,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  hintText: "Description",
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              try {
                int stock = int.parse(addProductStockController.text);
                if (addProductNameController.text.isNotEmpty &&
                    addProductPriceController.text.isNotEmpty &&
                    addProductStockController.text.isNotEmpty &&
                    addProductBarcodeController.text.isNotEmpty) {
                  Databaseservice().addProduct(
                      widget.categoryKey,
                      addProductNameController.text,
                      addProductPriceController.text,
                      stock,
                      addProductBarcodeController.text,
                      addProductDescritpionController.text);

                  Navigator.pop(context);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter a valid Quantity")));
              }
            },
            child: Text('Add', style: TextStyle(color: AppColors.primaryColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child:
                Text('Cancel', style: TextStyle(color: AppColors.primaryColor)),
          ),
        ],
      ),
    );
  }
}

AlertDialog showAddCategoryDialog(
    BuildContext context, TextEditingController addCategoryController) {
  return AlertDialog(
    backgroundColor: Colors.black,
    title: Text(
      "Add Category",
      style: TextStyle(color: AppColors.primaryColor),
    ),
    content: TextField(
      controller: addCategoryController,
      cursorColor: AppColors.primaryColor,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.textFieldFillColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        labelText: "Category Name",
        labelStyle: const TextStyle(color: Colors.white),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          if (addCategoryController.text.isNotEmpty) {
            Databaseservice().addCategory(addCategoryController.text);
            Navigator.pop(context);
          }
        },
        child: Text('Add', style: TextStyle(color: AppColors.primaryColor)),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context); // Close the dialog
        },
        child: Text('Cancel', style: TextStyle(color: AppColors.primaryColor)),
      ),
    ],
  );
}

AlertDialog showUpdateCategoryDialog(
    BuildContext context,
    TextEditingController updateCategoryController,
    String categoryKey,
    String categoryName) {
  return AlertDialog(
    backgroundColor: Colors.black,
    title: Text(
      categoryName,
      style: TextStyle(color: AppColors.primaryColor),
    ),
    content: TextField(
      controller: updateCategoryController,
      cursorColor: AppColors.primaryColor,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.textFieldFillColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        labelText: "Category Name",
        labelStyle: const TextStyle(color: Colors.white),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          if (updateCategoryController.text.isNotEmpty) {
            Databaseservice()
                .updateCategory(categoryKey, updateCategoryController.text);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Item updated successfully")));
          }
        },
        child: Text('Update', style: TextStyle(color: AppColors.primaryColor)),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context); // Close the dialog
        },
        child: Text('Cancel', style: TextStyle(color: AppColors.primaryColor)),
      ),
    ],
  );
}

class showUpdateProductDialog extends StatefulWidget {
  final String categoryKey;
  final String productKey;
  const showUpdateProductDialog(
      {super.key, required this.categoryKey, required this.productKey});

  @override
  State<showUpdateProductDialog> createState() =>
      _showUpdateProductDialogState();
}

class _showUpdateProductDialogState extends State<showUpdateProductDialog> {
  File? _selectedImage;
  Future<void> _pickImageFromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController addProductNameController = TextEditingController();
    TextEditingController addProductPriceController = TextEditingController();
    TextEditingController addProductStockController = TextEditingController();
    TextEditingController addProductBarcodeController = TextEditingController();
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          "Add Product",
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: SizedBox(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      scale: 10,
                    )
                  : Image.asset(
                      "assets/images/capp1.png",
                      scale: 3,
                    ),
              Column(
                children: [
                  TextButton(
                      onPressed: () {
                        _pickImageFromGallery();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Pick Image from gallery",
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        _pickImageFromCamera();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Pick Image from camera",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ],
              ),
              TextField(
                controller: addProductNameController,
                cursorColor: AppColors.primaryColor,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  labelText: "Product Name",
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: addProductPriceController,
                cursorColor: AppColors.primaryColor,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  labelText: "Product Price",
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: addProductStockController,
                cursorColor: AppColors.primaryColor,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  labelText: "Quantity in Stock",
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: addProductBarcodeController,
                cursorColor: AppColors.primaryColor,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none),
                  labelText: "Barcode",
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              try {
                int stock = int.parse(addProductStockController.text);
                if (addProductNameController.text.isNotEmpty &&
                    addProductPriceController.text.isNotEmpty &&
                    addProductStockController.text.isNotEmpty &&
                    addProductBarcodeController.text.isNotEmpty) {
                  Databaseservice().updateProduct(
                      widget.categoryKey,
                      widget.productKey,
                      addProductNameController.text,
                      addProductPriceController.text,
                      stock,
                      addProductBarcodeController.text);

                  Navigator.pop(context);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter a valid Quantity")));
              }
            },
            child:
                Text('Update', style: TextStyle(color: AppColors.primaryColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child:
                Text('Cancel', style: TextStyle(color: AppColors.primaryColor)),
          ),
        ],
      ),
    );
  }
}
