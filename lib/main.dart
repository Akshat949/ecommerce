// import 'package:ecommerce/pages/bottomnav.dart';
// import 'package:ecommerce/pages/login.dart';
// import 'package:ecommerce/pages/forgotpassword.dart';
import 'package:ecommerce/admin/admin.dart';
import 'package:ecommerce/admin/home_admin.dart';
import 'package:ecommerce/pages/bottomnav.dart';
import 'package:ecommerce/pages/onboard.dart';
import 'package:ecommerce/widget/app_constant.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:ecommerce/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishableKey;
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const BottomNav());
        // OnBoard()
        // AdminLogin()
        // HomeAdmin()
  }
}
