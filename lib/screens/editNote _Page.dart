import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/fireStore_helper.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage({Key? key}) : super(key: key);

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  String? title;
  String? subtitle;

  Map<Object, Object> newData = {};

  final GlobalKey<FormState> editKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot data =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (editKey.currentState!.validate()) {
                editKey.currentState!.save();

                await FireStoreHelper.fireStoreHelper.editNotes(
                  id: data['id'].toString(),
                  data: newData,
                );
                print("==================================");
                print(data);
                print("==================================");

                Navigator.of(context).pop();

                // setState(() {
                //   title = null;
                //   subtitle = null;
                // });
              }
            },
            icon: const Icon(
              Icons.done,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: const Color(0xff03111C),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xff03111C),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: editKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                onChanged: (val) {
                  newData['title'] = val;
                },
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
                initialValue: data['title'],
                textInputAction: TextInputAction.next,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(
                    fontSize: 30,
                    color: Color(
                      0xff8F9398,
                    ),
                  ),
                ),
              ),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "please enter notes";
                  }
                },
                onChanged: (val) {
                  newData['subtitle'] = val;
                },
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                initialValue: data['subtitle'],
                cursorColor: Colors.white,
                maxLines: null,
                // expands: true,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  hintText: "Note",
                  hintStyle: TextStyle(
                    fontSize: 25,
                    color: Color(
                      0xff8F9398,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
