import 'dart:convert';

import 'package:ecommerce/service/database.dart';
import 'package:ecommerce/service/shared_pref.dart';
import 'package:ecommerce/widget/app_constant.dart';
import 'package:ecommerce/widget/widget_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? wallet, id;
  int? add;
  TextEditingController amountcontroller = TextEditingController();

  getthesharedpref() async {
    wallet = await SharedPrefHelper().getUserWallet();
    id = await SharedPrefHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wallet == null
          ? const CircularProgressIndicator()
          : Container(
              margin: const EdgeInsets.only(top: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 2.0,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Center(
                        child: Text(
                          "Wallet",
                          style: AppWidget.headlineTextFeildStyle(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(color: Color(0xfff2f2f2)),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/wallet.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 40.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Wallet",
                              style: AppWidget.semiBoldTextFeildStyle(),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              "\$" + wallet!,
                              style: AppWidget.boldTextFeildStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Add Money",
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          makePayment('100');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffe9e2e2),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "\$" "100",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          makePayment('500');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffe9e2e2),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "\$" "500",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          makePayment('1000');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffe9e2e2),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "\$" "1000",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          makePayment('2000');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffe9e2e2),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "\$" "2000",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      openEdit();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xff008080),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Adnan'))
          .then((value) {});

      displayPaymentSheet(amount);
    } catch (e, s) {
      // ignore: avoid_print
      print('exception: $e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        add = int.parse(wallet!) + int.parse(amount);
        await SharedPrefHelper().saveUserWallet(add.toString());
        await DatabaseMethods().updateUserWallet(id!, add.toString());
        showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull")
                        ],
                      ),
                    ],
                  ),
                ));
        await getthesharedpref();
        paymentIntent = null;
        // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
      }).onError((error, StackTrace) {
        // ignore: avoid_print
        print('Error is:--> $error $StackTrace');
      });
    } on StripeException catch (e) {
      // ignore: avoid_print
      print('Error is:--> $e');
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled"),
              ));
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);

    return calculatedAmount.toString();
  }

  Future openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.cancel),
                      ),
                      const SizedBox(
                        width: 60.0,
                      ),
                      const Center(
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                              color: Color(0xff008080),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text("Amount"),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: amountcontroller,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'enter amount'),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        makePayment(amountcontroller.text);
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: const Color(0xff008080),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child:Text(
                            'Pay',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
}
