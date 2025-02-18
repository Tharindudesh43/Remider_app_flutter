import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/screens/health_tasks.dart';
import 'package:smart_to_do_app/screens/social_tasks.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoFormCard {
  Future<dynamic> DialogCard(
      {BuildContext? contextxx,
      required String tasktypepassed,
      required String pagenamepassed,
      required String titleController,
      required String descriptionController,
      required Timestamp datepassed,
      required String prioritypassed,
      required bool whichform,
      required String docid}) {
    TextEditingController titleFieldController =
        TextEditingController(text: titleController);
    TextEditingController descriptionFieldController =
        TextEditingController(text: descriptionController);
    bool whichformofthis = whichform;
    String editdocid = docid;

    DateTime dateTime = datepassed.toDate();

    DateTime selectedDate = dateTime;

    List<String> values = ['Top Priority', 'Medium Priority', 'Low Priority'];
    List<String> tasktypevalues = ['Personal', 'Work', 'Health', 'Social'];
    String selectedpriority = prioritypassed;
    String selectedtasktype = tasktypepassed;
    String pagename = pagenamepassed;

    final ValueNotifier<bool> isLoadCardButton = ValueNotifier<bool>(false);
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    return showDialog(
      context: contextxx!,
      builder: (contextxx) {
        return StatefulBuilder(
          builder: (contextxx, StateSetter setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(0),
              child: Container(
                  width: MediaQuery.of(contextxx).size.width - 10,
                  height: MediaQuery.of(contextxx).size.height / 1.3,
                  child: whichformofthis == true
                      ? AlertDialog(
                          scrollable: true,
                          title: Text(
                            'ADD A TASK',
                            style: GoogleFonts.bungee(
                                fontSize: 18,
                                color: Color.fromARGB(255, 217, 38, 241),
                                fontWeight: FontWeight.w200),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                CardTextField(
                                  fieldController: titleFieldController,
                                  textFieldValue: "Title",
                                ),
                                CardTextField(
                                  fieldController: descriptionFieldController,
                                  textFieldValue: "Description",
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                      style: GoogleFonts.bungee(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                          color: Color.fromARGB(
                                              255, 157, 210, 51)),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 30,
                                      child: TextButton(
                                        autofocus: true,
                                        style: TextButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255, 217, 38, 241)),
                                        onPressed: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                            context: contextxx,
                                            initialDate: selectedDate,
                                            firstDate: DateTime(2015, 8),
                                            lastDate: DateTime(2101),
                                          );
                                          if (picked != null &&
                                              picked != selectedDate) {
                                            setState(() {
                                              selectedDate = picked;
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Select date',
                                          style: GoogleFonts.bungee(
                                              fontSize: 10,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedpriority,
                                      style: GoogleFonts.bungee(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 11,
                                        color: selectedpriority ==
                                                "Top Priority"
                                            ? Colors.red
                                            : selectedpriority == "Low Priority"
                                                ? Colors.lightBlueAccent
                                                : selectedpriority ==
                                                        "Medium Priority"
                                                    ? Colors.green
                                                    : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(),
                                      child: DropdownButton<String>(
                                        dropdownColor: const Color.fromARGB(
                                            255, 243, 244, 245),
                                        focusColor: Colors.amberAccent,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: values.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(
                                              items,
                                              style: GoogleFonts.bungee(
                                                fontSize: 11,
                                                color: items == "Top Priority"
                                                    ? Colors.red
                                                    : items == "Low Priority"
                                                        ? Colors.lightBlueAccent
                                                        : Colors.green,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedpriority = value!;
                                          });
                                        },
                                        underline: SizedBox(),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedtasktype,
                                      style: GoogleFonts.bungee(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: selectedtasktype == "Personal"
                                            ? Color.fromARGB(238, 86, 0, 247)
                                            : selectedtasktype == "Work"
                                                ? Colors.lightBlue
                                                : selectedtasktype == "Health"
                                                    ? Colors.pink
                                                    : selectedtasktype ==
                                                            "Social"
                                                        ? Colors.orange
                                                        : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(0),
                                      child: Center(
                                        child: DropdownButton<String>(
                                          dropdownColor: const Color.fromARGB(
                                              255, 243, 244, 245),
                                          focusColor: Colors.amberAccent,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: tasktypevalues
                                              .map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(
                                                items,
                                                style: GoogleFonts.bungee(
                                                  fontSize: 12,
                                                  color: items == "Personal"
                                                      ? Color.fromARGB(
                                                          238, 86, 0, 247)
                                                      : items == "Work"
                                                          ? Colors.lightBlue
                                                          : items == "Health"
                                                              ? Colors.pink
                                                              : items ==
                                                                      "Social"
                                                                  ? Colors
                                                                      .orange
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      0,
                                                                      0,
                                                                      0),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedtasktype = value!;
                                            });
                                          },
                                          underline: const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 4, 4)),
                              child: Text('Reset',
                                  style: GoogleFonts.bungee(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontWeight: FontWeight.w300)),
                              onPressed: () {
                                setState(() {
                                  selectedDate = DateTime.now();
                                  titleFieldController.clear();
                                  descriptionFieldController.clear();
                                  selectedpriority = "Not Priority";
                                  selectedtasktype = "No Type";
                                });
                              },
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: isLoadCardButton,
                              builder: (context, isLoading, _) {
                                return InkWell(
                                  onTap: () {
                                    isLoading = true;
                                    FirebaseService.addtodotask(
                                            tasktype:
                                                selectedtasktype.toString(),
                                            title: titleFieldController.text
                                                .trim(),
                                            description:
                                                descriptionFieldController.text
                                                    .trim(),
                                            priority:
                                                selectedpriority.toString(),
                                            date: selectedDate)
                                        .then((TaskId) {
                                      if (TaskId != null) {
                                        print("Task ID: {$TaskId}");
                                        FirebaseService.addtodotasktouser(
                                            docid: TaskId);
                                        FirebaseService.gettodotasks()
                                            .then((ToDoTaskData) {
                                          context
                                              .read<TodotaskProvider>()
                                              .addalltodotasks_Provider(
                                                  todotasks: ToDoTaskData);
                                          context
                                              .read<TodotaskProvider>()
                                              .updateCurrentuserToDOTasks(
                                                  taskId: TaskId);

                                          //-------------------------
                                          FirebaseService
                                                  .get_level_of_complete()
                                              .then((value) {
                                            context
                                                .read<TodotaskProvider>()
                                                .add_level_of_complete(
                                                    value: value);
                                          });
                                          //--------------------------
                                        });

                                        if (selectedtasktype == "Personal") {
                                          context
                                              .read<TodotaskProvider>()
                                              .reduce_level_of_completion_personal_tasks();
                                        } else if (selectedtasktype == "Work") {
                                          context
                                              .read<TodotaskProvider>()
                                              .reduce_level_of_completion_work_tasks();
                                        } else if (selectedtasktype ==
                                            "Health") {
                                          context
                                              .read<TodotaskProvider>()
                                              .reduce_level_of_completion_health_tasks();
                                        } else if (selectedtasktype ==
                                            "Social") {
                                          context
                                              .read<TodotaskProvider>()
                                              .reduce_level_of_completion_social_tasks();
                                        }

                                        Navigator.of(contextxx).pop();
                                        Flushbar(
                                          message: "Added a Task",
                                          icon: Icon(
                                            Icons.add,
                                            size: 28.0,
                                            color: Color.fromARGB(
                                                255, 217, 38, 241),
                                          ),
                                          margin: EdgeInsets.all(6.0),
                                          flushbarStyle: FlushbarStyle.FLOATING,
                                          flushbarPosition:
                                              FlushbarPosition.BOTTOM,
                                          textDirection:
                                              Directionality.of(context),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor:
                                              Color.fromARGB(255, 217, 38, 241),
                                        ).show(context);
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(const SnackBar(
                                        //   backgroundColor: Colors.purple,
                                        //   shape: StadiumBorder(),
                                        //   behavior: SnackBarBehavior.floating,
                                        //   margin: EdgeInsets.all(5),
                                        //   content: Center(
                                        //     child: Text(
                                        //       "Added a Task",
                                        //       style: TextStyle(
                                        //           fontWeight: FontWeight.w700,
                                        //           color: Color.fromARGB(
                                        //               255, 255, 255, 255)),
                                        //     ),
                                        //   ),
                                        //   elevation: 20,
                                        // ));
                                      } else {
                                        print(
                                            "Adding Error" + TaskId.toString());
                                      }
                                    });
                                    context
                                        .read<TodotaskProvider>()
                                        .update_after_add_todo_level_complete();
                                  },
                                  child:
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       vertical: 10, horizontal: 10),
                                      //child:
                                      Container(
                                    width: 95,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: const Color.fromARGB(
                                          215, 27, 255, 107),
                                    ),
                                    // child: Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       left: 0, right: 0, top: 5, bottom: 5),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Save",
                                                style: GoogleFonts.bungee(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color.fromARGB(
                                                      255, 14, 14, 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                    //),
                                  ),
                                );
                              },
                            )
                          ],
                        )
                      :
                      //-------------------------Update-Form-----------------------------
                      AlertDialog(
                          scrollable: true,
                          title: Text(
                            'ADD A TASK',
                            style: GoogleFonts.bungee(
                                fontSize: 18,
                                color: Color.fromARGB(255, 217, 38, 241),
                                fontWeight: FontWeight.w200),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                CardTextField(
                                  textFieldValue: "Title",
                                  fieldController: titleFieldController,
                                ),
                                CardTextField(
                                  textFieldValue: "Description",
                                  fieldController: descriptionFieldController,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                      style: GoogleFonts.bungee(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                          color: Color.fromARGB(
                                              255, 157, 210, 51)),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 30,
                                      child: TextButton(
                                        autofocus: true,
                                        style: TextButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255, 217, 38, 241)),
                                        onPressed: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                            context: contextxx,
                                            initialDate: selectedDate,
                                            firstDate: DateTime(2015, 8),
                                            lastDate: DateTime(2101),
                                          );
                                          if (picked != null &&
                                              picked != selectedDate) {
                                            setState(() {
                                              selectedDate = picked;
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Select date',
                                          style: GoogleFonts.bungee(
                                              fontSize: 10,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontWeight: FontWeight.w100),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedpriority,
                                      style: GoogleFonts.bungee(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 11,
                                          color:
                                              selectedpriority == "Top Priority"
                                                  ? Colors.red
                                                  : selectedpriority ==
                                                          "Low Priority"
                                                      ? const Color.fromARGB(
                                                          255, 252, 161, 24)
                                                      : Colors.green),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(),
                                      child: DropdownButton<String>(
                                        dropdownColor: const Color.fromARGB(
                                            255, 243, 244, 245),
                                        focusColor: Colors.amberAccent,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: values.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(
                                              items,
                                              style: GoogleFonts.bungee(
                                                fontSize: 11,
                                                color: items == "Top Priority"
                                                    ? Colors.red
                                                    : items == "Low Priority"
                                                        ? Colors.lightBlueAccent
                                                        : items ==
                                                                "Medium Priority"
                                                            ? Colors.green
                                                            : Colors.black,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedpriority = value!;
                                          });
                                        },
                                        underline: const SizedBox(),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedtasktype,
                                      style: GoogleFonts.bungee(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: selectedtasktype == "Personal"
                                            ? Color.fromARGB(238, 86, 0, 247)
                                            : selectedtasktype == "Work"
                                                ? Colors.lightBlue
                                                : selectedtasktype == "Health"
                                                    ? Color.fromARGB(
                                                        255, 255, 2, 111)
                                                    : selectedtasktype ==
                                                            "Social"
                                                        ? Colors.orange
                                                        : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(0),
                                      child: Center(
                                        child: DropdownButton<String>(
                                          dropdownColor: const Color.fromARGB(
                                              255, 243, 244, 245),
                                          focusColor: Colors.amberAccent,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: tasktypevalues
                                              .map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(
                                                items,
                                                style: GoogleFonts.bungee(
                                                  fontSize: 12,
                                                  color: items == "Personal"
                                                      ? Color.fromARGB(
                                                          238, 86, 0, 247)
                                                      : items == "Work"
                                                          ? Colors.lightBlue
                                                          : items == "Health"
                                                              ? Colors.pink
                                                              : items ==
                                                                      "Social"
                                                                  ? Colors
                                                                      .orange
                                                                  : Colors
                                                                      .black,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedtasktype = value!;
                                            });
                                          },
                                          underline: const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 4, 4)),
                              child: Text('Reset',
                                  style: GoogleFonts.bungee(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w300)),
                              onPressed: () {
                                setState(() {
                                  selectedDate = DateTime.now();
                                  titleFieldController.clear();
                                  descriptionFieldController.clear();
                                  selectedpriority = "Not Selected";
                                });
                              },
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: isLoadCardButton,
                              builder: (context, isLoading, _) {
                                return InkWell(
                                  onTap: () {
                                    isLoading == true;
                                    print("Edit Form ID: $editdocid");

                                    FirebaseService.updatecurrentusertodotask(
                                        tasktype: selectedtasktype,
                                        date: selectedDate,
                                        description: descriptionFieldController
                                            .text
                                            .trim(),
                                        title: titleFieldController.text.trim(),
                                        priority: selectedpriority,
                                        editdocid: editdocid);

                                    if (pagename == "Personal") {
                                      if (selectedtasktype != "Personal") {
                                        context
                                            .read<TodotaskProvider>()
                                            .removeCurrentuser_personal_ToDOTask_update(
                                                taskId: docid);
                                      } else {
                                        FirebaseService.gettodotasks()
                                            .then((alltodotasksList) {
                                          context
                                              .read<TodotaskProvider>()
                                              .addalltodotasks_Provider(
                                                  todotasks: alltodotasksList);
                                        });

                                        FirebaseService
                                                .getCurrentUserToDoTasks()
                                            .then((current_todoIds) {
                                          context
                                              .read<TodotaskProvider>()
                                              .addCurrentUserToDoTask_Provider(
                                                  currentuserstodotask:
                                                      current_todoIds!);
                                        });
                                        context
                                            .read<TodotaskProvider>()
                                            .get_updated_not_complete_personla_task_LIST(
                                                taskId: editdocid,
                                                date: selectedDate,
                                                description:
                                                    descriptionFieldController
                                                        .text
                                                        .trim(),
                                                priority: selectedpriority,
                                                tasktype: selectedtasktype,
                                                title: titleFieldController.text
                                                    .trim());
                                      }

                                      // Navigator.of(contextxx).pop();
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(const SnackBar(
                                      //   backgroundColor: Colors.deepPurple,
                                      //   shape: StadiumBorder(),
                                      //   behavior: SnackBarBehavior.floating,
                                      //   margin: EdgeInsets.all(20),
                                      //   content: Text(
                                      //     "Updated a Task",
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.w500,
                                      //         fontSize: 15),
                                      //   ),
                                      //   elevation: 12,
                                      // ));
                                    } else if (pagename == "Work") {
                                      if (selectedtasktype != "Work") {
                                        context
                                            .read<TodotaskProvider>()
                                            .removeCurrentuser_work_ToDOTask_update(
                                                taskId: docid);
                                      } else {
                                        FirebaseService.gettodotasks()
                                            .then((alltodotasksList) {
                                          context
                                              .read<TodotaskProvider>()
                                              .addalltodotasks_Provider(
                                                  todotasks: alltodotasksList);
                                        });

                                        FirebaseService
                                                .getCurrentUserToDoTasks()
                                            .then((current_todoIds) {
                                          context
                                              .read<TodotaskProvider>()
                                              .addCurrentUserToDoTask_Provider(
                                                  currentuserstodotask:
                                                      current_todoIds!);
                                        });

                                        context
                                            .read<TodotaskProvider>()
                                            .get_updated_not_complete_work_task_LIST(
                                                taskId: editdocid,
                                                date: selectedDate,
                                                description:
                                                    descriptionFieldController
                                                        .text
                                                        .trim(),
                                                priority: selectedpriority,
                                                tasktype: selectedtasktype,
                                                title: titleFieldController.text
                                                    .trim());
                                      }

                                      // Navigator.of(contextxx).pop();
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(const SnackBar(
                                      //   backgroundColor: Colors.deepPurple,
                                      //   shape: StadiumBorder(),
                                      //   behavior: SnackBarBehavior.floating,
                                      //   margin: EdgeInsets.all(20),
                                      //   content: Text(
                                      //     "Updated a Task",
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.w500,
                                      //         fontSize: 15),
                                      //   ),
                                      //   elevation: 12,
                                      // ));
                                    } else if (pagename == "Health") {
                                      if (selectedtasktype != "Health") {
                                        context
                                            .read<TodotaskProvider>()
                                            .removeCurrentuser_health_ToDOTask_update(
                                                taskId: docid);
                                      } else {
                                        FirebaseService.gettodotasks()
                                            .then((alltodotasksList) {
                                          context
                                              .read<TodotaskProvider>()
                                              .addalltodotasks_Provider(
                                                  todotasks: alltodotasksList);
                                        });

                                        FirebaseService
                                                .getCurrentUserToDoTasks()
                                            .then((current_todoIds) {
                                          context
                                              .read<TodotaskProvider>()
                                              .addCurrentUserToDoTask_Provider(
                                                  currentuserstodotask:
                                                      current_todoIds!);
                                        });
                                        context
                                            .read<TodotaskProvider>()
                                            .get_updated_not_complete_health_task_LIST(
                                                taskId: editdocid,
                                                date: selectedDate,
                                                description:
                                                    descriptionFieldController
                                                        .text
                                                        .trim(),
                                                priority: selectedpriority,
                                                tasktype: selectedtasktype,
                                                title: titleFieldController.text
                                                    .trim());
                                      }

                                      // Navigator.of(contextxx).pop();
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(const SnackBar(
                                      //   backgroundColor: Colors.deepPurple,
                                      //   shape: StadiumBorder(),
                                      //   behavior: SnackBarBehavior.floating,
                                      //   margin: EdgeInsets.all(20),
                                      //   content: Text(
                                      //     "Updated a Task",
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.w500,
                                      //         fontSize: 15),
                                      //   ),
                                      //   elevation: 12,
                                      // ));
                                    } else if (pagename == "Social") {
                                      if (selectedtasktype != "Social") {
                                        context
                                            .read<TodotaskProvider>()
                                            .removeCurrentuser_social_ToDOTask_update(
                                                taskId: docid);
                                      } else {
                                        FirebaseService.gettodotasks()
                                            .then((alltodotasksList) {
                                          context
                                              .read<TodotaskProvider>()
                                              .addalltodotasks_Provider(
                                                  todotasks: alltodotasksList);
                                        });

                                        FirebaseService
                                                .getCurrentUserToDoTasks()
                                            .then((current_todoIds) {
                                          context
                                              .read<TodotaskProvider>()
                                              .addCurrentUserToDoTask_Provider(
                                                  currentuserstodotask:
                                                      current_todoIds!);
                                        });
                                        context
                                            .read<TodotaskProvider>()
                                            .get_updated_not_social_task_LIST(
                                                taskId: editdocid,
                                                date: selectedDate,
                                                description:
                                                    descriptionFieldController
                                                        .text
                                                        .trim(),
                                                priority: selectedpriority,
                                                tasktype: selectedtasktype,
                                                title: titleFieldController.text
                                                    .trim());
                                      }
                                      // Navigator.of(contextxx).pop();
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(const SnackBar(
                                      //   backgroundColor: Colors.deepPurple,
                                      //   shape: StadiumBorder(),
                                      //   behavior: SnackBarBehavior.floating,
                                      //   margin: EdgeInsets.all(20),
                                      //   content: Text(
                                      //     "Updated a Task",
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.w500,
                                      //         fontSize: 15),
                                      //   ),
                                      //   elevation: 12,
                                      // ));
                                    }

                                    Navigator.of(contextxx).pop();
                                    Flushbar(
                                      message: "Updated a Task",
                                      icon: Icon(
                                        Icons.update,
                                        size: 28.0,
                                        color:
                                            Color.fromARGB(255, 217, 38, 241),
                                      ),
                                      margin: EdgeInsets.all(6.0),
                                      flushbarStyle: FlushbarStyle.FLOATING,
                                      flushbarPosition: FlushbarPosition.BOTTOM,
                                      textDirection: Directionality.of(context),
                                      borderRadius: BorderRadius.circular(12),
                                      duration: Duration(seconds: 3),
                                      leftBarIndicatorColor:
                                          Color.fromARGB(255, 217, 38, 241),
                                    ).show(context);
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(const SnackBar(
                                    //   backgroundColor: Colors.deepPurple,
                                    //   shape: StadiumBorder(),
                                    //   behavior: SnackBarBehavior.floating,
                                    //   margin: EdgeInsets.all(20),
                                    //   content: Text(
                                    //     "Updated a Task",
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.w500,
                                    //         fontSize: 15),
                                    //   ),
                                    //   elevation: 12,
                                    // ));
                                  },
                                  child:
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       vertical: 10, horizontal: 10),
                                      //   child:
                                      Container(
                                    width: 100,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: const Color.fromARGB(
                                          215, 27, 255, 107),
                                    ),
                                    // child: Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       left: 0,
                                    //       right: 0,
                                    //       top: 5,
                                    //       bottom: 5),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Update",
                                                style: GoogleFonts.bungee(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color.fromARGB(
                                                      255, 14, 14, 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                  // ),
                                  // ),
                                );
                              },
                            )
                          ],
                        )
                  //-------------------------Update-Form-----------------------------
                  ),
            );
          },
        );
      },
    );
  }
}

class CardTextField extends StatefulWidget {
  const CardTextField({
    super.key,
    required this.fieldController,
    required this.textFieldValue,
  });

  final TextEditingController fieldController;
  final String textFieldValue;

  @override
  State<CardTextField> createState() => _CardTextFieldState();
}

class _CardTextFieldState extends State<CardTextField> {
  int _charCount = 0;
  late int _maxLength;

  @override
  void initState() {
    super.initState();

    // Set max length based on textFieldValue
    _maxLength = widget.textFieldValue == "Title" ? 30 : 100;

    widget.fieldController.addListener(() {
      setState(() {
        _charCount = widget.fieldController.text.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDescription = widget.textFieldValue == "Description";

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.fieldController,
            keyboardType:
                isDescription ? TextInputType.multiline : TextInputType.text,
            minLines: isDescription ? 5 : 1,
            maxLines: isDescription ? 7 : 1,
            maxLength: _maxLength, // Apply dynamic max length
            inputFormatters: [LengthLimitingTextInputFormatter(_maxLength)],
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  const Color.fromARGB(255, 130, 130, 127).withOpacity(0.1),
              labelText: widget.textFieldValue,
              labelStyle: GoogleFonts.bungee(fontSize: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              "$_charCount / $_maxLength",
              style: GoogleFonts.bungee(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
