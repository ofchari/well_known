import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:well_known/Screens/New_Invoice.dart';
import 'package:well_known/Screens/invoice.dart';
import 'package:well_known/Screens/proforma_invoice.dart';
import 'package:well_known/Screens/item_list.dart';
import 'package:well_known/Screens/items.dart';
import 'package:well_known/Screens/purchase_inward.dart';
import 'package:well_known/Screens/sales_invoice.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late double height;
  late double width;
  late List<ChartData> _chartData;

  @override
  void initState() {
    _chartData = getChartData();
    super.initState();
  }

  List<ChartData> getChartData() {
    DateTime today = DateTime.now();
    List<ChartData> data = [];
    for (int i = 6; i >= 0; i--) {
      DateTime date = today.subtract(Duration(days: i));
      String formattedDate = "${date.day}/${date.month}";
      data.add(ChartData(formattedDate, (10 + 10 * i).toDouble())); // Sample data
    }
    return data;
  }

  Future<void> _refreshdata() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _chartData = getChartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshdata,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            ScreenUtil.init(context,
                designSize: Size(width, height), minTextAdapt: true);
            if (width <= 600) {
              return _smallbuildlayout();
            } else {
              return Center(
                child: Text("Large"),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _smallbuildlayout() {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        title: Headingtext(
          text: "Dashboard",
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<ChartData, String>(
                      color: Colors.blue,
                      dataSource: _chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      animationDuration: 2000, // Animation duration for pulsar effect
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            height: height/4.5,
                            width: width/2.5,
                            decoration: BoxDecoration(
                              // color: Colors.grey,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 60,),
                                Container(
                                  height: height/8.h,
                                  width: width/2.8.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 2
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 70,),
                                      Text("Proforma Invoice",style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 13.5,fontWeight: FontWeight.w500,color: Colors.black)),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 28.3,
                            child:GestureDetector(
                              onTap: (){
                                Get.to(ProformaInvoicee());
                              },
                              child: Container(
                                height: height/10.h,
                                width: width/4.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 1.7
                                    ),
                                    color: Colors.white
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 27,),
                                    Icon(Icons.align_vertical_center,color: Colors.black,),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: height/4.5.h,
                          width: width/2.5.w,
                          decoration: BoxDecoration(
                            // color: Colors.grey,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 60,),
                              Container(
                                height: height/8.h,
                                width: width/2.8.w,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 2
                                    ),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 70,),
                                    Text("Item",style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 13.5,fontWeight: FontWeight.w500,color: Colors.black)),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 37,
                          left: 28.5,
                          child: GestureDetector(
                            onTap: (){
                              Get.to(Items());
                            },
                            child: Container(
                              height: height/10.h,
                              width: width/4.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 1.5
                                  ),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 26,),
                                  Icon(Icons.production_quantity_limits,color: Colors.black,),
                                ],
                              ),

                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 1,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            height: height/4.5,
                            width: width/2.5,
                            decoration: BoxDecoration(
                              // color: Colors.grey,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 60,),
                                Container(
                                  height: height/8.h,
                                  width: width/2.8.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 2
                                      )
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 70,),
                                      Text("Purchase Inward",style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 13.5,fontWeight: FontWeight.w500,color: Colors.black)),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 28.3,
                            child:InkWell(
                              onTap: (){
                                Get.to(Purchaseinward());
                              },
                              child: Container(
                                height: height/10.h,
                                width: width/4.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 1.7
                                    ),
                                    color: Colors.white
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 26,),
                                    Icon(Icons.safety_check,color: Colors.black,),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: height/4.5.h,
                          width: width/2.5.w,
                          decoration: BoxDecoration(
                            // color: Colors.grey,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 60,),
                              Container(
                                height: height/8.h,
                                width: width/2.8.w,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 2
                                    ),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 70,),
                                    Text("Sales Invoice",style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 13.5,fontWeight: FontWeight.w500,color: Colors.black)),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 37,
                          left: 27.3,
                          child: InkWell(
                            onTap: (){
                              Get.to(SalesInvoice());
                            },
                            child: Container(
                              height: height/10.h,
                              width: width/4.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey,
                                      width: 1.5
                                  ),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: SizedBox(
                                  height: 26,
                                  child: Icon(Icons.area_chart,color: Colors.black,)),

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
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
