import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_noteapp/auth/forgot_password.dart';
import 'package:flutter_noteapp/auth/register_screen.dart';
import 'package:flutter_noteapp/pages/home.dart';
import 'package:flutter_noteapp/pages/navigate_items.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String loginImg = "https://png.pngtree.com/png-vector/20190614/ourmid/pngtree-profileabilitiesbusinessemployeejobmanresumeskills-png-image_1353142.jpg";
  final _formkey = GlobalKey<FormState>();
  var _email ="";
  var _password="";
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  userLogin() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.toLowerCase().trim(),
          password: _password.trim());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>NavigateItem()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Success, You are logged in.",style: TextStyle(fontSize: 14.0,color: Colors.white,fontFamily: "OpenSans Medium"),),
      ),);

    }on FirebaseAuthException catch(error){
      if(error.code == 'user-not-found') {
        // print("user not found for this email");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("No registered for this email",style: TextStyle(fontSize: 14.0,color: Colors.white,fontFamily: "OpenSans Medium"),),
          ),);
      }else if(error.code == 'wrong-password') {
        // print("Wrong password, Try again!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Wrong password, Try again!",style: TextStyle(fontSize: 14.0,color: Colors.white,fontFamily: "OpenSans Medium"),),
          ),);
      }
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
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0,horizontal: 20.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(10),
                  child: Container(height: 250, child: Image.network(loginImg,fit: BoxFit.contain,height: 200,)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 16.0,fontFamily: "OpenSans Medium"),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo,),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorStyle: TextStyle(color: Colors.red,fontSize: 15.0),
                    ),
                    controller: _emailController,
                    validator:(value){
                      if(value==null || value.isEmpty) {
                        return 'Please enter email';
                      }else if(!value.contains('@')) {
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
                      suffixIcon: IconButton(
                        onPressed: () => updateStatus(),
                        icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
                      ),
                      labelStyle: TextStyle(fontSize: 16.0,fontFamily: "OpenSans Medium"),
                      focusedBorder:OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.indigo,),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorStyle: TextStyle(color: Colors.redAccent,fontSize: 15.0),
                    ),
                    controller: _passwordController,
                    validator:(value){
                      if(value==null || value.isEmpty) {
                        return "Please enter password";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: FlatButton(
                          color:  Colors.indigo[500],
                          padding: EdgeInsets.all(16),
                          child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: "OpenSans Medium"),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16),),),
                          onPressed: () {
                            setState(() {
                              _email = _emailController.text;
                              _password = _passwordController.text;
                            });
                            userLogin();
                          },
                        ),
                      ),
                      TextButton(onPressed: (){
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPass(),),);
                        });
                      },
                          child: Text('Forgot password?',style: TextStyle(fontSize: 15,color: Colors.red,fontFamily: "OpenSans Medium"))),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",style: TextStyle(color: Colors.indigo[600],fontFamily: "OpenSans Medium"),),
                      TextButton(onPressed: (){
                        setState(() {
                          Navigator.pushAndRemoveUntil(context,
                              PageRouteBuilder(pageBuilder: (context,a,b) => RegisterScreen(),
                                  transitionDuration: Duration(seconds: 0)
                              ), (route) => false);
                        });
                      },
                        child: Text("Register",style: TextStyle(color: Colors.indigo[600]),),),
                    ],
                  ),
                ),
                // Text("Or Login with",textAlign: TextAlign.center),
                // SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
