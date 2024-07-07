import 'package:ecommerce/pages/bottomnav.dart';
import 'package:ecommerce/pages/forgotpassword.dart';
import 'package:ecommerce/pages/signup.dart';
import 'package:ecommerce/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String email = "", password = "";
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNav()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            "No user Found for that Email",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          )),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            "Wrong password Provided By User",
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffff5c30), Color(0xffe74b1a)])),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: const Text(""),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Center(
                      child: Image.asset(
                    "images/logo.png",
                    width: MediaQuery.of(context).size.width / 1.5,
                    fit: BoxFit.cover,
                  )),
                  Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 10.0,
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Login",
                              style: AppWidget.headlineTextFeildStyle(),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: emailcontroller,
                              validator: (value) {
                                if(value==null||value.isEmpty){
                                  return 'Please enter a email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon: const Icon(Icons.email_outlined)),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: passwordcontroller,
                              validator: (value) {
                                if(value==null||value.isEmpty){
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon:
                                      const Icon(Icons.password_outlined)),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                              },
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "Forgot Password?",
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                if(_formKey.currentState!.validate()){
                                  setState(() {
                                    email = emailcontroller.text;
                                    password = passwordcontroller.text;
                                  });
                                }
                                userLogin();
                              },
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  width: 200,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffff5722),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Center(
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontFamily: 'Poppins1',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text(
                      "Dont't have a account? Sign Up",
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
