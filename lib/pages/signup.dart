import 'package:ecommerce/pages/bottomnav.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/service/database.dart';
import 'package:ecommerce/service/shared_pref.dart';
import 'package:ecommerce/widget/widget_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", name = "", password = "";

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller =  TextEditingController();
  TextEditingController passwordcontroller =  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
    // ignore: unnecessary_null_comparison
    if (password != null) {
      try {
        // ignore: unused_local_variable
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          (const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            ),
          )),
        );
        String Id = randomAlphaNumeric(10);
        Map<String,dynamic> addUserInfo = {
          "Name":  namecontroller.text,
          "Email": emailcontroller.text,
          "Wallet": "0",
          "Id": Id,
        };
        await DatabaseMethods().addUserDetail(addUserInfo, Id);
        await SharedPrefHelper().saveUserName(namecontroller.text);
        await SharedPrefHelper().saveUserEmail(emailcontroller.text);
        await SharedPrefHelper().saveUserWallet('0');
        await SharedPrefHelper().saveUserId(Id);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNav()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            (const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "password provided is too weak",
                style: TextStyle(fontSize: 18),
              ),
            )),
          );
        } 
        else if (e.code == "email-already-in-use") {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            (const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account already exists",
                style: TextStyle(fontSize: 18.0),
              ),
            )),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
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
                      height: MediaQuery.of(context).size.height / 1.75,
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
                              "Sign Up",
                              style: AppWidget.headlineTextFeildStyle(),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: namecontroller,
                              validator: (value){
                                if (value==null||value.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Name',
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon:
                                      const Icon(Icons.person_2_outlined)),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: emailcontroller,
                              validator: (value){
                                if (value==null||value.isEmpty) {
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
                              validator: (value){
                                if (value==null||value.isEmpty) {
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
                              height: 40.0,
                            ),
                            GestureDetector(
                              onTap: () async{
                                if(_formKey.currentState!.validate()){
                                  setState(() {
                                    email = emailcontroller.text;
                                    name = namecontroller.text;
                                    password = passwordcontroller.text;
                                  });
                                }
                                registration();
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
                                      "Sign Up",
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
                          MaterialPageRoute(builder: (context) => const Login()));
                    },
                    child: Text(
                      "Already have an account? Login",
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
