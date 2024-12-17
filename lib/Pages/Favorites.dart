import 'package:ecommerce/Auth.dart';
import 'package:ecommerce/Pages/BottomNavigationBar.dart';
import 'package:ecommerce/Widgets/inputs/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class  _FavoritesState extends State<Favorites> {
  List<Map<String, dynamic>> favItem = List.empty();
  bool isLoading = true;

  @override
  void initState() {
    getfavoriteItems();
    super.initState();
  }

  Future<void> getfavoriteItems() async {
    try {
      var fetchedCartItems = await Auth()
          .getFavorites(context, FirebaseAuth.instance.currentUser!);

      if (mounted) {
        setState(() {
          favItem = fetchedCartItems;
          isLoading = false;
        });
      }

      print("favorites length: ${favItem.length}");
      print("favorites is empty : ${favItem.isEmpty}");
    } catch (e) {
      print("favorites is empty");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 80),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: isLoading
               ? const Center(
                  child: CircularProgressIndicator(),
                )
              : (favItem.isEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Favorites",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: "poppins",
                          ),
                        ),
                        Image.asset("assets/images/illustration.png"),
                        Container(
                          child: const Column(
                            children: [
                              Text(
                                "No Love Yet!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "inter",
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Find something you love and save it here for easy access!",
                                  style: TextStyle(
                                    color: Color.fromRGBO(135, 135, 135, 1),
                                    fontFamily: "interlight",
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 52,
                          width: 327,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyBottomNavigationBar()),
                                  (Route<dynamic> route) => false);
                            },
                            style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100))),
                                backgroundColor: WidgetStatePropertyAll(
                                    AppColors.primaryColor)),
                            child: const Text(
                              "Find Your Favorite",
                              style: TextStyle(
                                  fontFamily: "poppins",
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Text(
                          "Favorites",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: "poppins",
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: favItem.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 100,
                                    child: Card(
                                      color:
                                          const Color.fromRGBO(56, 55, 55, 1),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceAround,
                                          children: [
                                            Image.asset(
                                                "assets/images/cartcoffee.png"),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              // color: Colors.red,
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.57,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: Text(
                                                      maxLines: 1,
                                                      "${favItem[index]['category']} ${favItem[index]['name']} ",
                                                      style: TextStyle(
                                                          fontFamily: "poppins",
                                                          fontSize: 14,
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.34)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "\$",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "poppins",
                                                            fontSize: 20,
                                                            color: AppColors
                                                                .primaryColor),
                                                      ),
                                                      Text(
                                                        favItem[index]['price'],
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                "poppinslight",
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                child: IconButton(
                                              onPressed: ()async {
                                                await Auth().removeFromFavorites(
                                                  context,
                                                  favItem[index]['category'],
                                                  favItem[index]['name'],
                                                  favItem[index]['price'],
                                                  FirebaseAuth
                                                      .instance.currentUser!,
                                                );
                                               if(mounted){
                                                 setState(() {
                                                  favItem.removeAt(index);
                                                });
                                               }
                                              },
                                              icon: Icon(
                                                Icons.favorite,
                                                size: 30,
                                                color: AppColors.primaryColor,
                                              ),
                                            )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              }),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
