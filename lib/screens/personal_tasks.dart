import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/screens/home_screen.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:smart_to_do_app/widgets/to_do_list_card.dart';
import 'package:smart_to_do_app/widgets/to_do_list_card_completed.dart';

class PersonalTasks extends StatefulWidget {
  PersonalTasks({super.key});

  @override
  State<PersonalTasks> createState() => _PersonalTasksState();
}

class _PersonalTasksState extends State<PersonalTasks> {
  double width = 0;
  bool myAnimation_notcompleted = false;
  bool myAnimation_completed = false;
  bool showContainer1 = true;
  bool showContainer2 = true;

  final ScrollController _scrollController = ScrollController();
  bool isclicked = false;

  @override
  void initState() {
    super.initState();
    FirebaseService.gettodotasks().then((ToDoTaskData) {
      context
          .read<TodotaskProvider>()
          .addalltodotasks_Provider(todotasks: ToDoTaskData);
    });

    FirebaseService.getCurrentUser_personal_todotasks().then(
      (todoIds) {
        context
            .read<TodotaskProvider>()
            .addcurrentuser_personalToDo_task_provider(todotask: todoIds!);
      },
    );

    FirebaseService.getCurrentUser_personal_completed_todotasks().then(
      (todoIds) {
        context
            .read<TodotaskProvider>()
            .addcurrentuser_personal_completed_ToDotask_provider(
                todotask: todoIds!);
      },
    );
    context
        .read<TodotaskProvider>()
        .getOnlyCurrectusers_personal_completed_ToDoTasks();

    FirebaseService.getCurrentUser_personal_not_completed_todotasks().then(
      (todoIds) {
        context
            .read<TodotaskProvider>()
            .addcurrentuser_personal_not_complete_ToDotask_provider(
                todotask: todoIds!);
      },
    );
    context
        .read<TodotaskProvider>()
        .getOnlyCurrectusers_personal_not_completed_ToDoTasks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        HomeScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation.drive(
                          Tween(begin: 0.0, end: 1.0)
                              .chain(CurveTween(curve: Curves.easeInOut)),
                        ),
                        child: child,
                      );
                    },
                  ),
                  (route) =>
                      false, // Removes all previous routes but ensures HomeScreen exists
                );
              },
              icon: const Icon(Icons.arrow_back)),
          title: Text(
            "Personal Tasks",
            style: GoogleFonts.permanentMarker(
                fontSize: 21,
                color: Color.fromARGB(238, 86, 0, 247),
                fontWeight: FontWeight.w500),
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isclicked = false;
                        });
                      },
                      child: Container(
                          width: 130,
                          height: 35,
                          decoration: BoxDecoration(
                              color: isclicked == false
                                  ? const Color.fromARGB(238, 86, 0, 247)
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                              child: Text(
                            "Not Completed",
                            style: GoogleFonts.signika(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: isclicked == false
                                    ? Colors.white
                                    : Colors.black),
                          ))),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isclicked = true;
                        });
                      },
                      child: Container(
                          width: 130,
                          height: 35,
                          decoration: BoxDecoration(
                              color: isclicked == false
                                  ? Colors.grey.withOpacity(0.2)
                                  : const Color.fromARGB(238, 86, 0, 247),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                              child: Text(
                            "Completed",
                            style: GoogleFonts.signika(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: isclicked == false
                                    ? Colors.black
                                    : Colors.white),
                          ))),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            isclicked == false
                ? Expanded(
                    child: SizedBox(
                    height: 350,
                    width: double.infinity,
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      Future.delayed(Duration(seconds: 7), () {
                        setState(() {
                          showContainer1 = false;
                        });
                      });
                      showContainer2 = true;
                      WidgetsBinding.instance.addPostFrameCallback((Timestamp) {
                        setState(() {
                          myAnimation_completed = false;
                        });
                      });
                      WidgetsBinding.instance.addPostFrameCallback((Timestamp) {
                        setState(() {
                          myAnimation_notcompleted = true;
                        });
                      });

                      return Consumer<TodotaskProvider>(
                          builder: (context, todotasks, child) {
                        context
                            .read<TodotaskProvider>()
                            .getOnlyCurrectusers_personal_completed_ToDoTasks();
                        context
                            .read<TodotaskProvider>()
                            .getOnlyCurrectusers_personal_not_completed_ToDoTasks();
                        List<ToDoTask?>
                            allcurrentUser_Personal_not_completed_ToDoTasks =
                            todotasks
                                .currentUser_personal_not_complete_todotasks;
                        print(
                            "Len of all not personal task: ${allcurrentUser_Personal_not_completed_ToDoTasks.length}");
                        return allcurrentUser_Personal_not_completed_ToDoTasks
                                .isEmpty
                            ? showContainer1 == true
                                ? Center(
                                    child: SpinKitWave(
                                    color: Color.fromARGB(238, 86, 0, 247),
                                    size: 50.0,
                                  ))
                                : Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.newspaper,
                                              size: 40,
                                            ),
                                            Text(
                                              "No Data",
                                              style: GoogleFonts.signika(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                          238, 86, 0, 247)
                                                      .withOpacity(1)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                            : ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    allcurrentUser_Personal_not_completed_ToDoTasks
                                        .length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, int index) {
                                  return AnimatedContainer(
                                    duration: Duration(
                                        milliseconds: 400 + (index * 300)),
                                    curve: Curves.easeIn,
                                    transform: Matrix4.translationValues(
                                        myAnimation_notcompleted ? 0 : width,
                                        0,
                                        0),
                                    child: ToDoListCard(
                                      themecolor:
                                          const Color.fromARGB(238, 86, 0, 247),
                                      ToDoTaskData:
                                          allcurrentUser_Personal_not_completed_ToDoTasks[
                                              index]!,
                                    ),
                                  );
                                },
                              );
                      });
                    }),
                  ))
                : Expanded(
                    child: SizedBox(
                    height: 350,
                    width: double.infinity,
                    child: Consumer<TodotaskProvider>(
                        builder: (context, todotasks, child) {
                      Future.delayed(Duration(seconds: 7), () {
                        setState(() {
                          showContainer2 = false;
                        });
                      });
                      showContainer1 = true;

                      WidgetsBinding.instance.addPostFrameCallback((Timestamp) {
                        setState(() {
                          myAnimation_completed = true;
                        });
                      });
                      WidgetsBinding.instance.addPostFrameCallback((Timestamp) {
                        setState(() {
                          myAnimation_notcompleted = false;
                        });
                      });
                      context
                          .read<TodotaskProvider>()
                          .getOnlyCurrectusers_personal_completed_ToDoTasks();
                      context
                          .read<TodotaskProvider>()
                          .getOnlyCurrectusers_personal_not_completed_ToDoTasks();

                      List<ToDoTask?>
                          allcurrentUser_Personal_completed_ToDoTasks =
                          todotasks.currentUser_personal_completed_todotasks;
                      print(
                          "Len of all personal completed task: ${allcurrentUser_Personal_completed_ToDoTasks.length}");
                      return allcurrentUser_Personal_completed_ToDoTasks.isEmpty
                          ? showContainer2 == true
                              ? Center(
                                  child: SpinKitWave(
                                  color: Color.fromARGB(238, 86, 0, 247),
                                  size: 50.0,
                                ))
                              : Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.newspaper,
                                            size: 40,
                                          ),
                                          Text(
                                            "No Data",
                                            style: GoogleFonts.signika(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                        238, 86, 0, 247)
                                                    .withOpacity(1)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount:
                                  allcurrentUser_Personal_completed_ToDoTasks
                                      .length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, int index) {
                                return AnimatedContainer(
                                  duration: Duration(
                                      milliseconds: 400 + (index * 300)),
                                  curve: Curves.easeIn,
                                  transform: Matrix4.translationValues(
                                      myAnimation_completed ? 0 : width, 0, 0),
                                  child: ToDoListCardCompleted(
                                    themecolor:
                                        const Color.fromARGB(238, 86, 0, 247),
                                    ToDoTaskData:
                                        allcurrentUser_Personal_completed_ToDoTasks[
                                            index]!,
                                  ),
                                );
                              },
                            );
                    }),
                  ))
          ],
        ));
  }
}
