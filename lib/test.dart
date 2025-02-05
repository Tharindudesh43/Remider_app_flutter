import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: constraints.maxWidth,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
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
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDD",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 14, color: Color.fromARGB(255, 0, 0, 0)),
                          SizedBox(width: 4),
                          Text("12:30",
                              style: TextStyle(
                                  color: Colors.purple, fontSize: 15)),
                          SizedBox(width: 8),
                          Icon(Icons.low_priority_rounded,
                              size: 14, color: Color.fromARGB(255, 0, 0, 0)),
                          SizedBox(width: 2),
                          Text("Top Priority",
                              style: TextStyle(
                                  color: Colors.purple, fontSize: 15)),
                          SizedBox(width: 20),
                          Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  autofocus: true,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.white,
                                  ))),
                          SizedBox(width: 8),
                          Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  autofocus: true,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.edit_document,
                                    size: 20,
                                    color: Colors.white,
                                  ))),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 238, 5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        autofocus: true,
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_task,
                          size: 20,
                        ))),
              ],
            ),
          ),
        );
      },
    );
  }
}
