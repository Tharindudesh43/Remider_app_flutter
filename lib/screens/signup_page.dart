import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_to_do_app/main.dart';
import 'package:smart_to_do_app/screens/login_page.dart';
import 'package:smart_to_do_app/services/firebase_auth_service.dart';
import 'package:smart_to_do_app/utilities/Validation.dart';
import 'package:smart_to_do_app/widgets/custom_button.dart';
import 'package:smart_to_do_app/widgets/custom_textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController nameFieldController = TextEditingController();
  final TextEditingController mobilenumberFieldController =
      TextEditingController();
  String? emailErrorText;
  bool isLoadingnormal = false;
  bool isLoadinggoogle = false;
  String? passwordErrorText;
  String? nameErrorText;
  bool loop = true;
  String? mobilenumberErrorText;
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
                        height: 30,
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
                            const Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            custom_textfield(
                              textfieldvalue: "Name",
                              controller: nameFieldController,
                              errorText: nameErrorText,
                            ),
                            custom_textfield(
                              textfieldvalue: "Email",
                              controller: emailFieldController,
                              errorText: emailErrorText,
                            ),
                            custom_textfield(
                              textfieldvalue: "Mobile Number",
                              controller: mobilenumberFieldController,
                              errorText: mobilenumberErrorText,
                            ),
                            custom_textfield(
                              textfieldvalue: "Password",
                              controller: passwordFieldController,
                              errorText: passwordErrorText,
                            ),
                            CustomButton(
                              btntype: "Normal",
                              selecter: 0,
                              isloadingnormal: isLoadingnormal,
                              btnText: "SIGN UP",
                              onTap: () async {
                                Validation validationObj = Validation();
                                setState(() {
                                  if (loop) {
                                    nameErrorText =
                                        validationObj.checkvalidation(
                                            FieldValue: nameFieldController.text
                                                .toString(),
                                            Fieldnumber: 1);
                                    emailErrorText =
                                        validationObj.checkvalidation(
                                            FieldValue: emailFieldController
                                                .text
                                                .toString(),
                                            Fieldnumber: 2);
                                    mobilenumberErrorText =
                                        validationObj.checkvalidation(
                                            FieldValue:
                                                mobilenumberFieldController.text
                                                    .toString(),
                                            Fieldnumber: 3);
                                    passwordErrorText =
                                        validationObj.checkvalidation(
                                            FieldValue: passwordFieldController
                                                .text
                                                .toString(),
                                            Fieldnumber: 4);
                                    if (passwordErrorText == null &&
                                        emailErrorText == null &&
                                        mobilenumberErrorText == null &&
                                        nameErrorText == null) {
                                      loop = false;
                                      isLoadingnormal = true;

                                      FirebaseAuthService.signup(
                                              mobilenumber:
                                                  mobilenumberFieldController
                                                      .text
                                                      .trim(),
                                              name: nameFieldController.text
                                                  .trim(),
                                              email: emailFieldController.text
                                                  .trim(),
                                              password: passwordFieldController
                                                  .text
                                                  .trim())
                                          .then((value) {
                                        if (value == "User Added") {
                                          FirebaseAuth.instance
                                              .authStateChanges()
                                              .listen((User? user) {
                                            if (user != null) {
                                              isLoadingnormal = false;
                                              print("User ------ " +
                                                  user.uid.toString());
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyApp()),
                                                (Route<dynamic> route) => false,
                                              );
                                              // passwordFieldController.clear();
                                              // emailFieldController.clear();
                                              // mobilenumberFieldController
                                              //     .clear();
                                              // nameFieldController.clear();
                                            }
                                          });
                                        } else if (value ==
                                            "email-already-in-use") {
                                          setState(() {
                                            isLoadingnormal = false;
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignupPage()),
                                              (Route<dynamic> route) => false,
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Email Already used"),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 12,
                                            ));
                                          });
                                        } else {
                                          print("Sign up error" +
                                              value.toString());
                                          // passwordFieldController.clear();
                                          // emailFieldController.clear();
                                          // mobilenumberFieldController.clear();
                                          // nameFieldController.clear();
                                        }
                                      });
                                    } else {
                                      isLoadingnormal = false;
                                    }
                                  }
                                });
                              },
                            ),
                            CustomButton(
                              btntype: "Google",
                              selecter: 0,
                              isloadinggoogle: isLoadinggoogle,
                              btnText: "SIGN UP with Google",
                              onTap: () async {
                                setState(() {
                                  // print("title: ${}");
                                  passwordFieldController.clear();
                                  emailFieldController.clear();
                                  mobilenumberFieldController.clear();
                                  nameFieldController.clear();

                                  loop = false;
                                  isLoadinggoogle = true;
                                  FirebaseAuthService.signInWithGoogle()
                                      .then((value) {
                                    if (value == "Google User Added") {
                                      FirebaseAuth.instance
                                          .authStateChanges()
                                          .listen((User? user) {
                                        if (user != null) {
                                          isLoadinggoogle = false;
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
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have acccount ? ",
                                  style: TextStyle(fontSize: 15),
                                ),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
                                    },
                                    child: const Text(
                                      "Login",
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
