import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_to_do_app/main.dart';
import 'package:smart_to_do_app/screens/signup_page.dart';
import 'package:smart_to_do_app/services/firebase_auth_service.dart';
import 'package:smart_to_do_app/widgets/custom_button.dart';
import 'package:smart_to_do_app/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  String? emailErrorText;
  bool isloadingnormal = false;
  bool isloadinggoogle = false;
  String? passwordErrorText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 7, 7, 7),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        'assets/login.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 150,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)),
                            color: Colors.white),
                        child: Column(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 30),
                            //   child: Container(
                            //       width: 150,
                            //       height: 150,
                            //       decoration: const BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         image: DecorationImage(
                            //           image: AssetImage('assets/profile.png'),
                            //           fit: BoxFit.cover,
                            //         ),
                            //       )),
                            // ),
                            const SizedBox(
                              height: 35,
                            ),
                            Text(
                              "LogIn",
                              style: GoogleFonts.monda(
                                  color: Color.fromARGB(255, 217, 38, 241),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            custom_textfield(
                              textfieldvalue: "Email",
                              controller: emailFieldController,
                              errorText: emailErrorText,
                            ),
                            custom_textfield(
                              textfieldvalue: "Password",
                              controller: passwordFieldController,
                              errorText: passwordErrorText,
                            ),
                            CustomButton(
                              btntype: "Normal",
                              selecter: 0,
                              isloadingnormal: isloadingnormal,
                              btnText: " LOG IN ",
                              onTap: () {
                                setState(() {
                                  if (emailFieldController.text == "" ||
                                      passwordFieldController.text == "") {
                                    passwordErrorText =
                                        "Fiels should be filled";
                                    emailErrorText = "Fiels should be filled";
                                  } else {
                                    isloadingnormal = true;

                                    FirebaseAuthService.signIn(
                                            email: emailFieldController.text
                                                .trim(),
                                            password: passwordFieldController
                                                .text
                                                .trim())
                                        .then((value) {
                                      FirebaseAuth.instance
                                          .authStateChanges()
                                          .listen((User? user) {
                                        if (user != null) {
                                          isloadingnormal = false;
                                        }
                                      });

                                      if (value == "error" ||
                                          value == "invalid-credential") {
                                        emailErrorText = "invalid-credential";
                                        passwordErrorText =
                                            "invalid-credential";
                                        setState(() {
                                          isloadingnormal = false;
                                        });
                                      } else if (value == "success") {
                                        emailErrorText = null;
                                        passwordErrorText = null;
                                        isloadingnormal = false;

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyApp()),
                                          (Route<dynamic> route) => false,
                                        );
                                      }
                                    });
                                  }
                                });
                              },
                            ),
                            CustomButton(
                              btntype: "Google",
                              selecter: 1,
                              isloadinggoogle: isloadinggoogle,
                              btnText: "LOG IN with Google",
                              onTap: () {
                                setState(() {
                                  isloadinggoogle = true;
                                });

                                FirebaseAuthService.signInWithGoogle()
                                    .then((value) {
                                  if (value == "Google User Added") {
                                    FirebaseAuth.instance
                                        .authStateChanges()
                                        .listen((User? user) {
                                      if (user != null) {
                                        setState(() {
                                          isloadinggoogle = false;
                                        });
                                        print("User ------ " +
                                            user.uid.toString());
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyApp()),
                                          (Route<dynamic> route) => false,
                                        );
                                      }
                                    });
                                  }
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Are you haven't account ? ",
                                  style: GoogleFonts.viga(fontSize: 15),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (contextpassed, animation,
                                                persnalAnimation) =>
                                            SignupPage(),
                                        transitionsBuilder: (contextpassed,
                                            animation,
                                            persnalAnimation,
                                            child) {
                                          return FadeTransition(
                                              opacity: animation, child: child);
                                        },
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        width: 70,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 217, 38, 241),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Center(
                                            child: Text(
                                          "Sign Up",
                                          style: GoogleFonts.viga(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ))),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 292,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
