import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login_signup_sqflite_app/Utils/encryption.dart';
import 'package:flutter_login_signup_sqflite_app/Utils/helper.dart';
import 'package:flutter_login_signup_sqflite_app/Utils/logger.dart';
import 'package:flutter_login_signup_sqflite_app/data/db_helper.dart';
import 'package:flutter_login_signup_sqflite_app/screens/home_form.dart';
import 'package:flutter_login_signup_sqflite_app/screens/signup_form.dart';
import 'package:flutter_login_signup_sqflite_app/widget/generate_text_form_field_widget.dart';
import 'package:logger/logger.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = new GlobalKey<FormState>();
  final txtUserName = TextEditingController();
  final txtPassword = TextEditingController();
  final log = logger(LoginForm);

  var dbHelper;
  String decryptedPwd = "";

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Image(
                        image: AssetImage('assets/images/3d-flame-258.png'),
                        fit: BoxFit.cover,
                        height: 230,
                      ),
                      SizedBox(height: 30),
                      GenTextFormField(
                          controller: txtUserName,
                          hintName: "User Name",
                          icon: Icons.person),
                      SizedBox(height: 10),
                      GenTextFormField(
                          controller: txtPassword,
                          hintName: "Password",
                          icon: Icons.lock,
                          obscureText: true),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(30),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: FlatButton(
                          onPressed: () {
                            login();
                          },
                          color: Colors.green,
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Does not have account?"),
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => SignUpForm()));
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ]),
                      )
                    ]),
              ),
            )),
      ),
    );
  }

  login() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      await dbHelper.getUserByUserName(txtUserName.text).then((userData) {
        if (userData != null) {
          try {
            String pwd = userData.Password;
            decryptedPwd =
                Encryption.decryptFernet(encrypt.Key.fromBase64(pwd));
          } catch (e) {
            log.e(e.toString());
            log.e("Error in decrypting password");
            alertDialog(context, "error: login failed");
            return;
          }
          if (decryptedPwd.toLowerCase() == txtPassword.text.toLowerCase()) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeForm()),
                (Route<dynamic> route) => false);
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Login Failed"),
                    content: Text("Please check your user name and password"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Login Failed"),
                  content: Text("Please check your user name and password"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      }).catchError((e) {
        log.e(e.toString());
        alertDialog(context, "error: login failed");
      });
    }
  }

  clear() {
    txtUserName.clear();
    txtPassword.clear();
  }
}
