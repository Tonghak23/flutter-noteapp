import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_noteapp/auth/login_screen.dart';

class ForgotPass extends StatefulWidget {

  @override
  _ForgotPassState createState() => _ForgotPassState();
}
class _ForgotPassState extends State<ForgotPass> {
  String logo ="https://i.pinimg.com/originals/d1/54/66/d154660a6ae3104de2b0a314667a5ab6.png";
  var _email="";
  final _formkey=GlobalKey<FormState>();
  var _emailController = TextEditingController();
  resetPassWord() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Password reset email has been send",style: TextStyle(fontSize: 14.0,color: Colors.white,fontFamily: "Ubuntu-Medium"),),
      ),);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),),);
    }on FirebaseAuthException catch(error){
      if(error.code=="user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Email no registered",style: TextStyle(fontSize: 14.0,color: Colors.white,fontFamily: "Ubuntu-Medium"),),
        ),);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }
  _buildBody(BuildContext context) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60,horizontal: 20),
        child: ListView(
          children: [
            Padding(padding: EdgeInsets.all(10),
              child: Container(
                  height: 250,
                  child: Image.network(logo,fit: BoxFit.contain,height: 200,)
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                autofocus: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 16.0,fontFamily: "Ubuntu-Medium"),
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent,),
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
            // SizedBox(height: 5),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      color:  Colors.indigo[500],
                      padding: EdgeInsets.all(16),
                      child: Text("Verify new password", style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if(_formkey.currentState!.validate()) {
                          setState(() {
                             _email = _emailController.text;
                          });
                          resetPassWord();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, a, b) => LoginScreen(),transitionDuration: Duration(seconds: 0)),);
                    });
                  },
                  child: Text('back to login?', style: TextStyle(fontSize: 15, color: Colors.red, fontFamily: "Ubuntu-Medium"))),
            ),
          ],
        ),
      ),
    );
  }
}
