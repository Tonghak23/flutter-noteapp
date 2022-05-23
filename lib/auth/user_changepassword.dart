import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_noteapp/auth/login_screen.dart';

class UserChangePass extends StatefulWidget {
  @override
  _UserChangePassState createState() => _UserChangePassState();
}

class _UserChangePassState extends State<UserChangePass> {

  final _formkey = GlobalKey<FormState>();
  var newPasswrod = "";
  final newPasswordController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  String Img = "https://cdn-icons-png.flaticon.com/512/6537/6537690.png";
  //Function change password
  changePassword() async {
    try {
      await currentUser!.updatePassword(newPasswrod);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Success, Your password has been changed.",style: TextStyle(fontSize: 14.0,color: Colors.white,fontFamily: "Ubuntu-Medium"),),
      ),);
    }catch(error) {

    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    super.dispose();
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
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Form(
      key: _formkey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 20),
        child: ListView(
          children: [
            SizedBox(height: 100,),
            Padding(padding: EdgeInsets.all(10),
              child: Container(
                height: 250,
                child: Image.network(Img,fit: BoxFit.contain,height: 200,)),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: TextFormField(
                autofocus: false,
                obscureText: _isVisible ? false : true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    onPressed: () => updateStatus(),
                    icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
                  ),
                  labelStyle: TextStyle(fontSize: 16.0,fontFamily: "OpenSans Medium"),
                      focusedBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo,),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  errorStyle: TextStyle(color: Colors.redAccent,fontSize: 15.0),
                ),
                controller: newPasswordController,
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
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      color:  Colors.indigo[500],
                      padding: EdgeInsets.all(16),
                      child: Text("Change password", style: TextStyle(color: Colors.white, fontSize: 16),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16),),),
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            newPasswrod = newPasswordController.text;
                          });
                          changePassword();
                        }
                      }
                    ),
                  ),
                     Container(
                        child: TextButton(
                            onPressed: () {setState(() {Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, a, b) => LoginScreen(),transitionDuration: Duration(seconds: 0)),);});},
                            child: Text('Back to login.', style: TextStyle(fontSize: 15, color:  Colors.indigo[500],fontFamily: "OpenSans Medium"))
                        ),
                      ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
