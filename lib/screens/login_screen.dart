import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String password, email;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        color: Colors.black,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow)
        ),
        inAsyncCall: isLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "logo",
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: inputTextStyle1,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: inputDecorationStyle1.copyWith(
                    hintText: "Enter your email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                style: inputTextStyle1,
                onChanged: (value) {
                  password = value;
                },
                decoration: inputDecorationStyle1.copyWith(
                    hintText: "Enter your password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                color: Colors.blueAccent,
                onPressed: () {
                  onLoginProcess();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLoading(bool isShow) {
    setState(() {
      isLoading = isShow;
    });
  }

  void onLoginProcess() async {
    showLoading(true);

    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        Navigator.pushNamed(context, ChatScreen.id);
      } else {
        showLoginFailed();
      }
    } catch (e) {
      showLoginFailed(message : "$e");
    }

    showLoading(false);
  }

  void showLoginFailed({String message = "Email and password not match!"}) {
    showAlertDialog(context, message: message);
  }
}
