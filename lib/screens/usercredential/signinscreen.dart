import 'package:campbelldecor/screens/bookings_screens/date_view.dart';
import 'package:campbelldecor/screens/dash_board/homescreen.dart';
import 'package:campbelldecor/screens/usercredential/resetpassword.dart';
import 'package:campbelldecor/screens/usercredential/signupscreen.dart';
import 'package:campbelldecor/utils/color_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../reusable/reusable_methods.dart';
import '../../reusable/reusable_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringtoColor("CB2893"),
            hexStringtoColor("9546C4"),
            hexStringtoColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/login.png"),
                const SizedBox(
                  height: 30,
                ),
                textField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 30,
                ),
                textField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableButton(context, true, () {
                  if (_emailTextController.text.isNotEmpty &&
                      _passwordTextController.text.isNotEmpty) {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      Navigation(context, HomeScreen());
                    }).onError((error, stackTrace) {
                      showErrorAlert(context,
                          'Username or Password is incorrect please try again.');
                      print("Error ${error.toString()}");
                    });
                  } else {
                    showErrorAlert(context, 'Please Fill the All feilds ');
                  }
                }),
                signUpOption(),
                forgetPasswordOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigation(context, const SignUpScreen());
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Row forgetPasswordOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigation(context, ResetScreen());
          },
          child: const Text(
            "Forget Password",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
