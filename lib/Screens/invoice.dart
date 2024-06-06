import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:well_known/Screens/home.dart';
import 'package:well_known/Services/sales_api.dart';
import 'package:well_known/Utils/proforma_utils.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';

import '../Services/proforma_api.dart';
import '../Widgets/heading_text.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          height =  constraints.maxHeight;
          width =  constraints.maxWidth;
          ScreenUtil.init(context,designSize: Size(width, height),minTextAdapt: true);
          if(width<=450){
            return _smallBuildLayout();
          }
          else{
            return Text("Large");
          }
        },
        ),
      ),
    );
  }
  Widget _smallBuildLayout(){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Headingtext(text: " Invoice", color: Colors.black, weight: FontWeight.w400),
        centerTitle: true,
        actions: [
          Icon(Icons.home,color: Colors.black,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert,color: Colors.black,),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: height/1.32.h,
                width: width/1.1.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.blue,
                        width: 1.2
                    )
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Buttons(heigh: height/18.h, width: width/4.5.w, color: Colors.green, text: "Action", radius: BorderRadius.circular(26),),
                        )),
                    SizedBox(height: 5,),
                    Mytext(text: "Sales Order", color: Colors.black),
                    SizedBox(height: 5,),
                    Mytext(text: "SAL - ORD 2023-00055", color: Colors.black),
                    SizedBox(height: 5,),
                    Mytext(text: "Customer: ABC Company", color: Colors.black),
                    SizedBox(height: 5,),
                    Mytext(text: " ABC Company", color: Colors.black),
                    SizedBox(height: 15,),
                    Divider(
                      height: 1,
                      thickness: 2,
                      color: Colors.green,
                    ),
                    SizedBox(height: 5,),
                    IntrinsicHeight(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Mytext(text: "Date", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: "24-05-2024", color: Colors.black),
                            ],
                          ),
                          SizedBox(
                            height: 58,
                            child: VerticalDivider(
                              thickness: 2,
                              color: Colors.green,
                            ),
                          ),
                          Column(
                            children: [
                              Mytext(text: "Delivery Date", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: "30-08-2024", color: Colors.black),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.green,
                    ),
                    SizedBox(height: 5,),
                    IntrinsicHeight(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Mytext(text: "Status", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: "Drafts", color: Colors.black),
                            ],
                          ),
                          SizedBox(
                            height: 58,
                            child: VerticalDivider(
                              thickness: 2,
                              color: Colors.green,
                            ),
                          ),
                          Column(
                            children: [
                              Mytext(text: "Tax id", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: "Sales", color: Colors.black),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.green,
                    ),
                    SizedBox(height: 10,),
                    Mytext(text: "Customer Group", color: Colors.black),
                    SizedBox(height: 5,),
                    Mytext(text: "Major Chain Customers", color: Colors.black),
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.green,
                    ),
                    SizedBox(height: 10,),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Mytext(text: " Customer Address", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: " ABC Compny - Billing", color: Colors.black),
                            ],
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left: ScreenUtil().setWidth(15.0)),
                            child: SizedBox(
                              height: 66,
                              child: VerticalDivider(
                                thickness: 2,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(30.0)),
                            child: Column(
                              children: [
                                Mytext(text: "Address", color: Colors.black),
                                SizedBox(height: 4,),
                                Mytext(text: "Obour-Hy 7", color: Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.green,
                    ),
                    SizedBox(height: 5,),
                    IntrinsicHeight(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Mytext(text: "Contact", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: "ABC Company", color: Colors.black),
                            ],
                          ),
                          SizedBox(
                            height: 58,
                            child: VerticalDivider(
                              thickness: 2,
                              color: Colors.green,
                            ),
                          ),
                          Column(
                            children: [
                              Mytext(text: "Mobile No", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: "90250114443", color: Colors.black),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.green,
                    ),
                    SizedBox(height: 10,),
                    Mytext(text: "Contact Email", color: Colors.black),
                    SizedBox(height: 2,),
                    Mytext(text: "ofchari4@gmail.com", color: Colors.black),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              // Sales Container //
              Container(
                height: height/3.8,
                width: width/1.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.green
                    )
                ),
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    IntrinsicHeight(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 10,),
                              Mytext(text: "   Project", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: "   None", color: Colors.black),
                            ],
                          ),
                          SizedBox(
                            height: 65,
                            child: VerticalDivider(
                              thickness: 2,
                              color: Colors.green,
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Mytext(text: "Order Type", color: Colors.black),
                                SizedBox(height: 4,),
                                Mytext(text: "Sales", color: Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.green,
                    ),
                    SizedBox(height: 5,),
                    IntrinsicHeight(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Mytext(text: "Currency", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: "INR", color: Colors.black),
                            ],
                          ),
                          SizedBox(
                            height: 58,
                            child: Padding(
                              padding:  EdgeInsets.only(left: ScreenUtil().setWidth(8.0)),
                              child: VerticalDivider(
                                thickness: 2,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Mytext(text: "Exchange Rate", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: "1.00", color: Colors.black),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.green,
                    ),
                    SizedBox(height: 5,),
                    IntrinsicHeight(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Mytext(text: "Price List", color: Colors.black),
                              SizedBox(height: 4,),
                              Mytext(text: "100", color: Colors.black),
                            ],
                          ),
                          SizedBox(
                            height: 65,
                            child: Padding(
                              padding:  EdgeInsets.only(right: ScreenUtil().setWidth(30.2)),
                              child: VerticalDivider(
                                thickness: 2,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(right: ScreenUtil().setWidth(6.0)),
                                child: Mytext(text: "Price List", color: Colors.black),
                              ),
                              SizedBox(height: 4,),
                              Mytext(text: "100", color: Colors.black),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
            ],

          ),
        ),
      ),
    );
  }
}
