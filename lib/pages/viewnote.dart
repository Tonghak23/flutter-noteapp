import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_noteapp/pages/navigate_items.dart';

class ViewNote extends StatefulWidget {
  final Map data;
  final String time;
  final DocumentReference ref;

  const ViewNote(this.data, this.time, this.ref);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  late String title;
  late String des;

  bool edit = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    des = widget.data['description'];
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Form(
                  key: key,
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          edit = !edit;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration.collapsed(
                              hintText: "Title",
                            ),
                            style: TextStyle(
                              fontSize: 32.0,
                              fontFamily: "OpenSans Medium",
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[500],
                            ),
                            initialValue: widget.data['title'],
                            enabled: edit,
                            onChanged: (_val) {
                              title = _val;
                            },
                            validator: (_val) {
                              if (_val!.isEmpty) {
                                return "Can't be empty !";
                              } else {
                                return null;
                              }
                            },
                          ),
                          //
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 12.0,
                              bottom: 12.0,
                            ),
                            child: Text(
                              widget.time,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.indigo[500],
                              ),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration.collapsed(
                              hintText: "Note Description",
                            ),
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: "OpenSans Medium",
                              color: Colors.indigo[500],
                            ),
                            initialValue: widget.data['description'],
                            enabled: edit,
                            onChanged: (_val) {
                              des = _val;
                            },
                            maxLines: 20,
                            validator: (_val) {
                              if (_val!.isEmpty) {
                                return "Can't be empty !";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: edit
            ? Container(
                padding: const EdgeInsets.all(
                  12.0,
                ),
                child: FlatButton(
                  color: Colors.indigo[500],
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Update & Save",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  onPressed: save,
                ),
              )
            : null,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text("Delete Note"),
                content: Text("Are you sure you want to delete this note ?"),
                actions: [
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      widget.ref.delete();
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigateItem()));
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red[600],
                          content: const Text(
                            "Success, Note deleted.",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontFamily: "OpenSans Medium"),
                          ),
                        ),
                      );
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
            // widget.ref.delete();
            // Navigator.pop(context);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     backgroundColor: Colors.indigo[600],
            //     content: const Text(
            //       "Success, Note deleted.",
            //       style: TextStyle(
            //           fontSize: 14.0,
            //           color: Colors.white,
            //           fontFamily: "OpenSans Medium"),
            //     ),
            //   ),
            // );
          },
          child: Icon(Icons.delete),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return edit
        ? AppBar(
            title: const Text(
              "Update Note",
              style: TextStyle(fontFamily: "OpenSans Medium"),
            ),
            backgroundColor: Colors.indigo[500],
          )
        : AppBar(
            title: const Text(
              "View Note",
              style: TextStyle(fontFamily: "OpenSans Medium"),
            ),
            backgroundColor: Colors.indigo[500],
          );
  }

  void delete() async {
    await widget.ref.delete();
    Navigator.pop(context);
  }

  void save() async {
    if (key.currentState!.validate()) {
      await widget.ref.update(
        {'title': title, 'description': des},
      );
      Navigator.of(context).pop();
    }
  }
}
