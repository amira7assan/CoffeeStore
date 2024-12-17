import 'package:ecommerce/Auth.dart';
import 'package:ecommerce/Widgets/inputs/AuthTextField.dart';
import 'package:ecommerce/Widgets/inputs/Colors.dart';
import 'package:ecommerce/extensions/string_extensions.dart';
import 'package:ecommerce/Pages/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<signUp> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  bool isAdmin = false;

  DateTime? _selectedDate;
  String _ageText = "";

  void _calculateAge() {
    if (_selectedDate == null) {
      return;
    }
    DateTime now = DateTime.now();
    int years = now.year - _selectedDate!.year;
    int months = now.month - _selectedDate!.month;
    int days = now.day - _selectedDate!.day;

    if (months < 0) {
      years--;
      months += 12;
    }
    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }

    setState(() {
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      _ageText = dateFormat.format(_selectedDate!);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _calculateAge();
    }
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
                      "Sign Up",
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
                    key: formkey,
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
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.white, fontFamily: "poppinslight"),
                          controller: _passwordController,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return "Password can't be empty";
                            }

                            if (!input.isValidPassword()) {
                              return "Password length must be at least 6 characters";
                            }

                            return null;
                          },
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              hintText: "Enter Password",
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(179, 179, 179, 1),
                                fontFamily: "poppinslight",
                              ),
                              border: OutlineInputBorder(
                                  // borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: const TextStyle(
                              color: Colors.white, fontFamily: "poppinslight"),
                          controller: _confirmpasswordController,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return "Please Confirm your Password";
                            }

                            if (input != _passwordController.text) {
                              return "Passwords don't match";
                            }

                            return null;
                          },
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              hintText: "Confirm Password",
                              hintStyle: const TextStyle(
                                color: Color.fromRGBO(179, 179, 179, 1),
                                fontFamily: "poppinslight",
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        CheckboxListTile(
                            title: Text(
                              "Sign up as admin",
                              style: TextStyle(
                                  fontFamily: "poppinslight",
                                  color: AppColors.disabledCategoryColor),
                            ),
                            value: isAdmin,
                            onChanged: (value) {
                              setState(() {
                                isAdmin = value!;
                              });
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(
                                _ageText == "" ? "BirthDate" : _ageText,
                                style: TextStyle(
                                    color: AppColors.disabledCategoryColor),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: InkWell(
                                onTap: () {
                                  _selectDate(context);
                                  print(_ageText);
                                },
                                child: SizedBox(
                                  height: 50,
                                  // width: 20,
                                  child: Icon(
                                    Icons.date_range,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 30,
                        // ),
                        SizedBox(
                          width: 330,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState?.validate() ?? false) {
                                if (_selectedDate != null) {
                                  try {
                                    await Auth().signUp(
                                        isAdmin: isAdmin,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        birthdate: _ageText
                                        );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Account created successfully")));
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => signIn(
                                                  useremail:
                                                      _emailController.text,
                                                  userpassword:
                                                      _passwordController.text,
                                                )),
                                        (Route<dynamic> route) => false);
                                    Auth().signOut();
                                  } on FirebaseAuthException catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text("${e.message}")));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("select BirthDate")));
                                }
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
                              "Sign Up",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )),
                // const SizedBox(
                //   height: 10,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "already have an account?",
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
                                  builder: (context) => signIn()));
                        },
                        child: Text(
                          "Sign in",
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
