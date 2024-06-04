import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:well_known/Screens/New_Invoice.dart';
import 'package:well_known/Services/items_api.dart';
import 'package:well_known/Utils/items_util.dart'; // assuming fetchItems is defined here
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:well_known/models/item_listss.dart';
import 'dart:math';

import '../Widgets/heading_text.dart';

class Itemlist extends StatefulWidget {
  const Itemlist({super.key});

  @override
  State<Itemlist> createState() => _ItemlistState();
}

class _ItemlistState extends State<Itemlist> {
  late double height;
  late double width;
  List<Item> items = [];
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    _initializeItems();
  }

  Future<void> _initializeItems() async {
    List<Item> fetchedItems = await fetchItems();
    setState(() {
      items = fetchedItems;
      quantities = List<int>.filled(items.length, 0);
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
        title: Headingtext(
            text: "  Item List", color: Colors.black, weight: FontWeight.w400),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(8.0),
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
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey)),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        var snackbar = SnackBar(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Color(0xffFF035e32),
                            content: Mytext(
                                text: "Added Successfully",
                                color: Colors.white));
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
            items.isNotEmpty
                ? Container(
              height: height / 1.1.h,
              width: width / 1.w,
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Item itemliss = items[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height / 3.6.h,
                        width: width / 1.98.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.green,
                              width: 2,
                            )),
                        child: Column(
                          children: [
                            SizedBox(height: 7),
                            Mytext(
                                text: itemliss.itemName.toString(),
                                color: Colors.green),
                            Divider(
                              height: 1,
                              thickness: 0.1,
                              color: Colors.black,
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Transform.rotate(
                                    angle: 0 * pi / 180,
                                    child:
                                    Container(
                                      height: height / 7.h,
                                      width: width / 3.4.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),

                                          image: DecorationImage(
                                            image: NetworkImage(
                                              'https://erp.wellknownssyndicate.com${itemliss.image?.toString() ?? "/files/bimage.png"}',
                                              headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"},
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil()
                                                .setWidth(30.0)),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Subhead(
                                              text: "Part-No : ",
                                              colo: Colors.black,
                                              weight: FontWeight.w500,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: ScreenUtil()
                                                      .setWidth(8.0)),
                                              child: Mytext(
                                                text: itemliss.part_no
                                                    .toString(),
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil()
                                                .setWidth(30.0)),
                                        child: Row(
                                          children: [
                                            Mytext(
                                                text: "HSN/SAC :",
                                                color: Colors.black),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: ScreenUtil()
                                                      .setWidth(8.0)),
                                              child: Mytext(
                                                  text: itemliss
                                                      .gst_hsn_code
                                                      .toString(),
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil()
                                                .setWidth(30.0)),
                                        child: Row(
                                          children: [
                                            Mytext(
                                                text: "UOM :",
                                                color: Colors.black),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: ScreenUtil().setWidth(8.0)),
                                              child: Mytext(
                                                  text: itemliss.stock_uom
                                                      .toString(),
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Subhead(
                                          text: "Qty",
                                          colo: Colors.black,
                                          weight: FontWeight.w500),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (quantities[index] >
                                                    0) {
                                                  quantities[index]--;
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: ScreenUtil()
                                                      .setWidth(8.0)),
                                              child: Container(
                                                height: height / 26.h,
                                                width: width / 8.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(5),
                                                ),
                                                child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: ScreenUtil()
                                                              .setWidth(3.0)),
                                                      child: Icon(
                                                        Icons
                                                            .exposure_minus_1,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: height / 26.h,
                                            width: width / 7.w,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(5)),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 4),
                                                Mytext(
                                                    text:
                                                    "${quantities[index]}",
                                                    color: Colors.black),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                quantities[index]++;
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: ScreenUtil()
                                                      .setWidth(8.0)),
                                              child: Container(
                                                height: height / 26.h,
                                                width: width / 8.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(5),
                                                ),
                                                child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: ScreenUtil()
                                                              .setWidth(3.0)),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ): Center(child: CircularProgressIndicator()),

          ],
        ),
      ),
    );
  }
}
