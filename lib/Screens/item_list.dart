import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:well_known/Screens/New_Invoice.dart';
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:well_known/models/item_listss.dart';

import '../Widgets/heading_text.dart';

class Itemlist extends StatefulWidget {
  const Itemlist({super.key});

  @override
  State<Itemlist> createState() => _ItemlistState();
}

class _ItemlistState extends State<Itemlist> {
  late double height;
  late double width;

  // List to hold the quantity of each item
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    // Initialize the quantities list with default values (1 for each item)
    quantities = List<int>.generate(lis.length, (index) => 0);
  }

  Future<void> refreshdata() async{
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      quantities = quantities;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: refreshdata,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            ScreenUtil.init(context, designSize: Size(width, height), minTextAdapt: true);
            if (width <= 600) {
              return _smallbuildlayout();
            } else {
              return Text("Large");
            }
          },
        ),
      ),
    );
  }

  Widget _smallbuildlayout() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
        title: Headingtext(text: "  Item List", color: Colors.black, weight: FontWeight.w400),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: height / 18.h,
                  width: width / 1.5.w,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      var snackbar = SnackBar(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Color(0xffFF035e32),
                          content: Mytext(text: "Added Successfully", color: Colors.white));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Get.off(Newinvoice());
                    },
                    child: Buttons(
                        heigh: height / 20,
                        width: width / 4.5,
                        color: Color(0xffFF035e32),
                        text: "Finish",
                        radius: BorderRadius.circular(12)))
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: lis.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: height / 4.h,
                            width: width / 1.1.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 2,
                                )),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: height / 9.h,
                                        width: width / 4.w,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: NetworkImage(lis[index].image), fit: BoxFit.cover)),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Subhead(text: lis[index].text, colo: Colors.black, weight: FontWeight.w400),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Mytext(text: lis[index].text1, color: Colors.black),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Mytext(text: lis[index].text2, color: Colors.black),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Subhead(text: "Qty", colo: Colors.black, weight: FontWeight.w300),
                                        Container(
                                          height: height / 22.h,
                                          width: width / 3.5.w,
                                          decoration: BoxDecoration(
                                              color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 4),
                                              Mytext(text: "${quantities[index]}", color: Colors.black),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Subhead(text: "UOM", colo: Colors.black, weight: FontWeight.w300),
                                        Container(
                                          height: height / 22.h,
                                          width: width / 3.8.w,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 2,
                                              )),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 4),
                                              Center(child: Mytext(text: "PCS", color: Colors.black)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 22.0, left: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            quantities[index]++;
                                          });
                                        },
                                        child: Container(
                                          height: height / 22.h,
                                          width: width / 6.w,
                                          decoration: BoxDecoration(
                                            color: Color(0xffFF035e32),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 28,
                                              )),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
