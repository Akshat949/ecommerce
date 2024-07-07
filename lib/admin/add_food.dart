// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'dart:io';

import 'package:ecommerce/service/database.dart';
import 'package:ecommerce/widget/widget_support.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final List<String> items = ['Ice-cream', 'Burger', 'Salad', 'Pizza'];
  String? value;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage()async{
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {
      
    });
  }

  uploadItem()async{
    // ignore: unnecessary_null_comparison
    if(selectedImage!=null && namecontroller.text!=null && pricecontroller.text!=null && detailcontroller.text!=null){

      String addId = randomAlphaNumeric(10);
      Reference firebasestorageRef = FirebaseStorage.instance.ref().child("blogImages").child(addId);
      final UploadTask task = firebasestorageRef.putFile(selectedImage!);

      var downloadUrl = await(await task).ref.getDownloadURL();

      Map<String, dynamic> addItem =  {
        "Image": downloadUrl,
        "Name":namecontroller.text,
        "Price":pricecontroller.text,
        "Detail":detailcontroller.text
      };
      await DatabaseMethods().addFood(addItem, value!).then((value){
        ScaffoldMessenger.of(context).showSnackBar(
            (const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Food Item Added Successfully",
                style: TextStyle(fontSize: 18),
              ),
            )),
          );
      } );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xff373866),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Item",
          style: AppWidget.headlineTextFeildStyle(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 20.0, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload The Item Picture",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              selectedImage==null? GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Center(
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ):Center(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        selectedImage!
                        ,fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Item Name",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Item Name",
                    hintStyle: AppWidget.lightTextFeildStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Item Price",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: pricecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Item Price",
                    hintStyle: AppWidget.lightTextFeildStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Item Detail",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  maxLines: 6,
                  controller: detailcontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Item Detail",
                    hintStyle: AppWidget.lightTextFeildStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Select Category",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: items
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                  fontSize: 18.0, color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: const Text("Select Category"),
                    iconSize: 36,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,
                  ),
                ),
              ),
              const SizedBox(height: 30.0,),
              GestureDetector(
                onTap: () {
                  uploadItem();
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
