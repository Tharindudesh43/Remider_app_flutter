import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:intl/intl.dart';
import 'package:smart_to_do_app/widgets/to_do_form_card.dart';

class ToDoListCardCompleted extends StatefulWidget {
  final ToDoTask ToDoTaskData;
  final Color themecolor;
  const ToDoListCardCompleted({
    super.key,
    required this.ToDoTaskData,
    required this.themecolor,
  });

  @override
  State<ToDoListCardCompleted> createState() => _ToDoListCardCompletedState();
}

class _ToDoListCardCompletedState extends State<ToDoListCardCompleted> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 300,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 230, 233, 231),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 80,
              decoration: BoxDecoration(
                color: widget.themecolor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ToDoTaskData.title!,
                    style: GoogleFonts.phudu(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.ToDoTaskData.description!,
                    style: GoogleFonts.archivo(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    key: widget.key,
                    children: [
                      Icon(Icons.access_time,
                          size: 14, color: Color.fromARGB(255, 0, 0, 0)),
                      SizedBox(width: 4),
                      Text(
                        DateFormat('yyyy-MM-dd').format(
                            (widget.ToDoTaskData.date as Timestamp).toDate())!,
                        style: TextStyle(
                            fontSize: 13,
                            color: widget.themecolor.withOpacity(0.5),
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.low_priority_rounded,
                          size: 14, color: Color.fromARGB(255, 0, 0, 0)),
                      SizedBox(width: 2),
                      Text(" ${widget.ToDoTaskData.priority.toString()!}",
                          style: TextStyle(
                              color: widget.ToDoTaskData.priority ==
                                      "Top Priority"
                                  ? Colors.red.withOpacity(0.5)
                                  : widget.ToDoTaskData.priority ==
                                          "Low Priority"
                                      ? Colors.lightBlueAccent.withOpacity(0.5)
                                      : Colors.green.withOpacity(0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                      SizedBox(width: 20),
                      SizedBox(width: 6),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                    autofocus: true,
                    onPressed: () {
                      FirebaseService.deleteCurrentUserToDoTask(
                          taskId: widget.ToDoTaskData.id!);
                      if (widget.ToDoTaskData.tasktype == "Personal") {
                        context
                            .read<TodotaskProvider>()
                            .remove_current_user_completed_personal_ToDoTasks(
                                taskid: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .update_after_reduce_todo_level_complete();
                        FirebaseService.reduce_level_of_complete();
                      } else if (widget.ToDoTaskData.tasktype == "Work") {
                        context
                            .read<TodotaskProvider>()
                            .remove_current_user_completed_work_ToDoTasks(
                                taskid: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .update_after_reduce_todo_level_complete();
                        FirebaseService.reduce_level_of_complete();
                      } else if (widget.ToDoTaskData.tasktype == "Health") {
                        context
                            .read<TodotaskProvider>()
                            .remove_current_user_completed_health_ToDoTasks(
                                taskid: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .update_after_reduce_todo_level_complete();
                        FirebaseService.reduce_level_of_complete();
                      } else if (widget.ToDoTaskData.tasktype == "Social") {
                        context
                            .read<TodotaskProvider>()
                            .remove_current_user_completed_social_ToDoTasks(
                                taskid: widget.ToDoTaskData.id!);
                        context
                            .read<TodotaskProvider>()
                            .update_after_reduce_todo_level_complete();
                        FirebaseService.reduce_level_of_complete();
                      }

                      Flushbar(
                        message: "Deleted a Completed Task",
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          size: 28.0,
                          color: Color.fromARGB(255, 217, 38, 241),
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
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //   backgroundColor: Colors.purple,
                      //   shape: StadiumBorder(),
                      //   behavior: SnackBarBehavior.floating,
                      //   margin: EdgeInsets.all(5),
                      //   content: Center(
                      //     child: Text(
                      //       "Deleted a Completed Task",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w700,
                      //           color: Color.fromARGB(255, 255, 255, 255)),
                      //     ),
                      //   ),
                      //   elevation: 20,
                      // ));
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.white,
                    ))),
          ],
        ),
      ),
    );
  }
}
