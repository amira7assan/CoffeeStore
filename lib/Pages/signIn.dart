import 'package:ecommerce/Auth.dart';
import 'package:ecommerce/Pages/Homepage.dart';
import 'package:ecommerce/Pages/forgotpass.dart';
import 'package:ecommerce/Widgets/inputs/AuthTextField.dart';
import 'package:ecommerce/Pages/signUp.dart';
import 'package:ecommerce/Widgets/inputs/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signIn extends StatefulWidget {
  String? useremail;
  String? userpassword;

  signIn({super.key, this.useremail, this.userpassword});

  @override
  State<signIn> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<signIn> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool remember = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.useremail);
    _passwordController = TextEditingController(text: widget.userpassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 130,
                ),
                SizedBox(child: Image.asset("assets/images/login.png")),
                const SizedBox(
                  height: 50,
                ),
                const Row(
                  children: [
                    Text(
                      "Login Detalis",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: "poppinslight",
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formkey,
                    child: SizedBox(
                      width: 330,
                      child: Column(
                        children: [
                          authTextField(
                              "Enter email address",
                              TextInputType.emailAddress,
                              false,
                              _emailController),
                          const SizedBox(
                            height: 20,
                          ),
                          authTextField(
                              "Enter Password",
                              TextInputType.visiblePassword,
                              true,
                              _passwordController),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const forgotPass()));
                                  },
                                  child: const Text(
                                    "Forgot password ?",
                                    style: TextStyle(
                                        color: Color.fromRGBO(92, 92, 92, 1),
                                        fontFamily: "poppinslight",
                                        fontWeight: FontWeight.w700),
                                  )),
                            ],
                          ),
                          CheckboxListTile(
                              title: Text(
                                "Remember me",
                                style: TextStyle(
                                    fontFamily: "poppinslight",
                                    color: AppColors.disabledCategoryColor),
                              ),
                              value: remember,
                              onChanged: (value) {
                                setState(() {
                                  remember = value!;
                                });
                              }),
                          const SizedBox(
                            height: 70,
                          ),
                          SizedBox(
                            width: 330,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final userCredential = await Auth().signIn(
                                      remember: remember,
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text);
                                } on FirebaseAuthException catch (e) {
                                  String errorMessage = '';
                                  if (e.code == 'invalid-credential') {
                                    errorMessage =
                                        'No user found for that email or password.';
                                  } else {
                                    errorMessage =
                                        'An error occurred. Please try again later.';
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(errorMessage)));
                                }
                              },
                              style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppColors.primaryColor)),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontFamily: "poppins",
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create a new account?",
                      style: TextStyle(
                        color: AppColors.disabledCategoryColor,
                        fontFamily: "poppinslight",
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const signUp()));
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontFamily: "poppinslight",
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
