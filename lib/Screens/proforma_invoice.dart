import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:well_known/Screens/invoice.dart';
import 'package:well_known/Screens/new_proforma_voice.dart';
import 'package:well_known/Services/proforma_api.dart';
import 'package:well_known/Utils/proforma_utils.dart';
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:well_known/models/invoice_data.dart';
import 'package:well_known/utils/refreshdata.dart';
import '../Widgets/heading_text.dart';

class ProformaInvoicee extends StatefulWidget {
  const ProformaInvoicee({super.key});

  @override
  State<ProformaInvoicee> createState() => _ProformaInvoiceeState();
}

class _ProformaInvoiceeState extends State<ProformaInvoicee> {
  late double height;
  late double width;

  @override
  void initState() {
    binding();
    super.initState();

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
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          height = constraints.maxHeight;
          width = constraints.maxWidth;
          ScreenUtil.init(context,designSize:Size(width, height),minTextAdapt: true);
          if(width <=600){
            return _smallbuildlayout();
          }
          else{
            return Text("Large");
          }
        },
        ),
      ),

    );
  }
  Widget _smallbuildlayout(){
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 100,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        title: Headingtext(text: " Proforma Invoice", color: Colors.black, weight: FontWeight.w500),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<List<SalesOrder>>(
                      future: binding(),
                      builder: (context,snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }
                        else if(snapshot.hasError){
                          return Text("${snapshot.error}");
                        }
                        else{
                          return Container(
                            height: height/1.1.h,
                            width: width/1.w,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context,index){
                                SalesOrder proforma = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: height/3.5.h,
                                      width: width/1.3.w,
                                      decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                    color: Colors.green,
                                    width: 1.2
                                    )
                                  ),
                                    child: Column(
                                      children: [
                                          SizedBox(height: 10,),
                                          Subhead(text: proforma.salesPerson.toString(), colo: Colors.black, weight: FontWeight.w600),
                                          SizedBox(height: 5,),
                                          Subhead(text: proforma.billingPerson.toString(), colo: Colors.black, weight: FontWeight.w300),
                                        SizedBox(height: 10,),
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Mytext(text: " DATE :", color: Colors.black),
                                                  Mytext(text: proforma.postingdate.toString(), color: Colors.black),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Mytext(text: "Due Date :", color: Colors.black),
                                                    Mytext(text: proforma.deliveryDate.toString(), color: Colors.black),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Mytext(text: "Company", color: Colors.black),
                                              Mytext(text: proforma.company.toString(), color: Colors.green),
                                            ],
                                          ),
                                        SizedBox(height: 20,),
                                        GestureDetector(
                                          onTap: (){
                                            Get.to(Invoice());
                                          },
                                          child: Container(
                                            height: height/18.h,
                                            width: width/1.3.w,
                                            decoration: BoxDecoration(
                                              color: Color(0xffFF035e32),
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(child: Subhead(text: "View", colo: Colors.white, weight: FontWeight.w500,)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                                }
                            ),
                          );
                        }
                      }
                  ),
                  SizedBox(height: 80,),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: SizedBox(
                height: 50,
                width: 50,
                child: FloatingActionButton(
                  backgroundColor: Color(0xffFF035e32),
                  onPressed: (){
                    Get.to(Newproformavoice());
                  },child: Icon(Icons.add,color: Colors.white,),),
              ))
                      ]),

    );
  }
}
