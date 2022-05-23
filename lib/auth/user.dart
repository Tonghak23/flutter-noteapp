import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_noteapp/auth/login_screen.dart';
import 'package:flutter_noteapp/auth/user_changepassword.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Get User data
  final user = FirebaseAuth.instance.currentUser!;

  //SignOut User
  Future<void> _signOut() async {
    await _auth.signOut();
  }

  String profile =
      "https://static.wixstatic.com/media/902040_30336145aa8b40d8b6e898e3e107f92c~mv2.png/v1/fill/w_300,h_302,al_c,q_85,usm_0.66_1.00_0.01/User%2005c.webp";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 300,
            child: DrawerHeader(
              child: Container(
                  height: 100, width: 100, child: Image.network(profile)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_outlined, color: Colors.blueGrey[900]),
            title: Text("Home",style:TextStyle(fontFamily: 'OpenSans Medium', fontSize: 16.0)),
            trailing: Icon(
              Icons.navigate_next_sharp,
              color: Colors.indigo[500],
            ),
            dense: true,
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined,
                color: Colors.blueGrey[900]),
            title: Text("${user.email!}",
                style:
                    TextStyle(fontFamily: 'OpenSans Medium', fontSize: 16.0)),
            trailing: Icon(
              Icons.navigate_next_sharp,
              color: Colors.indigo[500],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserChangePass()));
            },
            child: ListTile(
              leading: Icon(Icons.lock_rounded, color: Colors.blueGrey[900]),
              title: Text("Change password",
                  style:
                      TextStyle(fontFamily: 'OpenSans Medium', fontSize: 16.0)),
              trailing: Icon(
                Icons.navigate_next_sharp,
                color: Colors.indigo[500],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.blueGrey[900],
            ),
            title: Text("Setting",
                style:
                    TextStyle(fontFamily: 'OpenSans Medium', fontSize: 16.0)),
            trailing: Icon(
              Icons.navigate_next_sharp,
              color: Colors.indigo[500],
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text("Logout?"),
                content: Text("Are you sure you want to logout ?"),
                actions: [
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      _signOut();
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen()));
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.indigo[600],
                          content: const Text(
                            "Success, You have been logged out",
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
            },
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              title: Text("Logout",
                  style: TextStyle(
                      fontFamily: 'OpenSans Medium',
                      fontSize: 16.0,
                      color: Colors.redAccent)),
              trailing: Icon(
                Icons.navigate_next_sharp,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
