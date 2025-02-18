import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/screens/home_screen.dart';
import 'package:smart_to_do_app/screens/internet_connection.dart';
import 'package:smart_to_do_app/screens/login_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<TodotaskProvider>(
          create: (context) => TodotaskProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool isConnectedToInternet = false;
  // StreamSubscription? _internetConnectionStreamSubscription;

  // @override
  // void initState() {
  //   super.initState();
  //   _internetConnectionStreamSubscription =
  //       InternetConnection().onStatusChange.listen((event) {
  //     print("Connection Check: $event");
  //     switch (event) {
  //       case InternetStatus.connected:
  //         setState(() {
  //           isConnectedToInternet = true;
  //         });
  //         break;
  //       case InternetStatus.disconnected:
  //         setState(() {
  //           isConnectedToInternet = false;
  //         });
  //         break;
  //       default:
  //         setState(() {
  //           isConnectedToInternet = true;
  //         });
  //         break;
  //     }
  //   });
  // }

  @override
  void dispose() {
    //_internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Remx',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: //isConnectedToInternet == true
            //?
            StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snap.data == null) {
              return const LoginPage();
            } else {
              return HomeScreen();
            }
          },
        ));
    //: InternetConnection_page());
  }
}
