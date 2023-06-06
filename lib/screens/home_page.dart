import 'package:firebase_notes/helper/fireStore_helper.dart';
import 'package:firebase_notes/helper/notes_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List data = [];
  Map<Object, Object> editValue = {};

  String? title;
  String? subTitle;

  final GlobalKey<FormState> notesKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Notes",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: "Poppins",
          ),
        ),
        backgroundColor: const Color(0xff03111C),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text(
                        "Are You Sure Logout??",
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xff03111C),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff03111C),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuthHelper.firebaseAuthHelper
                                .logOut();

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('welcome', false);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                'welcomePage', (route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff03111C)),
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    );
                  });
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Center(
          child: StreamBuilder(
        stream: FireStoreHelper.fireStoreHelper.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error :- ${snapshot.error} "),
            );
          } else if (snapshot.hasData) {
            data = snapshot.data!.docs;

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, i) {
                print("=======================================");

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.of(context)
                              .pushNamed('editNotePage', arguments: data[i]);
                        });
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  "Are You Sure?",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff03111C),
                                  ),
                                ),
                                content: Text(
                                  "You Are About Delete This Note.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "No",
                                      style: TextStyle(
                                          color: Color(0xff03111C),
                                          fontSize: 15),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      FireStoreHelper.fireStoreHelper
                                          .removeNotes(id: data[i]['id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff03111C),
                                    ),
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                ],
                                backgroundColor: Colors.white,
                              );
                            });
                      },
                      child: Ink(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade500,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[i]['title'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                              Text(
                                data[i]['subtitle'],
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data[i]['date'],
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                  Text(
                                    data[i]['time'],
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
          // Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Image.network(
          //             "https://cdn-icons-png.flaticon.com/512/3131/3131636.png",
          //             height: 150,
          //           ),
          //           const SizedBox(height: 20),
          //           const Text(
          //             "Create Your first Note !!",
          //             style: TextStyle(
          //               fontSize: 20,
          //               color: Colors.white,
          //               fontFamily: "Poppins",
          //             ),
          //           ),
          //         ],
          //       )
          ),
      backgroundColor: const Color(0xff03111C),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.of(context).pushNamed('addNotePage');
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
