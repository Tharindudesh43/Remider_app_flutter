// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:smart_to_do_app/screens/auth_check.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => const AuthCheck()));
//     });
//   }

//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset("assets/check-list.png", height: 80, width: 80),
//             const SizedBox(height: 20),
//             const Text(
//               "Do-Do",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w900,
//                 fontSize: 24,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
