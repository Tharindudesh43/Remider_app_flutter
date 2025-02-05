import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/screens/health_tasks.dart';
import 'package:smart_to_do_app/screens/home_screen.dart';
import 'package:smart_to_do_app/screens/personal_tasks.dart';
import 'package:smart_to_do_app/screens/social_tasks.dart';
import 'package:smart_to_do_app/screens/work_tasks.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';

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

    return showDialog(
      context: contextxx!,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(0),
              child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: whichformofthis == true
                      ? AlertDialog(
                          scrollable: true,
                          title: const Text(
                            'ADD A TASK',
                            style: TextStyle(fontSize: 18, color: Colors.black),
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
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                      autofocus: true,
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.amberAccent),
                                      onPressed: () async {
                                        final DateTime? picked =
                                            await showDatePicker(
                                          context: context,
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
                                      child: const Text(
                                        'Select date',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Center(
                                        child: DropdownButton<String>(
                                          dropdownColor: const Color.fromARGB(
                                              255, 243, 244, 245),
                                          focusColor: Colors.amberAccent,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: values.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
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
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedtasktype,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(5),
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
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedtasktype = value!;
                                            });
                                          },
                                          underline: SizedBox(),
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
                              child: const Text('Reset',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255))),
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

                                          //---------------

                                          FirebaseService
                                                  .get_level_of_complete()
                                              .then((value) {
                                            context
                                                .read<TodotaskProvider>()
                                                .add_level_of_complete(
                                                    value: value);
                                          });
                                          //---------------

                                          ScaffoldMessenger.of(contextxx)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.purple,
                                            shape: StadiumBorder(),
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.all(5),
                                            content: Text("Added a Task"),
                                            elevation: 12,
                                          ));
                                          Navigator.of(context).pop();
                                        });

                                        //--------------------
                                        setState(() {
                                          FirebaseService
                                                  .get_level_of_complete()
                                              .then((value) {
                                            context
                                                .read<TodotaskProvider>()
                                                .add_level_of_complete(
                                                    value: value);
                                          });
                                        });
                                      } else {
                                        print(
                                            "Adding Error" + TaskId.toString());
                                      }
                                    });
                                    setState(() {
                                      HomeScreen obj = HomeScreen();
                                      //obj;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Container(
                                      width: 100,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: const Color.fromARGB(
                                            215, 27, 255, 107),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 5,
                                            bottom: 5),
                                        child: isLoading
                                            ? const SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Submit",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 14, 14, 14),
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
                        )
                      :
                      //-------------------------Update------------------------------
                      AlertDialog(
                          scrollable: true,
                          title: const Text(
                            'ADD A TASK',
                            style: TextStyle(fontSize: 18, color: Colors.black),
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
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                      autofocus: true,
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.amberAccent),
                                      onPressed: () async {
                                        final DateTime? picked =
                                            await showDatePicker(
                                          context: context,
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
                                      child: const Text(
                                        'Select date',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Center(
                                        child: DropdownButton<String>(
                                          dropdownColor: const Color.fromARGB(
                                              255, 243, 244, 245),
                                          focusColor: Colors.amberAccent,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: values.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
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
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedtasktype,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(5),
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
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedtasktype = value!;
                                            });
                                          },
                                          underline: SizedBox(),
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
                              child: const Text('Reset',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255))),
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
                                            .removeCurrentuser_personal_ToDOTask(
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

                                        FirebaseService
                                                .getCurrentUser_personal_todotasks()
                                            .then(
                                          (personal_todoIds) {
                                            context
                                                .read<TodotaskProvider>()
                                                .addcurrentuser_personalToDo_task_provider(
                                                    todotask:
                                                        personal_todoIds!);
                                          },
                                        );
                                      }
                                      setState(() {
                                        PersonalTasks obj = new PersonalTasks();
                                      });
                                    } else if (pagename == "Work") {
                                      if (selectedtasktype != "Work") {
                                        context
                                            .read<TodotaskProvider>()
                                            .removeCurrentuser_work_ToDOTask(
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

                                        FirebaseService
                                                .getCurrentUser_work_todotasks()
                                            .then(
                                          (work_todoIds) {
                                            context
                                                .read<TodotaskProvider>()
                                                .addcurrentuser_workToDo_task_provider(
                                                    todotask: work_todoIds!);
                                          },
                                        );
                                      }

                                      setState(() {
                                        WorkTasks obj = new WorkTasks();
                                      });
                                    } else if (pagename == "Health") {
                                      if (selectedtasktype != "Health") {
                                        context
                                            .read<TodotaskProvider>()
                                            .removeCurrentuser_health_ToDOTask(
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

                                        FirebaseService
                                                .getCurrentUser_health_todotasks()
                                            .then(
                                          (health_todoIds) {
                                            context
                                                .read<TodotaskProvider>()
                                                .addcurrentuser_healthToDo_task_provider(
                                                    todotask: health_todoIds!);
                                          },
                                        );
                                      }

                                      setState(() {
                                        HealthTasks obj = new HealthTasks();
                                      });
                                    } else if (pagename == "Social") {
                                      if (selectedtasktype != "Social") {
                                        context
                                            .read<TodotaskProvider>()
                                            .removeCurrentuser_social_ToDOTask(
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

                                        FirebaseService
                                                .getCurrentUser_social_todotasks()
                                            .then(
                                          (social_todoIds) {
                                            context
                                                .read<TodotaskProvider>()
                                                .addcurrentuser_socialToDo_task_provider(
                                                    todotask: social_todoIds!);
                                          },
                                        );
                                      }
                                      setState(() {
                                        SocialTasks obj = new SocialTasks();
                                      });
                                    }

                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(contextxx)
                                        .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.deepPurple,
                                      shape: StadiumBorder(),
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(20),
                                      content: Text(
                                        "Update a Task",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      elevation: 12,
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Container(
                                      width: 100,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: const Color.fromARGB(
                                            215, 27, 255, 107),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 5,
                                            bottom: 5),
                                        child: isLoading
                                            ? const SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              )
                                            : const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Submit",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 14, 14, 14),
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
                        )
                  //-------------------------Update------------------------------
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
              labelStyle: const TextStyle(fontSize: 13),
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
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
