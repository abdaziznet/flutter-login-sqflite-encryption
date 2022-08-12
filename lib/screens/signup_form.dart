import 'package:flutter/material.dart';
import 'package:flutter_login_signup_sqflite_app/Utils/helper.dart';
import 'package:flutter_login_signup_sqflite_app/data/db_helper.dart';
import 'package:flutter_login_signup_sqflite_app/model/user_model.dart';
import 'package:flutter_login_signup_sqflite_app/screens/login_form.dart';
import 'package:flutter_login_signup_sqflite_app/widget/generate_text_form_field_widget.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_login_signup_sqflite_app/Utils/encryption.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formKey = new GlobalKey<FormState>();
  final txtUserName = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();
  final txtEmail = TextEditingController();

  var dbHelper;
  var encryptedPwd;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Signup'),
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
                          image: AssetImage(
                              'assets/images/business-3d-recruiter-found-an-employee.png'),
                          fit: BoxFit.cover,
                          height: 230,
                        ),
                        SizedBox(height: 30),
                        GenTextFormField(
                            controller: txtUserName,
                            hintName: "User Name",
                            inputType: TextInputType.name,
                            icon: Icons.person),
                        SizedBox(height: 10),
                        GenTextFormField(
                            controller: txtEmail,
                            inputType: TextInputType.emailAddress,
                            hintName: "Email",
                            icon: Icons.email),
                        SizedBox(height: 10),
                        GenTextFormField(
                            controller: txtPassword,
                            obscureText: true,
                            hintName: "Password",
                            icon: Icons.lock),
                        SizedBox(height: 10),
                        GenTextFormField(
                            controller: txtConfirmPassword,
                            obscureText: true,
                            hintName: "Confirm Password",
                            icon: Icons.lock),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(30),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: FlatButton(
                            onPressed: () {
                              signUp();
                            },
                            color: Colors.green,
                            child: Text(
                              "Signup",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
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
                                Text("Does you have account?"),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => LoginForm()),
                                        (Route<dynamic> route) => false);
                                  },
                                  child: Text(
                                    "Sign In",
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
        ));
  }

  signUp() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      if (txtPassword.text.toLowerCase() !=
          txtConfirmPassword.text.toLowerCase()) {
        alertDialog(context, "Password not match");
      } else {
        formKey.currentState!.save();

        try {
          encryptedPwd = Encryption.encryptFernet(txtPassword.text);
        } catch (e) {
          print(e.toString());
          alertDialog(context, "error: save failed");
          return;
        }

        UserModel user = UserModel(
            UserName: txtUserName.text,
            Email: txtEmail.text,
            Password: encryptedPwd is encrypt.Encrypted
                ? encryptedPwd.base64
                : txtPassword.text);
        await dbHelper.saveUser(user).then((userData) {
          alertDialog(context, "Successfully Signup");
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginForm()));
        }).catchError((e) {
          //print(e.toString());
          alertDialog(context, "error: save failed");
        });
      }
    }
  }

  clear() {
    txtUserName.clear();
    txtEmail.clear();
    txtPassword.clear();
    txtConfirmPassword.clear();
  }
}
