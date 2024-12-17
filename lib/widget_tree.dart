import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Pages/AdminHomePage.dart';
import 'package:ecommerce/Pages/BottomNavigationBar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Auth.dart';
import 'Pages/Homepage.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/Pages/signIn.dart';
import 'package:ecommerce/Pages/signUp.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  var fireStoreDoc;
  @override
  Widget build(BuildContext context) {
    // Auth().signOut();
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? user = snapshot.data;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .get(),
            builder: (context, docSnapshot) {
              if (docSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (docSnapshot.hasData) {
                var userRole = docSnapshot.data?.get('role');
                var userRemember = docSnapshot.data?.get('remember');

                if (userRemember==false) {
                  return signIn();
                }

                if (userRole == 'admin') {
                  return const Adminhomepage();
                } else {
                  return const MyBottomNavigationBar();
                }
              } else {
                return const MyBottomNavigationBar();
              }
            },
          );
        }

        return signIn();
      },
    );
  }
}
