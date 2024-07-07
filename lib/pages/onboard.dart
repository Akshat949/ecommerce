import 'package:ecommerce/pages/signup.dart';
import 'package:ecommerce/widget/content_model.dart';
import 'package:ecommerce/widget/widget_support.dart';
import 'package:flutter/material.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40,left: 20,right: 20),
                    child: Column(
                      children: [
                        Image.asset(
                          contents[i].image,
                          height: 420,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              contents[i].title,
                              style: AppWidget.semiBoldTextFeildStyle(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            contents[i].description,
                            style: AppWidget.lightTextFeildStyle(),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              }
              _controller.nextPage(duration:const Duration(milliseconds: 100), curve: Curves.bounceIn);
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(30)),
              height: 60,
              margin: const EdgeInsets.all(40),
              width: double.infinity,
              child: Center(
                child: Text(
                   currentIndex == contents.length - 1?"Start" :"Next",
                  style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext content) {
    return Container(
      height: 10.0,
      width: currentIndex == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.black38),
    );
  }
}
