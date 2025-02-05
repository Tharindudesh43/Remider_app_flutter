import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/screens/health_tasks.dart';
import 'package:smart_to_do_app/screens/personal_tasks.dart';
import 'package:smart_to_do_app/screens/social_tasks.dart';
import 'package:smart_to_do_app/screens/work_tasks.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:smart_to_do_app/widgets/profile_card.dart';
import 'package:smart_to_do_app/widgets/to_do_form_card.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    FirebaseService.gettodotasks().then((ToDoTaskData) {
      context
          .read<TodotaskProvider>()
          .addalltodotasks_Provider(todotasks: ToDoTaskData);
    });

    FirebaseService.getCurruntUsername().then((username) {
      context.read<TodotaskProvider>().addusername(name: username);
    });

    //get data from firestore and add to providers
    FirebaseService.getCurrentUserToDoTasks().then(
      (todoIds) {
        context
            .read<TodotaskProvider>()
            .addCurrentUserToDoTask_Provider(currentuserstodotask: todoIds!);
      },
    );

    FirebaseService.get_level_of_complete().then((value) {
      context.read<TodotaskProvider>().add_level_of_complete(value: value);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? username;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: _isVisible
          ? AppBar(
              toolbarHeight: 82,
              backgroundColor: Colors.white,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(top: 35, left: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Consumer<TodotaskProvider>(
                            builder: (context, hotels, child) {
                          username = hotels.username;
                          return username!.isEmpty
                              ? const Text(
                                  "Hey, ",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 33,
                                  ),
                                )
                              : Text(
                                  "Hey, $username",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 33,
                                  ),
                                );
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Let's make this day productive",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.5),
                              fontSize: 16),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      ProfileCard obj = ProfileCard();
                      obj.DialogCard(contextxx: context, username: username!);
                    },
                    child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: AssetImage('assets/profile.png'),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                ),
              ],
            )
          : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 20),
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 208,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: const AssetImage('assets/taskcomplete.jpg'),
                        colorFilter: ColorFilter.mode(
                            const Color.fromARGB(255, 221, 187, 219)
                                .withOpacity(0.3),
                            BlendMode.darken),
                      ),
                    ),
                  ),
                  Consumer<TodotaskProvider>(
                      builder: (context, todotasks, child) {
                    //  FirebaseService.get_level_of_complete().then((value) {
                    // context.read<TodotaskProvider>().get_level_of_compplete();
                    //  });

                    List<dynamic> level_of_complete =
                        todotasks.level_of_complete;

                    double level_of_completion_precentage = 0.00;
                    String title_one = "none";
                    String title_two = "none";
                    int completed_tasks = 0;
                    int all_tasks = 0;

                    if (level_of_complete.isEmpty) {
                    } else {
                      if (level_of_complete[0] == 0 &&
                          level_of_complete[1] == 0) {
                        level_of_completion_precentage = 0.0;
                        title_one = "No Tasks!";
                        title_two = "Add your task and start";
                      } else {
                        all_tasks = level_of_complete[0];
                        completed_tasks = level_of_complete[1];
                        title_one = "none";
                        title_two = "none";

                        level_of_completion_precentage =
                            (100 / completed_tasks) * all_tasks;

                        if (level_of_completion_precentage >= 80.00) {
                          title_one = "Hurrah";
                          title_two = "You are almost there";
                        } else if (level_of_completion_precentage <= 30.00) {
                          title_one = "Come on!";
                          title_two = "You have more to do";
                        } else if (level_of_completion_precentage == 50.00) {
                          title_one = "Nice!";
                          title_two = "You are done half";
                        } else if (level_of_completion_precentage > 30.00 &&
                            level_of_completion_precentage < 49.00) {
                          title_one = "Steady move!!";
                          title_two = "Good move, but focus on";
                        } else if (level_of_completion_precentage == 100.00) {
                          title_one = "Congratulations!";
                          title_two = "You have completed all tasks.";
                        } else if (level_of_completion_precentage == 0.00) {
                          title_one = "Start!";
                          title_two = "Ok, let's work on";
                        } else if (level_of_completion_precentage > 50.00 &&
                            level_of_completion_precentage < 80.00) {
                          title_one = "Well Done!";
                          title_two =
                              "You are already on the track, \nso run now";
                        }
                      }
                    }

                    return level_of_complete.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(left: 15, top: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "None",
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          color: const Color.fromARGB(
                                              255, 104, 18, 179)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "None",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: const Color.fromARGB(
                                              255, 104, 18, 179)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 60),
                                Row(
                                  children: [
                                    Text(
                                      "0 out of 0 tasks are completed",
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.pink),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: SizedBox(
                                          height: 8,
                                          width: 170,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: LinearProgressIndicator(
                                              value: 0.0,
                                              backgroundColor:
                                                  Colors.pink.shade100,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.pink),
                                            ),
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 15, top: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "$title_one",
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          color: const Color.fromARGB(
                                              255, 104, 18, 179)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "$title_two",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: const Color.fromARGB(
                                              255, 104, 18, 179)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 60),
                                Row(
                                  children: [
                                    Text(
                                      "${all_tasks!} out of ${completed_tasks!} tasks are completed",
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.pink),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: SizedBox(
                                          height: 8,
                                          width: 170,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: LinearProgressIndicator(
                                              value:
                                                  level_of_completion_precentage /
                                                      100,
                                              backgroundColor:
                                                  Colors.pink.shade100,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.pink),
                                            ),
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          );
                  }),

                  //------------
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 20),
                child: Text(
                  "Progress of Tasks",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 25.0,
                    crossAxisSpacing: 25.0,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    String tasktypepassing = "";
                    Color themecolor = Colors.black;

                    if (index == 0) {
                      tasktypepassing = "Personal";
                      themecolor = const Color.fromARGB(238, 86, 0, 247);
                    } else if (index == 1) {
                      tasktypepassing = "Work";
                      themecolor = Colors.lightBlue;
                    } else if (index == 2) {
                      tasktypepassing = "Health";
                      themecolor = const Color.fromARGB(255, 255, 2, 111);
                    } else if (index == 3) {
                      tasktypepassing = "Social";
                      themecolor = Colors.orange;
                    }
                    return gridcontainer(
                      contextpassed: context,
                      indextype: index,
                      tasktype: tasktypepassing,
                      themecolor: themecolor,
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isVisible ? 1.0 : 0.0,
          child: FloatingActionButton(
            hoverColor: Colors.white,
            backgroundColor: Color.fromARGB(255, 221, 187, 219),
            onPressed: () {
              ToDoFormCard obj = ToDoFormCard();
              obj.DialogCard(
                  pagenamepassed: "none",
                  tasktypepassed: 'No Type',
                  docid: "",
                  whichform: true,
                  contextxx: context,
                  descriptionController: "",
                  titleController: "",
                  datepassed: Timestamp.now(),
                  prioritypassed: 'Not Priority');
                  setState(() {
                    HomeScreen obj = HomeScreen();
                  });
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class gridcontainer extends StatefulWidget {
  String tasktype;
  BuildContext contextpassed;
  Color themecolor;
  int indextype;
  gridcontainer({
    required this.contextpassed,
    required this.themecolor,
    required this.indextype,
    super.key,
    required this.tasktype,
  });

  @override
  State<gridcontainer> createState() => _gridcontainerState();
}

class _gridcontainerState extends State<gridcontainer> {
  @override
  Widget build(contextpassed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 5, //5,
            offset: Offset(0, 0), //Offset(3, 3)
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          print("object");
          setState(() {
            if (widget.indextype == 0) {
              Navigator.pushAndRemoveUntil(
                contextpassed,
                MaterialPageRoute(builder: (contextpassed) => PersonalTasks()),
                (Route<dynamic> route) => false,
              );
            } else if (widget.indextype == 1) {
              Navigator.pushAndRemoveUntil(
                contextpassed,
                MaterialPageRoute(builder: (contextpassed) => WorkTasks()),
                (Route<dynamic> route) => false,
              );
            } else if (widget.indextype == 2) {
              Navigator.pushAndRemoveUntil(
                contextpassed,
                MaterialPageRoute(builder: (contextpassed) => HealthTasks()),
                (Route<dynamic> route) => false,
              );
            } else if (widget.indextype == 3) {
              Navigator.pushAndRemoveUntil(
                contextpassed,
                MaterialPageRoute(builder: (contextpassed) => SocialTasks()),
                (Route<dynamic> route) => false,
              );
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      child: Stack(alignment: Alignment.center, children: [
                        CircularProgressIndicator.adaptive(
                          value: 1,
                          backgroundColor: Colors.grey.shade200,
                          valueColor:
                              AlwaysStoppedAnimation<Color?>(widget.themecolor),
                        ),
                        // Center(
                        //     child: Text(
                        //   '70%',
                        //   style: TextStyle(
                        //       fontSize: 10,
                        //       fontWeight: FontWeight.bold,
                        //       color: widget.themecolor),
                        // )),
                      ]),
                    ),
                    Container(
                      height: 0,
                      width: 00,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              color: widget.themecolor,
                              borderRadius: BorderRadius.circular(100)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    widget.tasktype,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Text(
              //       "10 tasks",
              //       style: TextStyle(
              //           fontSize: 14,
              //           color: Colors.black.withOpacity(0.3),
              //           fontWeight: FontWeight.w700),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: widget.themecolor.withOpacity(0.2)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Row(
                            children: [
                              Text(
                                "Include ",
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: widget.themecolor),
                              ),
                              Text("Your all tasks by type",
                                  style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w700,
                                      color: widget.themecolor))
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //       color: Colors.red.withOpacity(0.2)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(
                    //         left: 10, right: 10, top: 5, bottom: 5),
                    //     child: Row(
                    //       children: [
                    //         Text(
                    //           "2 ",
                    //           style: TextStyle(
                    //               fontSize: 9,
                    //               fontWeight: FontWeight.w700,
                    //               color: Colors.red),
                    //         ),
                    //         Text("left",
                    //             style: TextStyle(
                    //                 fontSize: 9,
                    //                 fontWeight: FontWeight.w700,
                    //                 color: Colors.red))
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
