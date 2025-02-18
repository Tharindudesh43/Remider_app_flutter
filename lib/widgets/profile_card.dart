import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/main.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard {
  Future<dynamic> DialogCard(
      {required BuildContext contextxx, required String username}) {
    final ValueNotifier<bool> isLoadCardButton = ValueNotifier<bool>(false);
    return showDialog(
      context: contextxx,
      builder: (BuildContext context) {
        return Dialog(
          shadowColor:
              const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          child: SizedBox(
            width: 330, //200
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    () {
                      List<String> nameParts = username!.split(" ");
                      int halfLength = (nameParts.length / 2).ceil();
                      String firstHalf = nameParts.take(halfLength).join(" ");
                      return nameParts[0].length > 13
                          ? "${nameParts[0].substring(0, 10)}.."
                          : firstHalf;
                    }(),
                    style: GoogleFonts.bowlbyOneSc(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
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
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              await GoogleSignIn().signOut();
                              context
                                  .read<TodotaskProvider>()
                                  .clearcurrentuserTasks();
                              context
                                  .read<TodotaskProvider>()
                                  .clearcurrentusername();
                              context
                                  .read<TodotaskProvider>()
                                  .clearcurrentuser_personal_Tasks();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyApp()),
                                (Route<dynamic> route) => false,
                              );
                              // context
                              //     .read<TodotaskProvider>()
                              //     .clear_level_of_complete();
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
                      ),
                      // TextButton(
                      //   style: TextButton.styleFrom(
                      //       backgroundColor:
                      //           const Color.fromARGB(255, 255, 3, 175)),
                      //   child: const Text('Balance Tasks',
                      //       style: TextStyle(
                      //           color: Color.fromARGB(255, 255, 255, 255),
                      //           fontSize: 15)),
                      //   onPressed: () {
                      //     FirebaseService
                      //         .balance_comleted_tasks_with_existing_data();
                      //     Navigator.pushAndRemoveUntil(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const MyApp()),
                      //       (Route<dynamic> route) => false,
                      //     );
                      //   },
                      // ),
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
