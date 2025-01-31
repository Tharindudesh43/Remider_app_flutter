import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                    height: 300,
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.network(
                        'https://images.pexels.com/photos/7841844/pexels-photo-7841844.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage('assets/profile.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "LogIn",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
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
                                FirebaseAuthService.signInWithGoogle()
                                    .then((value) {
                                  if (value == "Google User Added") {
                                    FirebaseAuth.instance
                                        .authStateChanges()
                                        .listen((User? user) {
                                      if (user != null) {
                                        isloadinggoogle = false;
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
                                const Text(
                                  "Are you haven't account ? ",
                                  style: TextStyle(fontSize: 15),
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignupPage()));
                                    },
                                    child: const Text(
                                      "SignUp",
                                      style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ))
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
