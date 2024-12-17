import 'package:ecommerce/Auth.dart';
import 'package:ecommerce/Widgets/inputs/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgotPass extends StatefulWidget {
  const forgotPass({super.key});

  @override
  State<forgotPass> createState() => _forgotPassState();
}

class _forgotPassState extends State<forgotPass> {
  final TextEditingController _emailforgotController = TextEditingController();

  @override
  void dispose() {
    _emailforgotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new))),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Forgot Password",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "poppinslight",
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Please enter your email to reset the password",
              style: TextStyle(
                  color: Color.fromRGBO(152, 152, 152, 1),
                  fontSize: 16,
                  fontFamily: "poppinslight",
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Your Email",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              style: const TextStyle(
                  color: Colors.white, fontFamily: "poppinslight"),
              controller: _emailforgotController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  hintText: "contact@dscodetech.com",
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(179, 179, 179, 1),
                    fontFamily: "poppinslight",
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 5),
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 330,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_emailforgotController.text.isNotEmpty) {
                        Auth().resetPass(context, _emailforgotController);
                      }
                    },
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.primaryColor)),
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "if you received the email and reset the password",
                style: TextStyle(
                    fontFamily: "poppinslight",
                    color: AppColors.disabledCategoryColor),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login now",
                        style: TextStyle(color: AppColors.primaryColor),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
