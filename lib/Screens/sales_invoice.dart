import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:well_known/Utils/sales_util.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';

import '../Services/sales_api.dart';

class SalesInvoice extends StatefulWidget {
  const SalesInvoice({super.key});

  @override
  State<SalesInvoice> createState() => _SalesInvoiceState();
}

class _SalesInvoiceState extends State<SalesInvoice> {
  late double height;
  late double width;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        ScreenUtil.init(context,designSize: Size(width, height),minTextAdapt: true);
        if(width<=600){
          return _smallbuildlayout();
        }
        else{
          return Text("Large");
        }
      },
      ),

    );
  }
  Widget _smallbuildlayout(){
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
          text: "Sales Invoice",
          color: Colors.black,
          weight: FontWeight.w500,
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              FutureBuilder<List<Sales>>(
                  future: fetch(),
                  builder: (context,snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    else{
                      return SingleChildScrollView(
                        child: Container(
                          height: height/1.2.h,
                          width: width/1.w,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                              itemBuilder: (context,index){
                              Sales sales = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: height/3.2.h,
                                  width: width/1.1.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.green,
                                      width: 2,
                                    )
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // Subhead(text: "Sales Person", colo: Colors.green, weight: FontWeight.w500),
                                          Subhead(text: sales.sales_person.toString(), colo: Colors.green.shade900,weight: FontWeight.w500,),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Subhead(text: "Billing Person", colo: Colors.green, weight: FontWeight.w500),
                                          Mytext(text: sales.billing_person.toString(), color: Colors.black),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Subhead(text: "Attended by", colo: Colors.green, weight: FontWeight.w500),
                                          Mytext(text: sales.attended_by.toString(), color: Colors.black),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Subhead(text: "Attended person", colo: Colors.green, weight: FontWeight.w500),
                                          Mytext(text: sales.attended_person.toString(), color: Colors.black),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Subhead(text: "Company", colo: Colors.green, weight: FontWeight.w500),
                                          Mytext(text: sales.company.toString(), color: Colors.black),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          const Subhead(text: "Branch", colo: Colors.green, weight: FontWeight.w500),
                                          Mytext(text: sales.branch.toString(), color: Colors.black),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          const Subhead(text: "Customer", colo: Colors.green, weight: FontWeight.w500),
                                          Mytext(text: sales.customer.toString(), color: Colors.black),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              }
                          ),
                        )
          
                      );
                    }
                  }
              )
            ],
          ),
        ),
      ),

    );
  }
}
