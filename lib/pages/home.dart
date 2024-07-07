import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/pages/details.dart';
import 'package:ecommerce/service/database.dart';
import 'package:ecommerce/widget/widget_support.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool iceCream = false, pizza = false, salad = false, burger = false;

  Stream? fooditemStream;

  ontheload() async {
    fooditemStream = await DatabaseMethods().getFoodItem("Pizza");
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allItemsVertically() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Details(detail: ds["Detail"], image: ds["Image"], name: ds["Name"], price: ds["Price"])));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10,bottom: 20.0),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    ds["Image"],
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        ds["Name"],
                                        style:
                                            AppWidget.semiBoldTextFeildStyle(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        "Honey goot cheese",
                                        style: AppWidget.lightTextFeildStyle(),
                                      ),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        "\$"+ds["Price"],
                                        style:
                                            AppWidget.semiBoldTextFeildStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : const CircularProgressIndicator();
        });
  }

  Widget allItems() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Details(detail: ds["Detail"], image: ds["Image"], name: ds["Name"], price: ds["Price"])));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    ds["Image"],
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  ds["Name"],
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Fresh And Healthy",
                                  style: AppWidget.lightTextFeildStyle(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  "\$" + ds["Price"],
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : const CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 30.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello Akshat,',
                    style: AppWidget.boldTextFeildStyle(),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                'Delicious Food',
                style: AppWidget.headlineTextFeildStyle(),
              ),
              Text(
                'Discover and Get Great Food',
                style: AppWidget.lightTextFeildStyle(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: showItem(),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 271,
                child: allItems(),
              ),
              const SizedBox(
                height: 30.0,
              ),
              allItemsVertically(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async{
            iceCream = true;
            pizza = false;
            salad = false;
            burger = false;
            fooditemStream = await DatabaseMethods().getFoodItem("Ice-cream");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: iceCream ? const Color(0xFFffdee9) : Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                "images/ice-cream.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            iceCream = false;
            pizza = true;
            salad = false;
            burger = false;
            fooditemStream = await DatabaseMethods().getFoodItem("Pizza");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: pizza ? const Color(0xFFffdee9) : Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                "images/pizza.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            iceCream = false;
            pizza = false;
            salad = true;
            burger = false;
            fooditemStream = await DatabaseMethods().getFoodItem("Salad");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: salad ? const Color(0xFFffdee9) : Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                "images/salad.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            iceCream = false;
            pizza = false;
            salad = false;
            burger = true;
            fooditemStream = await DatabaseMethods().getFoodItem("Burger");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                  color: burger ? const Color(0xFFffdee9) : Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                "images/burger.png",
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
