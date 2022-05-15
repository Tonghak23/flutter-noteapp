import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_noteapp/auth/login_screen.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Signin method with google
  final _formKey = GlobalKey<FormState>();
  var _firstname;
  var _lastname;
  var _email = '';
  var _password = '';


  var _firstnameController = TextEditingController();
  var _lastnameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  @override
  void dispose() {
    super.dispose();
    // _firstnameController.dispose();
    // _lastnameController.dispose();
    // _emailController.dispose();
    // _passwordController.dispose();
  }

  registration() async {
    if(_password != null) {
      // print("_lastnameController_lastnameController ${_lastnameController.text}");
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.toLowerCase().trim(),
            password: _password.trim());
        final User ? user = _auth.currentUser;
        final _uid = user!.uid;
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'firstname': _firstnameController.text,
          'lastname': _lastnameController.text,
          'email': _email,
          'joinedat': formatted,
          'created' : Timestamp.now(),
        });
        print("Username : ${_firstname} ${_lastname}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text("Success, You are registred in.",style: TextStyle(fontSize: 14.0,color: Colors.white,fontFamily: "Ubuntu-Medium"),),
        ),);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),),);
      }on FirebaseAuthException catch(error) {
        if(error.code == 'weak-password') {
          print('password is too weak');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[400],
              content: Text("password is too weak",style: TextStyle(fontSize: 14,fontFamily:  "Ubuntu-Medium",color: Colors.white),
              ),
            ),
          );
        }
        else if(error.code=='email-already-in-use') {
          // print('This email is already in use!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[400],
              content: Text("This email already in use.",style: TextStyle(fontSize: 14,fontFamily:  "Ubuntu-Medium",color: Colors.white),
              ),
            ),
          );
        }
      }
    }
    else {
      print('Password and Confirm password does not match');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent[400],
          content: Text("Password and Confirm password does not match",style: TextStyle(fontSize: 14,fontFamily:  "Ubuntu-Medium",color: Colors.white),
          ),
        ),
      );
    }
  }



  bool _isVisible = false;
  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.network("https://trafficneo.cc/wp-content/uploads/2020/02/ghff.png", fit: BoxFit.contain, height: 200,),),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(fontSize: 16.0),
                      focusedBorder:OutlineInputBorder(borderSide: const BorderSide(color: Colors.blueAccent,), borderRadius: BorderRadius.circular(20.0),),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
                      errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15.0),
                    ),
                    controller: _firstnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your firstname.';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(fontSize: 16.0),
                      focusedBorder:OutlineInputBorder(borderSide: const BorderSide(color: Colors.blueAccent,), borderRadius: BorderRadius.circular(20.0),),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
                      errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15.0),
                    ),
                    controller: _lastnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your lastname.';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 16.0, fontFamily: "Ubuntu-Medium"),
                      focusedBorder:OutlineInputBorder(borderSide: const BorderSide(color: Colors.blueAccent,), borderRadius: BorderRadius.circular(20.0),),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
                      errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15.0),
                    ),
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      } else if(!value.contains('@')) {
                        return 'Please enter correct email';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: _isVisible ? false : true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 16.0, fontFamily: "Ubuntu-Medium"),
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent,),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => updateStatus(),
                        icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15.0),
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          color:  Colors.indigo[500],
                          padding: EdgeInsets.all(16),
                          child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            if(_formKey.currentState!.validate()) {
                              setState(() {
                                _email = _emailController.text;
                                _password=_passwordController.text;
                                // _confirmPassword=_confirmPasswordController.text;
                              });
                              registration();
                            }
                          },
                        ),
                      ),
                      Container(
                        child: TextButton(
                            onPressed: () {setState(() {Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, a, b) => LoginScreen(),transitionDuration: Duration(seconds: 0)),);});},
                            child: Text('Already have an account? back to login.', style: TextStyle(fontSize: 15, color:  Colors.indigo[500],))
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
