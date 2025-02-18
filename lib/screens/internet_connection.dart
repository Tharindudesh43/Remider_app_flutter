import 'package:flutter/material.dart';

class InternetConnection_page extends StatefulWidget {
  InternetConnection_page({super.key});

  @override
  State<InternetConnection_page> createState() => _InternetConnectionState();
}

class _InternetConnectionState extends State<InternetConnection_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: Colors.red,
                    size: 40,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You are not connected to the Internet",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
