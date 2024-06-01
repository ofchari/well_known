import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:well_known/Services/sample.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:well_known/models/item_products.dart';
import 'package:http/http.dart'as http;
import 'package:well_known/utils/items_util.dart';
import 'package:well_known/utils/refreshdata.dart';

import '../Services/items_api.dart';
import '../Utils/items_util.dart';
import '../Utils/sample_util.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  late double height;
  late double width;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Item>> fetchItems() async {
    final response = await http.get(
      Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Item?fields=["name","item_name","item_group","sales_person","rack_name","item_sub_group","bin_no"]'),
      headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: refreshdata,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            ScreenUtil.init(
              context,
              designSize: Size(width, height),
              minTextAdapt: true,
            );
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
        toolbarHeight: 100,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Headingtext(
          text: "Items",
          color: Colors.black,
          weight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintText: "Search Item",
                  hintStyle: GoogleFonts.dmSans(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Item>>(
              future: fetchItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No items found'));
                } else {
                  return SingleChildScrollView(
                    child: Container(
                      height: height/1.1.h,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Item item = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Container(
                                  height: height/5.h,
                                  width: width/1.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.green
                                    ),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Mytext(text: item.itemName.toString(), color: Colors.blue),
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Subhead(text: "Item Group", colo: Colors.black, weight: FontWeight.w500,),
                                          Mytext(text: item.itemGroup.toString(), color: Colors.green)
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Subhead(text: "sales Person", colo: Colors.black, weight: FontWeight.w500,),
                                          Mytext(text: item.salesPerson.toString(), color: Colors.green)
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Subhead(text: "Bill ", colo: Colors.black, weight: FontWeight.w500,),
                                          Mytext(text: item.binNo.toString(), color: Colors.green)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                    right: 30,
                                    child: GestureDetector(
                                      onTap: (){
                                        _shareContent();
                                      },
                                      child: Container(
                                        height: height/18.h,
                                        width: width/8.w,
                                        decoration: BoxDecoration(
                                          color: Color((0xffFF035e32)),
                                          shape: BoxShape.circle
                                        ),
                                        child: Center(child: Icon(Icons.share,color: Colors.white,size: 20,)),

                                      ),
                                    )
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareContent() {
    final RenderBox? box =
    scaffoldKey.currentContext?.findRenderObject() as RenderBox?;
    Share.share(
      'Click and share where you want to !',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
    }
}
//

class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            FutureBuilder<List<CategoryList>>(
                future: fetchhes(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  else if(snapshot.hasError){
                    return Text("${snapshot.error}");
                  }
                  else{
                    return SingleChildScrollView(
                      child: Container(
                        height: 300,
                        width: 400,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context,int index){
                            CategoryList categ = snapshot.data![index];
                            return Column(
                              children: [
                                Mytext(text: categ.categoryId.toString(), color: Colors.black),
                                Mytext(text: categ.category.toString(), color: Colors.black),
                              ],
                            );

                            }
                        ),
                      ),
                    );
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
//





