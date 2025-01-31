import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/main.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';

class ProfileCard {
  Future<dynamic> DialogCard({required BuildContext contextxx}) {
    final ValueNotifier<bool> isLoadCardButton = ValueNotifier<bool>(false);
    return showDialog(
      context: contextxx,
      builder: (BuildContext context) {
        return Dialog(
          shadowColor: const Color.fromARGB(255, 131, 33, 235).withOpacity(0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromARGB(255, 253, 235, 249),
          child: SizedBox(
            width: 200,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tharindu',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage('assets/profile.png')),
                      )),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 3, 255, 200)),
                        child: const Text('Close',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: isLoadCardButton,
                        builder: (context, isLoading, _) {
                          return InkWell(
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyApp()),
                                (Route<dynamic> route) => false,
                              );
                              context
                                  .read<TodotaskProvider>()
                                  .clearcurrentuserTasks();
                              context
                                  .read<TodotaskProvider>()
                                  .clearcurrentusername();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Container(
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color.fromARGB(255, 255, 0, 0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 5, bottom: 5),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Log Out",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
