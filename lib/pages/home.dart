
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_noteapp/pages/viewnote.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      // floatingActionButton: _buildFloatButton(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Note App",style: TextStyle(fontFamily: "OpenSans Medium"),),
      backgroundColor: Colors.indigo[500],
    );
  }

  _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: ref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map data = snapshot.data!.docs[index].data() as Map;
                  DateTime mydateTime = data['created'].toDate();
                  String formattedTime = DateFormat.yMMMd().add_jm().format(mydateTime);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => ViewNote(
                            data,
                            formattedTime,
                            snapshot.data!.docs[index].reference,
                          ),
                        ),
                      )
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(
                            "${data['title']}",
                            style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color:  Colors.indigo[500],
                                fontFamily: "OpenSans Medium"
                            ),
                          ),
                          Container(
                            child: Text(
                              "${data['description']}",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.indigo[500],
                                fontFamily: "OpenSans Medium"
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              formattedTime,
                              style:  TextStyle(
                                fontSize: 14.0,
                                color:  Colors.indigo[500],
                                fontFamily: "OpenSans Medium"
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  // _buildFloatButton(BuildContext context) {
  //   return FloatingActionButton(
  //     child: Icon(Icons.pending_actions),
  //     backgroundColor: Colors.indigo,
  //     onPressed: () {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => AddNote()));
  //     },
  //   );
  // }
}
