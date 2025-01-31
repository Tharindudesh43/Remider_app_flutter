import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:smart_to_do_app/models/tototask_model.dart';
import 'package:smart_to_do_app/providers/todotask_provider.dart';
import 'package:smart_to_do_app/services/firebase_service.dart';
import 'package:smart_to_do_app/widgets/profile_card.dart';
import 'package:smart_to_do_app/widgets/to_do_form_card.dart';
import 'package:smart_to_do_app/widgets/to_do_list_card.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
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
                          String username = hotels.username;
                          return username.isEmpty
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
                InkWell(
                  onTap: () {
                    ProfileCard obj = ProfileCard();
                    obj.DialogCard(contextxx: context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
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
                const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 208,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/taskcomplete.jpg'),
                        colorFilter: ColorFilter.mode(
                            const Color.fromARGB(255, 221, 187, 219)
                                .withOpacity(0.3),
                            BlendMode.darken),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Hurrah!",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      const Color.fromARGB(255, 104, 18, 179)),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              "You are almost there",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      const Color.fromARGB(255, 104, 18, 179)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        const Row(
                          children: [
                            Text(
                              "20 out of 25 tasks are completed",
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
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: 0.5,
                                      backgroundColor: Colors.pink.shade100,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.pink),
                                    ),
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<TodotaskProvider>(
              builder: (context, todotasks, child) {
                context.read<TodotaskProvider>().getOnlyCurrectusersToDoTasks();
                List<ToDoTask?> allcurrentUserToDoTasks =
                    todotasks.currentuserToDoTaskList!;
                return allcurrentUserToDoTasks.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: allcurrentUserToDoTasks.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return ToDoListCard(
                            ToDoTaskData: allcurrentUserToDoTasks[index]!,
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: _isVisible ? 1.0 : 0.0,
        child: FloatingActionButton(
          hoverColor: Colors.white,
          backgroundColor: Colors.amberAccent,
          onPressed: () {
            ToDoFormCard obj = ToDoFormCard();
            obj.DialogCard(
                docid: "",
                whichform: true,
                contextxx: context,
                descriptionController: "",
                titleController: "",
                datepassed: Timestamp.now(),
                prioritypassed: 'Not Priority');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
