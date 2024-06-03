import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:well_known/Screens/dashboard.dart';
import 'package:well_known/Screens/item_list.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:well_known/utils/refreshdata.dart';

import '../Widgets/buttons.dart';

class Newinvoice extends StatefulWidget {
  const Newinvoice({super.key});

  @override
  State<Newinvoice> createState() => _NewinvoiceState();
}

class _NewinvoiceState extends State<Newinvoice> {
  late double height;
  late double width;

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
          ScreenUtil.init(context,designSize: Size(width, height),minTextAdapt: true);
          if(width<=600){
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Mytext(text: "Items", color: Colors.grey),
                  Column(
                    children: [
                      Mytext(text: "Net Total", color: Colors.black),
                      Mytext(text: "84.35", color: Colors.black),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 22.0,left: 8.0),
                    child: GestureDetector(
                      onTap: (){
                        Get.to(Itemlist());
                      },
                      child: Container(
                        height: height/26.h,
                        width: width/8.w,
                        decoration: BoxDecoration(
                          color:  Color(0xffFF035e32),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child:  Center(child: Icon(Icons.add,color: Colors.white,size: 24,)),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 50,),
              Container(
                height: height/5.h,
                width: width/1.1.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.green,
                    width: 1.5
                  )
                ),
                child:  Column(
                  children: [
                    SizedBox(height: 10,),
                    Subhead(text: "Item 1", colo: Colors.black, weight: FontWeight.w500),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: height/9.h,
                            width: width/4.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: NetworkImage("https://img.freepik.com/premium-photo/close-up-sewing-machine-with-hands-working_41969-2495.jpg"),fit: BoxFit.cover
                                )
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: SizedBox(
                          //     height: 113,
                          //     child: VerticalDivider(
                          //       width: 2,
                          //       thickness: 2,
                          //       color: Colors.green,
                          //     ),
                          //   ),
                          // ),

                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Mytext(text: "Code : 100", color: Colors.black),
                                SizedBox(height: 10,),
                                Mytext(text: "Item Group", color: Colors.black),
                                SizedBox(height: 10,),
                                Mytext(text: "UOM - PCS", color: Colors.black),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 1.5,),
              Container(
                height: height/10.27.h,
                width: width/1.42.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  border: Border.all(
                    color: Colors.green,
                    width: 1.2
                  )
                ),
                child: Column(
                  children: [
                    // SizedBox(height: ,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Mytext(text: "Quantity", color: Colors.black),
                            Container(
                              // height: ,
                              width: width/10.w,
                              // color: Colors.yellow,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                                  hintText: "0",
                                  border: InputBorder.none
                                ),
                              ),
                            )

                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Mytext(text: "Rate", color: Colors.black),
                            Container(
                              width: width/10.w,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "0.0",
                                    border: InputBorder.none
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Mytext(text: "Total", color: Colors.grey),
                            Mytext(text: "0.0", color: Colors.grey),
                          ],
                        ),
                        Column(
                          children: [
                            Mytext(text: "UOM", color: Colors.grey),
                            Mytext(text: "SET", color: Colors.grey),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: height/5.h,
                width: width/1.1.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.green,
                        width: 1.5
                    )
                ),
                child:  Column(
                  children: [
                    SizedBox(height: 10,),
                    Subhead(text: "Item 2", colo: Colors.black, weight: FontWeight.w500),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: height/9.h,
                            width: width/4.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: NetworkImage("https://www.shutterstock.com/shutterstock/videos/991390/thumb/1.jpg?ip=x480"),fit: BoxFit.cover
                                )
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: SizedBox(
                          //     height: 113,
                          //     child: VerticalDivider(
                          //       width: 2,
                          //       thickness: 2,
                          //       color: Colors.green,
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Mytext(text: "Code : 2000", color: Colors.black),
                                SizedBox(height: 10,),
                                Mytext(text: "Item Group", color: Colors.black),
                                SizedBox(height: 10,),
                                Mytext(text: "UOM - PCS", color: Colors.black),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.5,),
              Container(
                height: height/10.27.h,
                width: width/1.42.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    border: Border.all(
                        color: Colors.green,
                        width: 1.2
                    )
                ),
                child: Column(
                  children: [
                    // SizedBox(height: ,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Mytext(text: "Quantity", color: Colors.black),
                            Container(
                              // height: ,
                              width: width/10.w,
                              // color: Colors.yellow,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                                    hintText: "0",
                                    border: InputBorder.none
                                ),
                              ),
                            )

                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Mytext(text: "Rate", color: Colors.black),
                            Container(
                              width: width/10.w,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "0.0",
                                    border: InputBorder.none
                                ),
                              ),
                            )

                          ],
                        ),
                        Column(
                          children: [
                            Mytext(text: "Total", color: Colors.grey),
                            Mytext(text: "0.0", color: Colors.grey),
                          ],
                        ),
                        Column(
                          children: [
                            Mytext(text: "UOM", color: Colors.grey),
                            Mytext(text: "SET", color: Colors.grey),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
          
              SizedBox(height: 20,),
              Container(
                height: height/5.h,
                width: width/1.1.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.green,
                        width: 1.5
                    )
                ),
                child:  Column(
                  children: [
                    SizedBox(height: 10,),
                    Subhead(text: "Item 3", colo: Colors.black, weight: FontWeight.w500),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: height/9.h,
                            width: width/4.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: NetworkImage("https://p0.pxfuel.com/preview/30/696/865/sewing-machine-fabric-cloth.jpg"),fit: BoxFit.cover
                                )
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: SizedBox(
                          //     height: 113,
                          //     child: VerticalDivider(
                          //       width: 2,
                          //       thickness: 2,
                          //       color: Colors.green,
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Mytext(text: "Code : 1000", color: Colors.black),
                                SizedBox(height: 10,),
                                Mytext(text: "Item Group", color: Colors.black),
                                SizedBox(height: 10,),
                                Mytext(text: "UOM - PCS", color: Colors.black),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 1.5,),
              Container(
                height: height/10.27.h,
                width: width/1.42.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    border: Border.all(
                        color: Colors.green,
                        width: 1.2
                    )
                ),
                child: Column(
                  children: [
                    // SizedBox(height: ,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Mytext(text: "Quantity", color: Colors.black),
                            Container(
                              // height: ,
                              width: width/10.w,
                              // color: Colors.yellow,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                                    hintText: "0",
                                    border: InputBorder.none
                                ),
                              ),
                            )

                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Mytext(text: "Rate", color: Colors.black),
                            Container(
                              width: width/10.w,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "0.0",
                                    border: InputBorder.none
                                ),
                              ),
                            )

                          ],
                        ),
                        Column(
                          children: [
                            Mytext(text: "Total", color: Colors.grey),
                            Mytext(text: "0.0", color: Colors.grey),
                          ],
                        ),
                        Column(
                          children: [
                            Mytext(text: "UOM", color: Colors.grey),
                            Mytext(text: "SET", color: Colors.grey),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
          
              SizedBox(height: 20,),
              Container(
                height: height/5.h,
                width: width/1.1.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.green,
                        width: 1.5
                    )
                ),
                child:  Column(
                  children: [
                    SizedBox(height: 10,),
                    Subhead(text: "Item 4", colo: Colors.black, weight: FontWeight.w500),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: height/9.h,
                            width: width/4.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9_J7qTBKFZH4KDtGjQBgyeMrvoXFfC3Cm-tdzNtODdz1cDOj21c1VSjGfMwoxylee06c&usqp=CAU"),fit: BoxFit.cover
                                )
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: SizedBox(
                          //     height: 113,
                          //     child: VerticalDivider(
                          //       width: 2,
                          //       thickness: 2,
                          //       color: Colors.green,
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Mytext(text: "Code : 1000", color: Colors.black),
                                SizedBox(height: 10,),
                                Mytext(text: "Item Group", color: Colors.black),
                                SizedBox(height: 10,),
                                Mytext(text: "UOM - PCS", color: Colors.black),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 1.6,),
              Container(
                height: height/10.27.h,
                width: width/1.42.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    border: Border.all(
                        color: Colors.green,
                        width: 1.2
                    )
                ),
                child: Column(
                  children: [
                    // SizedBox(height: ,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Mytext(text: "Quantity", color: Colors.black),
                            Container(
                              // height: ,
                              width: width/10.w,
                              // color: Colors.yellow,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                                    hintText: "0",
                                    border: InputBorder.none
                                ),
                              ),
                            )

                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 10,),
                            Mytext(text: "Rate", color: Colors.black),
                            Container(
                              width: width/10.w,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "0.0",
                                    border: InputBorder.none
                                ),
                              ),
                            )

                          ],
                        ),
                        Column(
                          children: [
                            Mytext(text: "Total", color: Colors.grey),
                            Mytext(text: "0.0", color: Colors.grey),
                          ],
                        ),
                        Column(
                          children: [
                            Mytext(text: "UOM", color: Colors.grey),
                            Mytext(text: "SET", color: Colors.grey),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Get.off(Dashboard());
                },
                  child: Buttons(heigh: height/18.h, width: width/1.5.w, color: Color(0xffFF035e32), text: "Submit", radius: BorderRadius.circular(8))),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),

    );
  }
}
