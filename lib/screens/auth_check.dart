// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:smart_to_do_app/screens/home_screen.dart';
// import 'package:smart_to_do_app/screens/login_page.dart';

// class AuthCheck extends StatelessWidget {
//   const AuthCheck({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snap) {
//         if (snap.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snap.data == null) {
//           return const LoginPage();
//         } else {
//           return HomeScreen();
//         }
//       },
//     );
//   }
// }
