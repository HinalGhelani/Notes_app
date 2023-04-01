import 'package:firebase_notes/helper/fireStore_helper.dart';
import 'package:firebase_notes/helper/notes_helper.dart';
import 'package:flutter/material.dart';

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
              await FirebaseAuthHelper.firebaseAuthHelper.logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('welcomePage', (route) => false);
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Center(
        child:
            // (data.isEmpty)
            //     ? Column(
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
            //     :
            StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper.getNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error :- ${snapshot.error} "),
              );
            } else if (snapshot.hasData) {
              data = snapshot.data!.docs;

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i) {
                  print("==================================");
                  print(data[i]['title']);
                  print("==================================");

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: Container(
                                      height: 130,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff03111C),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Map<Object, Object> editValue = {
                                                'title': data[i]['title'],
                                                'subtitle': data[i]['subtitle']
                                              };
                                              Navigator.of(context)
                                                  .pushNamed('editNotePage',arguments: editValue);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(10),
                                              margin:
                                                  const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                              child: const Text(
                                                "Edit",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(10),
                                              margin:
                                                  const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
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
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  data[i]['subtitle'],
                                  style: const TextStyle(color: Colors.white),
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
        ),
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
