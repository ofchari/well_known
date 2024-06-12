import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:well_known/Screens/New_Invoice.dart';
import 'package:well_known/Services/items_api.dart';
import 'package:well_known/Utils/items_util.dart'; // assuming fetchItems is defined here
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:well_known/models/item_listss.dart';
import 'dart:math';

import '../Utils/refreshdata.dart';
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
  List<Item> filteredItems = [];
  List<int> quantities = [];
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _initializeItems();
    searchController.addListener(_filterItems);
  }

  Future<void> _initializeItems() async {
    List<Item> fetchedItems = await fetchItems();
    setState(() {
      items = fetchedItems;
      filteredItems = fetchedItems;
      quantities = List<int>.filled(items.length, 0);
    });
  }

  void _filterItems() {
    String query = _preprocessString(searchController.text);
    setState(() {
      filteredItems = items.where((item) {
        return _preprocessString(item.itemName ?? '').contains(query);
      }).toList();
    });
  }

  String _preprocessString(String input) {
    return input.replaceAll(RegExp(r'[\s,%."]'), '').toLowerCase();
  }

  void _addSelectedItem(Item item, int quantity) {
    setState(() {
      selectedItems.add({
        'item': item,
        'quantity': quantity,
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            ScreenUtil.init(context, designSize: Size(width, height), minTextAdapt: true);
            if (width <= 450) {
              return _smallBuildLayout();
            } else {
              return const Text("Large");
            }
          },
        ),
      ),
    );
  }

  Widget _smallBuildLayout() {
    return Stack(
      children: [
        Positioned(
          top: 20.h,
          left: 0,
          right: 0,
          child: _buildAppBar(),
        ),
        Positioned(
          top: 100.h,
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBody(),
        ),
      ],
    );
  }

  // App Bar //
  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      title: const Headingtext(
        text: "  Item List",
        color: Colors.black,
        weight: FontWeight.w400,
      ),
      centerTitle: true,
    );
  }

  // Body //
  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height / 18.h,
                width: width / 1.5.w,
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.snackbar(
                    "Added Successfully",
                    "Thank you",
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );

                  Get.to(() => Newinvoice());
                },
                child: Buttons(
                  heigh: height / 20,
                  width: width / 4.5,
                  color: const Color(0xffff035e32),
                  text: "Finish",
                  radius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredItems.isNotEmpty
              ? SizedBox(
            height: height / 1.1.h,
            width: width / 1.w,
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                Item itemliss = filteredItems[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: height / 3.3.h,
                    width: width / 1.98.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 7),
                        Mytext(
                          text: itemliss.itemName.toString(),
                          color: Colors.blue,
                        ),
                        const Divider(
                          height: 1,
                          thickness: 0.1,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Transform.rotate(
                                angle: 0 * pi / 180,
                                child: Container(
                                  height: height / 7.h,
                                  width: width / 3.4.w,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://erp.wellknownssyndicate.com${itemliss.image?.toString() ?? "/files/bimage.png"}',
                                        headers: {
                                          "Authorization":
                                          "token c5a479b60dd48ad:d8413be73e709b6"
                                        },
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left:
                                      ScreenUtil().setWidth(30.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        const Subhead(
                                          text: "Part-No : ",
                                          colo: Colors.black,
                                          weight: FontWeight.w500,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: ScreenUtil()
                                                .setWidth(8.0),
                                          ),
                                          child: Mytext(
                                            text: itemliss.part_no
                                                .toString(),
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left:
                                      ScreenUtil().setWidth(30.0),
                                    ),
                                    child: Row(
                                      children: [
                                        const Mytext(
                                          text: "HSN/SAC :",
                                          color: Colors.black,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: ScreenUtil()
                                                .setWidth(8.0),
                                          ),
                                          child: Mytext(
                                            text: itemliss
                                                .gst_hsn_code
                                                .toString(),
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left:
                                      ScreenUtil().setWidth(30.0),
                                    ),
                                    child: Row(
                                      children: [
                                        const Mytext(
                                          text: "UOM :",
                                          color: Colors.black,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: ScreenUtil()
                                                .setWidth(8.0),
                                          ),
                                          child: Mytext(
                                            text: itemliss.stock_uom
                                                .toString(),
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    const Mytext(
                                      text: "MRP :",
                                      color: Colors.black,
                                    ),
                                    Mytext(
                                      text: itemliss.brand.toString(),
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: height / 20.h,
                                width: width / 4.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "QTY",
                                    hintStyle: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                    const EdgeInsets.only(
                                        left: 10, right: 10),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    quantities[index] = int.tryParse(value) ?? 0;
                                  },
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _addSelectedItem(itemliss, quantities[index]);
                                  Get.snackbar(
                                    "Item Added",
                                    "${itemliss.itemName} added successfully!",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.blue,
                                    colorText: Colors.white,
                                  );
                                },
                                child: Text('Add'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffff035e32),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
