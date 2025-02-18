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
import 'package:google_fonts/google_fonts.dart';

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

    FirebaseService.get_level_of_work_tasks().then((value) {
      print("work: $value");
      context
          .read<TodotaskProvider>()
          .add_level_of_compeletion_work_tasks(value: value!);
    });

    FirebaseService.get_level_of_health_tasks().then((value) {
      print("health: $value");
      context
          .read<TodotaskProvider>()
          .add_level_of_compeletion_health_tasks(value: value!);
    });

    FirebaseService.get_level_of_social_tasks().then((value) {
      print("social: $value");
      context
          .read<TodotaskProvider>()
          .add_level_of_compeletion_social_tasks(value: value!);
    });

    FirebaseService.get_level_of_complete().then((value) {
      context.read<TodotaskProvider>().add_level_of_complete(value: value);
    });

    FirebaseService.get_level_of_personal_tasks().then((value) {
      print("personal: $value");
      context
          .read<TodotaskProvider>()
          .add_level_of_compeletion_personal_tasks(value: value!);
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
    double screenHeight = MediaQuery.of(context).size.height;
    String? username;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: _isVisible
          ? AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 90, //for_mobile:65 //for_emulator:90
              backgroundColor: Colors.white,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(
                    top: 45, left: 18), //for_op_em:45 //55
                child: Column(
                  children: [
                    Row(
                      children: [
                        Consumer<TodotaskProvider>(
                            builder: (context, hotels, child) {
                          username = hotels.username;
                          return username!.isEmpty
                              ? Text(
                                  "Hey, ",
                                  style: GoogleFonts.permanentMarker(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 26,
                                  ),
                                )
                              : Text(
                                  () {
                                    List<String> nameParts =
                                        username!.split(" ");
                                    int halfLength =
                                        (nameParts.length / 2).ceil();
                                    String firstHalf =
                                        nameParts.take(halfLength).join(" ");
                                    return firstHalf.length > 20
                                        ? "Hey, ${nameParts[0].substring(0, 10)}.."
                                        : "Hey, $firstHalf";
                                  }(),
                                  style: GoogleFonts.permanentMarker(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 26,
                                  ),
                                );
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Let's make this day productive",
                          style: GoogleFonts.geologica(
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
                        width: 40, //for_em:35
                        height: 40, //for_em:35
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
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 15, bottom: 20), //top_for_emu:20 //10
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
                    height: 215,
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
                          title_one = "Hurrah !";
                          title_two = "You are almost there";
                        } else if (level_of_completion_precentage <= 30.00) {
                          title_one = "Come on !";
                          title_two = "You have more to do";
                        } else if (level_of_completion_precentage == 50.00) {
                          title_one = "Nice !";
                          title_two = "You are done half";
                        } else if (level_of_completion_precentage > 30.00 &&
                            level_of_completion_precentage < 49.00) {
                          title_one = "Steady move !!";
                          title_two = "Good move, but focus on";
                        } else if (level_of_completion_precentage == 100.00) {
                          title_one = "Congratulations!";
                          title_two = "You have completed all tasks.";
                        } else if (level_of_completion_precentage == 0.00) {
                          title_one = "Start !";
                          title_two = "Ok, let's work on";
                        } else if (level_of_completion_precentage > 50.00 &&
                            level_of_completion_precentage < 80.00) {
                          title_one = "Well Done !";
                          title_two = "You are already on the track.";
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
                                      style: GoogleFonts.geologica(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Color.fromARGB(255, 0, 17, 255)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "None",
                                      style: GoogleFonts.geologica(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Color.fromARGB(255, 0, 17, 255)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 60),
                                Row(
                                  children: [
                                    Text(
                                      "0 out of 0 tasks are completed",
                                      style: GoogleFonts.geologica(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color:
                                              Color.fromARGB(255, 0, 17, 255)),
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
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.pink),
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
                                      style: GoogleFonts.bangers(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w300,
                                          color:
                                              Color.fromARGB(255, 0, 17, 255)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "$title_two",
                                      style: GoogleFonts.geologica(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 0, 17, 255)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 75),
                                Row(
                                  children: [
                                    Text(
                                      "${all_tasks!} out of ${completed_tasks!} tasks are completed",
                                      style: GoogleFonts.geologica(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 0, 38, 255)),
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
                                              value: level_of_completion_precentage ==
                                                      "NaN"
                                                  ? 0
                                                  : level_of_completion_precentage /
                                                      100,
                                              backgroundColor: Color.fromARGB(
                                                      255, 0, 38, 255)
                                                  .withOpacity(0.3),
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                          Color>(
                                                      Color.fromARGB(
                                                          255, 0, 38, 255)),
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
                padding: const EdgeInsets.only(
                    left: 25, bottom: 25, top: 5), //bottom_em:20
                child: Text(
                  "Progress of Tasks",
                  style: GoogleFonts.daysOne(
                      fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer<TodotaskProvider>(
                    builder: (context, todotasks, child) {
                  List<dynamic> level_personal_tasks =
                      todotasks.level_of_completion_of_personal_tasks;
                  List<dynamic> level_work_tasks =
                      todotasks.level_of_completion_of_work_tasks;
                  List<dynamic> level_health_tasks =
                      todotasks.level_of_completion_of_health_tasks;
                  List<dynamic> level_social_tasks =
                      todotasks.level_of_completion_of_social_tasks;
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                          return gridcontainer(
                            personal_task_level: level_personal_tasks,
                            contextpassed: context,
                            indextype: index,
                            tasktype: tasktypepassing,
                            themecolor: themecolor,
                          );
                        } else if (index == 1) {
                          tasktypepassing = "Work";
                          themecolor = Colors.lightBlue;
                          return gridcontainer(
                            personal_task_level: level_work_tasks,
                            contextpassed: context,
                            indextype: index,
                            tasktype: tasktypepassing,
                            themecolor: themecolor,
                          );
                        } else if (index == 2) {
                          tasktypepassing = "Health";
                          themecolor = const Color.fromARGB(255, 255, 2, 111);
                          return gridcontainer(
                            personal_task_level: level_health_tasks,
                            contextpassed: context,
                            indextype: index,
                            tasktype: tasktypepassing,
                            themecolor: themecolor,
                          );
                        } else if (index == 3) {
                          tasktypepassing = "Social";
                          themecolor = Colors.orange;
                          return gridcontainer(
                            personal_task_level: level_social_tasks,
                            contextpassed: context,
                            indextype: index,
                            tasktype: tasktypepassing,
                            themecolor: themecolor,
                          );
                        }
                      });
                })),
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
            hoverColor: const Color.fromARGB(255, 255, 255, 255),
            backgroundColor: Color.fromARGB(255, 0, 17, 255),
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
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
              weight: 100,
            ),
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
  List<dynamic> personal_task_level;
  gridcontainer({
    required this.personal_task_level,
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5, //5,
            offset: Offset(0, 0), //Offset(3, 3)
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            if (widget.indextype == 0) {
              Navigator.push(
                contextpassed,
                PageRouteBuilder(
                  pageBuilder: (contextpassed, animation, persnalAnimation) =>
                      PersonalTasks(),
                  transitionsBuilder:
                      (contextpassed, animation, persnalAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ).then((value) {
                Navigator.push(
                  contextpassed,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              });
            } else if (widget.indextype == 1) {
              Navigator.push(
                contextpassed,
                PageRouteBuilder(
                  pageBuilder: (contextpassed, animation, persnalAnimation) =>
                      WorkTasks(),
                  transitionsBuilder:
                      (contextpassed, animation, persnalAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ).then((value) {
                Navigator.push(
                  contextpassed,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              });
            } else if (widget.indextype == 2) {
              Navigator.push(
                contextpassed,
                PageRouteBuilder(
                  pageBuilder: (contextpassed, animation, persnalAnimation) =>
                      HealthTasks(),
                  transitionsBuilder:
                      (contextpassed, animation, persnalAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ).then((value) {
                Navigator.push(
                  contextpassed,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              });
            } else if (widget.indextype == 3) {
              Navigator.push(
                contextpassed,
                PageRouteBuilder(
                  pageBuilder: (contextpassed, animation, persnalAnimation) =>
                      SocialTasks(),
                  transitionsBuilder:
                      (contextpassed, animation, persnalAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              ).then((value) {
                Navigator.push(
                  contextpassed,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              });
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
                      height: 36,
                      width: 36,
                      child: Stack(alignment: Alignment.center, children: [
                        widget.personal_task_level.isEmpty
                            ? CircularProgressIndicator.adaptive(
                                value: 0.0,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color?>(
                                    widget.themecolor),
                              )
                            : CircularProgressIndicator.adaptive(
                                value: () {
                                  if (widget.personal_task_level[0] == 0)
                                    return 0.0;
                                  double percentage =
                                      widget.personal_task_level[1]! /
                                          widget.personal_task_level[0];
                                  return percentage.isNaN
                                      ? 0.0
                                      : percentage.clamp(0.0, 1.0);
                                }(),
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    widget.themecolor),
                              ),
                        widget.personal_task_level.isEmpty
                            ? Center(
                                child: Text(
                                "0 %",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: widget.themecolor),
                              ))
                            : Center(
                                child: Text(
                                () {
                                  double precentage =
                                      ((widget.personal_task_level[1]! /
                                              widget.personal_task_level[0]) *
                                          100);
                                  String formatted =
                                      precentage.toStringAsFixed(2);
                                  formatted =
                                      formatted.replaceAll(RegExp(r'0+$'), '');
                                  formatted =
                                      formatted.replaceAll(RegExp(r'\.$'), '');

                                  return formatted == "NaN"
                                      ? "0 %"
                                      : "${formatted.toString()}%";
                                }(),
                                style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                    color: widget.themecolor),
                              )),
                      ]),
                    ),
                    const SizedBox(
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
                    style: GoogleFonts.secularOne(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: widget.themecolor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  widget.personal_task_level.isEmpty
                      ? Text(
                          "0 tasks",
                          style: GoogleFonts.secularOne(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.3),
                              fontWeight: FontWeight.w700),
                        )
                      : Text(
                          "${widget.personal_task_level[0].toString()!} tasks",
                          style: GoogleFonts.secularOne(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.3),
                              fontWeight: FontWeight.w700),
                        ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
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
                            widget.personal_task_level.isEmpty
                                ? Text("0 Completed",
                                    style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        color: widget.themecolor))
                                : Text(
                                    "${widget.personal_task_level[1].toString()!} Completed",
                                    style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w700,
                                        color: widget.themecolor))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red.withOpacity(0.2)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        children: [
                          widget.personal_task_level.isEmpty
                              ? const Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red),
                                )
                              : Text(
                                  widget.personal_task_level[2].toString()!,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red),
                                ),
                          const Text(" left",
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
