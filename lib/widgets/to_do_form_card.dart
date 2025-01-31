import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';

class ToDoFormCard {
  Future<dynamic> DialogCard(
      {BuildContext? contextxx,
      // required String tasktypepassed,
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
    //String selectedtasktype = tasktypepassed;

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
                  height: MediaQuery.of(context).size.height / 1.6,
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
                                  FieldController: titleFieldController,
                                  textfieldvalue: "Title",
                                ),
                                CardTextField(
                                  FieldController: descriptionFieldController,
                                  textfieldvalue: "Description",
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
                                    setState(() {
                                      isLoading = true;
                                      FirebaseService.addtodotask(
                                              title: titleFieldController.text
                                                  .trim(),
                                              description:
                                                  descriptionFieldController
                                                      .text
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
                                            print(
                                                "Can't get all tasks from firebase");
                                            context
                                                .read<TodotaskProvider>()
                                                .addalltodotasks_Provider(
                                                    todotasks: ToDoTaskData);
                                            context
                                                .read<TodotaskProvider>()
                                                .updateCurrentuserToDOTasks(
                                                    taskId: TaskId);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(contextxx)
                                                .showSnackBar(const SnackBar(
                                              content: Text("Added a Task"),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              elevation: 12,
                                            ));
                                          });
                                        } else {
                                          print("Adding Error" +
                                              TaskId.toString());
                                        }
                                      });
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
                      //-------------------------xxx------------------------------
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
                                  FieldController: titleFieldController,
                                  textfieldvalue: "Title",
                                ),
                                CardTextField(
                                  FieldController: descriptionFieldController,
                                  textfieldvalue: "Description",
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
                                    print("Edit Form: $editdocid");
                                    print(
                                        "title: ${titleFieldController.text}");
                                    print("date: ${selectedDate}");
                                    setState(() {
                                      FirebaseService.updatecurrentusertodotask(
                                              date: selectedDate!,
                                              description:
                                                  descriptionFieldController
                                                      .text
                                                      .trim(),
                                              title: titleFieldController.text
                                                  .trim(),
                                              priority: selectedpriority,
                                              editdocid: editdocid)
                                          .then((ToDoTaskData) {
                                        context
                                            .read<TodotaskProvider>()
                                            .addalltodotasks_Provider(
                                                todotasks: ToDoTaskData!);
                                        context
                                            .read<TodotaskProvider>()
                                            .getOnlyCurrectusersToDoTasks();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(contextxx)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Updated a Task"),
                                          behavior: SnackBarBehavior.floating,
                                          elevation: 12,
                                        ));
                                      });
                                    });
                                    // setState(() {
                                    //   isLoading = true;
                                    //   FirebaseService.addtodotask(
                                    //           title: titleFieldController.text.trim(),
                                    //           description: descriptionFieldController
                                    //               .text
                                    //               .trim(),
                                    //           priority: selectedpriority.toString(),
                                    //           date: selectedDate)
                                    //       .then((TaskId) {
                                    //     if (TaskId != null) {
                                    //       print("Task ID: {$TaskId}");
                                    //       FirebaseService.addtodotasktouser(
                                    //           docid: TaskId);
                                    //       FirebaseService.gettodotasks()
                                    //           .then((ToDoTaskData) {
                                    //         print("Can't get all tasks from firebase");
                                    //         context
                                    //             .read<TodotaskProvider>()
                                    //             .addalltodotasks_Provider(
                                    //                 todotasks: ToDoTaskData);
                                    //         context
                                    //             .read<TodotaskProvider>()
                                    //             .updateCurrentuserToDOTasks(
                                    //                 taskId: TaskId);
                                    //         Navigator.of(context).pop();
                                    //         ScaffoldMessenger.of(contextxx)
                                    //             .showSnackBar(const SnackBar(
                                    //           content: Text("Added a Task"),
                                    //           behavior: SnackBarBehavior.floating,
                                    //           elevation: 12,
                                    //         ));
                                    //       });
                                    //     } else {
                                    //       print("Adding Error" + TaskId.toString());
                                    //     }
                                    //   });
                                    // });
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
                  //-------------------------xxx------------------------------
                  ),
            );
          },
        );
      },
    );
  }
}

class CardTextField extends StatelessWidget {
  const CardTextField({
    super.key,
    required this.FieldController,
    required this.textfieldvalue,
  });

  final TextEditingController FieldController;
  final String textfieldvalue;

  @override
  Widget build(BuildContext context) {
    return textfieldvalue == "Description"
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: double.maxFinite,
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 7,
                controller: FieldController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        Color.fromARGB(255, 130, 130, 127).withOpacity(0.1),
                    label: Text(
                      textfieldvalue,
                      style: const TextStyle(fontSize: 13),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2))),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: FieldController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      const Color.fromARGB(255, 130, 130, 127).withOpacity(0.1),
                  label: Text(
                    textfieldvalue,
                    style: const TextStyle(fontSize: 13),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2))),
            ),
          );
  }
}
