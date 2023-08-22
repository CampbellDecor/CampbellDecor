import 'package:campbelldecor/reusable/reusable_methods.dart';
import 'package:campbelldecor/screens/homescreen.dart';
import 'package:campbelldecor/screens/usercredential/signinscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../reusable/reusable_widgets.dart';
import '../../utils/color_util.dart';
import '../events_screen/eventscreen.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Forget Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringtoColor("CD2B93"),
              hexStringtoColor("9546C4"),
              hexStringtoColor("5E61FA")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              textField("Enter Your Email", Icons.email_outlined, false,
                  emailController),
              const SizedBox(
                height: 20,
              ),
              resetButton(context, () async {
                if (emailController.text.isNotEmpty) {
                  // try {
                  //
                  //   // FirebaseAuth.instance
                  //   //     .sendPasswordResetEmail(email: emailController.text)
                  //   //     .then((value) {
                  //   //   showInformationAlert(
                  //   //       context,
                  //   //       'Password reset email sent. Check your inbox.',
                  //   //       SignInScreen());
                  //   // });
                  // } catch (ex) {
                  //   // if (e.toString() == 'user-not-found') {
                  //   //   showErrorAlert(
                  //   //     context,
                  //   //     'No user found with this email address.',
                  //   //   );
                  //   // } else {
                  //   //   showErrorAlert(
                  //   //     context,
                  //   //     'An error occurred: $e',
                  //   //   );
                  //   // }
                  //   setState(() {
                  //     print(
                  //         "Ssssssssssssssssssssssssssssssssssssssssssssssssss");
                  //   });
                  // }
                  try {
                    var userCheck = await FirebaseAuth.instance
                        .fetchSignInMethodsForEmail(emailController.text);
                    if (userCheck.isEmpty) {
                      // ignore: use_build_context_synchronously
                      showErrorAlert(
                          context, 'No user found with this email address.');
                    } else {
                      // Send password reset email
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text);
                      // ignore: use_build_context_synchronously
                      showInformationAlert(
                        context,
                        'Password reset email sent. Check your inbox.',
                        SignInScreen(),
                      );
                    }
                  } catch (e) {
                    showErrorAlert(context, 'An error occurred: $e');
                  }
                } else {
                  showErrorAlert(context, 'please enter your email address');
                }
              })
            ]),
          ),
        ),
      ),
    );
  }

  Container resetButton(BuildContext context, Function onTap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular((30))),
            )),
        child: const Text(
          "RESET",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
