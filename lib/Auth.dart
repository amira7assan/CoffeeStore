import 'dart:collection';

import 'package:ecommerce/Pages/AdminHomePage.dart';
import 'package:ecommerce/Pages/BottomNavigationBar.dart';
import 'package:ecommerce/Pages/Homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Pages/signUp.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Future<void> placeOrders(context, User user, String categoryName,
  //     String productName, String price,int quantity,String  totalPrice) async {
  //   try {
  //     Map<String, dynamic> item = {
  //       'category': categoryName,
  //       'name': productName,
  //       'price': price,
  //       'quantity':quantity,
  //       'total':totalPrice,
  //     };

  //     DocumentReference userDoc =
  //         FirebaseFirestore.instance.collection('users').doc(user.uid);

  //     await userDoc.update({
  //       'orders': FieldValue.arrayUnion([item]),
        
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Item added to Orders!')));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error Adding item to Orders: $e')));
  //   }
  // }

  Future<void> updateCartItemQuantity(
      BuildContext context, User user, String itemId, int newQuantity) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(itemId)
          .update({'quantity': newQuantity});
    } catch (e) {
      print("Error updating quantity: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update quantity: $e")),
      );
    }
  }

  Future<void> removeFromFavorites(BuildContext context, String category,
      String name, String price, User currentUser) async {
    try {
      final userFavoritesRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      Map<String, dynamic> elementToDelete = {
        "category": category,
        "name": name,
        "price": price
      };

      await userFavoritesRef.update({
        'favorite': FieldValue.arrayRemove([elementToDelete])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item removed from favorites.")),
      );
    } catch (e) {
      print("Error removing item from favorites: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to remove item.")),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getCart(context, User user) async {
    List<Map<String, dynamic>> items = List.empty();
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('cart')) {
          items = List<Map<String, dynamic>>.from(data['cart']);
        } else {
          items = [];
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('fetching data from cart')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching data from cart')));
    }
    return items;
  }

  Future<List<Map<String, dynamic>>> getFavorites(context, User user) async {
    List<Map<String, dynamic>> items = List.empty();
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('favorite')) {
          items = List<Map<String, dynamic>>.from(data['favorite']);
        } else {
          items = [];
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('fetching data from favorites')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching data from favorites')));
    }
    return items;
  }

  Future<void> addToCart(BuildContext context, User user, String categoryName,
      String productName, String price, int quantity,String selectedCategoryKey,String selectedProductKey) async {
    try {
      Map<String, dynamic> item = {
        'categoryKey':selectedCategoryKey,
        'productKey':selectedProductKey,
        'category': categoryName,
        'name': productName,
        'price': price,
        'quantity': quantity
      };

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        print("User document does not exist.");
        return;
      }

      final userData = docSnapshot.data() as Map<String, dynamic>;

      final List<dynamic> cart = userData['cart'] ?? [];

      final existingItem = cart.firstWhere(
        (element) => element['name'] == productName,
        orElse: () => null,
      );

      if (existingItem != null) {
        existingItem['quantity'] += quantity;

        await userDoc.update({
          'cart': cart,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'This items already exists,we increased the Quantity in cart!')),
        );
      } else {
        await userDoc.update({
          'cart': FieldValue.arrayUnion([item]),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added to cart!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Adding item to cart: $e')),
      );
    }
  }

  // Future<void> addToCart(context, User user, String categoryName,
  //     String productName, String price, int quantity) async {
  //   try {
  //     Map<String, dynamic> item = {
  //       'category': categoryName,
  //       'name': productName,
  //       'price': price,
  //       'quantity': quantity
  //     };

  //     DocumentReference userDoc =
  //         FirebaseFirestore.instance.collection('users').doc(user.uid);

  //     await userDoc.update({
  //       'cart': FieldValue.arrayUnion([item])
  //     });
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text('Item added to cart!')));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error Adding item to cart: $e')));
  //   }
  // }

  Future<void> addToFavorites(context, User user, String categoryName,
      String productName, String price) async {
    try {
      Map<String, dynamic> item = {
        'category': categoryName,
        'name': productName,
        'price': price
      };

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      await userDoc.update({
        'favorite': FieldValue.arrayUnion([item])
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added to Favorites!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Adding item to Favorites: $e')));
    }
  }

  Future<UserCredential> signIn({
    required context,
    required String email,
    required String password,
    required bool remember,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Sign in Done successfully with ${userCredential.user!.email}!")));

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({
        'remember': remember,
      });
    } catch (e) {
      print("$e");
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      String role = userDoc['role'];
      if (role == 'admin') {
        // Navigate to admin page
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Adminhomepage()),
            (Route<dynamic> route) => false);
      } else {
        // Navigate to user page
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const MyBottomNavigationBar()),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      print("$e");
    }

    return userCredential;
  }

  Future resetPass(context, TextEditingController emailforgotController) async {
    String email = emailforgotController.text.trim();
    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address.")),
      );
      return;
    }
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "If the email exists, a reset password link has been sent to $email")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  Future<UserCredential> signUp(
      {required bool isAdmin,
      required String email,
      required String password,
      required String birthdate}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'role': isAdmin ? 'admin' : 'user',
        'birthdate': birthdate,
      });
    } catch (e) {
      print("$e");
    }
    return userCredential;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
