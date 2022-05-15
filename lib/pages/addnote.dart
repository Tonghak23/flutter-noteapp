import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_noteapp/pages/home.dart';
import 'package:flutter_noteapp/pages/navigate_items.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late String title;
  late String description;

  void addNote() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notes");
    var data = {
      'title': title,
      'description': description,
      'created': DateTime.now(),
    };

    await ref.add(data);
    Navigator.push(context, MaterialPageRoute(builder: (context) => NavigateItem()));
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.indigo[600],
        content: Text("Success, Note created.",style: TextStyle(fontSize: 14.0,color: Colors.white,fontFamily: "Ubuntu-Medium"),),
      ),);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add new Note"),
          backgroundColor: Colors.indigo[500],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(
              12.0,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 12.0,
                ),
                //
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Title",
                        ),
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        onChanged: (_val) {
                          title = _val;
                        },
                      ),
                      //
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: "Note Description",
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                          onChanged: (_val) {
                            description = _val;
                          },
                          maxLines: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(
            12.0,
          ),
          child: FlatButton(
            color: Colors.indigo[500],
            padding: EdgeInsets.all(16),
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            onPressed: addNote,
          ),
        ),
      ),
    );
  }
}
