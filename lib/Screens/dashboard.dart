import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:well_known/Screens/proforma_invoice.dart';
import 'package:well_known/Screens/purchase_inward.dart';
import 'package:well_known/Screens/purchase_order.dart';
import 'package:well_known/Screens/sales.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/text.dart';
import 'items.dart';



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
    super.initState();
    _loadChartData();
    UserDetails();
  }

  Future<void> _loadChartData() async {
    _chartData = await getChartData();
    setState(() {}); // Triggering a rebuild after data is loaded
  }

  Future<List<ChartData>> getChartData() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    DateTime today = DateTime.now() ;
    List<ChartData> data = [];
    for (int i = 6; i >= 0; i--) {
      DateTime date = today.subtract(Duration(days: i));
      String formattedDate = "${date.day}/${date.month}";
      String formattedDate2 = "${date.year}-${date.month}-${date.day}";
      // data.add(ChartData(formattedDate, (10 + 5 * i).toDouble())); // Sample data
      final uri =
          "https://erp.wellknownssyndicate.com/api/method/frappe.desk.reportview.get?"
          "doctype=Sales+Invoice&fields=%5B%22%60tabSales+Invoice%60.%60company%60%22%5D&"
          "filters=%5B%5B%22Sales+Invoice%22%2C%22posting_date%22%2C%22%3D%22%2C%22$formattedDate2"
          "%22%5D%2C%5B%22Sales+Invoice%22%2C%22status%22%2C%22!%3D%22%2C%22Cancelled%22%5D%2C%5B%22"
          "Sales+Invoice%22%2C%22company%22%2C%22%3D%22%2C%22WELLKNOWNS+SYNDICATE%22%5D%5D&"
          "order_by=_aggregate_column+desc&start=0&page_length=20&view=Report&with_comment_count=false&"
          "aggregate_on_field=base_rounded_total"
          "&aggregate_on_doctype=Sales+Invoice&aggregate_function=sum&group_by=%60tabSales+Invoice%60.%60company%60";

      try {
        final response = await ioClient.post(Uri.parse(uri),
            headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);

          print(formattedDate);
          print(jsonData['message']);
          print(jsonData['message']);
          print(jsonData['message']);
          print(jsonData['message']);
          var datas;

          if (jsonData['message'] == null || jsonData['message'].isEmpty) {
            datas = {
              'keys': ['company', '_aggregate_column', 'base_rounded_total'],
              'values': [['WELLKNOWNS SYNDICATE', 0.0, 0.0]]
            };
          } else {
            datas = jsonData['message'];
          }
          // Extracting the second amount
          var values = datas['values']  as List;
          var secondAmount = values[0][1]; // Accessing the third element which is the second amount
          print('Second amount: $secondAmount');// Sample data
          data.add(ChartData(formattedDate, secondAmount.toDouble()));

          // data.add(ChartData(formattedDate, jsonData['message']['values'][1].toDouble()));
          setState(() {
            // data.add(ChartData(formattedDate, secondAmount.toDouble()));
            // _chartData = jsonData['message']
            //     .map<ChartData>((data) => ChartData(data[0], data[1].toDouble()))
            //     .toList();
          });
        } else {
          // Handle error
          print('Failed to load Wallet Title data');
          print(response.statusCode);
          print(response.body);
        }
      } catch (e) {
        throw Exception('Failed to load document IDs: $e');
      }
    }
    return data;
  }
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    await _loadChartData(); // Refreshing chart data
  }

  String storeUsername = '';
  String username = 'admin';



  Future<void> UserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');


    if(storedUsername == username){
      return UserDetails();
    }
    else{
      "There is no Bar chart for Employess " ;
    }
    }

  // late List<ChartData> _chartData;
  //
  // @override
  // void initState() {
  //   _chartData = getChartData();
  //   super.initState();
  // }
  //
  // // List<ChartData> getChartData() {
  //
  // // Future<List<ChartData>> getChartData() async {
  //
  // Future<List<ChartData>> getChartData() async {
  //   HttpClient client = new HttpClient();
  //   client.badCertificateCallback =
  //   ((X509Certificate cert, String host, int port) => true);
  //   IOClient ioClient = new IOClient(client);
  //   DateTime today = DateTime.now();
  //   List<ChartData> data = [];
  //   for (int i = 6; i >= 0; i--) {
  //     DateTime date = today.subtract(Duration(days: i));
  //     String formattedDate = "${date.day}/${date.month}";
  //     String formattedDate2 = "${date.year}-${date.month}-${date.day}";
  //     data.add(ChartData(formattedDate, (10 + 5 * i).toDouble())); // Sample data
  //     final uri="https://erp.wellknownssyndicate.com/api/method/frappe.desk.reportview.get?"
  //         "doctype=Sales+Invoice&fields=%5B%22%60tabSales+Invoice%60.%60company%60%22%5D&"
  //         "filters=%5B%5B%22Sales+Invoice%22%2C%22posting_date%22%2C%22%3D%22%2C%22${formattedDate2}"
  //         "%22%5D%2C%5B%22Sales+Invoice%22%2C%22status%22%2C%22!%3D%22%2C%22Cancelled%22%5D%2C%5B%22"
  //         "Sales+Invoice%22%2C%22company%22%2C%22%3D%22%2C%22WELLKNOWNS+SYNDICATE%22%5D%5D&"
  //         "order_by=_aggregate_column+desc&start=0&page_length=20&view=Report&with_comment_count=false&"
  //         "aggregate_on_field=base_rounded_total"
  //         "&aggregate_on_doctype=Sales+Invoice&aggregate_function=sum&group_by=%60tabSales+Invoice%60.%60company%60";
  //
  //
  //     try {
  //       final response = await ioClient.post(
  //           Uri.parse(uri),headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
  //       if (response.statusCode == 200) {
  //
  //         final jsonData = json.decode(response.body);
  //         setState(() {
  //           _chartData = jsonData['message'].map<ChartData>((data) {
  //             return ChartData(data[0], data[1].toDouble());
  //           }).toList();
  //         });
  //         // final responseData = json.decode(response.body)["data"];
  //         //
  //         //
  //         // for (var item in responseData) {
  //         //   if (item["name"] != null) {
  //         //     saless.add( DropDownValueModel(name: item["employee_name"], value: item["name"]));
  //         //   }
  //         // }
  //
  //
  //       } else {
  //         // Handle error
  //         print('Failed to load Wallet Title data');
  //         print(response.statusCode );
  //         print(response.body );
  //       }
  //     } catch (e) {
  //       throw Exception('Failed to load document IDs: $e');
  //     }
  //   }
  //   return data;
  // }
  //
  // Future<void> _refreshdata() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   setState(() {
  //     _chartData = getChartData();
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            ScreenUtil.init(context,
                designSize: Size(width, height), minTextAdapt: true);
            if (width <= 450) {
              return _smallBuildLayout();
              // Mobile Screen Sizes //
            } else {
              return const Center(
                child: Text("Large"),
              );
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
        top: 6.h,
        left: 0,
        right: 0,
          child: _buildAppBar()
      ),
      Positioned(
          top: 100.h,
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBody()
      ),
    ]
    );
  }
                          // App Bar //
  Widget _buildAppBar(){
    return  AppBar(
      title: const Headingtext(
        text: "Dashboard",
        color: Colors.black,
        weight: FontWeight.w500,
      ),
      centerTitle: true,
    );
  }

                             // Body //
  Widget _buildBody(){
    return SizedBox(
      width: width.w,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if(storeUsername == username)
            Padding(
              padding:  EdgeInsets.all(8.0.w),
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<ChartData, String>(
                    color: Colors.blue,
                    dataSource: _chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    animationDuration: 2000, // Animation duration for pulsar effect
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            if(storeUsername != username)
              Padding(
                padding:  EdgeInsets.all(8.0.w),
                child: Container(
                  height: 200,
                  width: 340,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(15.r)
                  ),
                  child: const Center(child: Text('Employee Target')),
                )
              ),
            if(storeUsername == username)
            SizedBox(height: 10.h,),
            if(storeUsername == username)
            const Headingtext(text: "Sales Chart", color: Colors.black, weight: FontWeight.w500),
            const Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            SizedBox(height: 10.h,),
            const Headingtext(text: "Modules", color: Colors.black, weight: FontWeight.w500),
            SizedBox(height: 10.h,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.to(const ProformaInvoice());
                  },
                  child: Container(
                    height: height/6.4.h,
                    width: width/2.5.w,
                    decoration: BoxDecoration(
                      color: const Color(0xff75fbff),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 30.h,),
                        const Mytext(text: "Proforma Invoice", color: Colors.black),
                        SizedBox(height: 10.h,),
                        const Icon(Icons.align_vertical_center,color: Colors.black,)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.to(const Items());
                  },
                  child: Container(
                    height: height/6.4.h,
                    width: width/2.5.w,
                    decoration: BoxDecoration(
                        color: const Color(0xfffffcc1),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 30.h,),
                        const Mytext(text: "Items", color: Colors.black),
                        SizedBox(height: 10.h,),
                        const Icon(Icons.production_quantity_limits,color: Colors.black,)
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.h,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.to(const Purchaseorder());
                  },
                  child: Container(
                    height: height/6.4.h,
                    width: width/2.5.w,
                    decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 30.h,),
                        const Mytext(text: "Purchase Order", color: Colors.black),
                        SizedBox(height: 10.h,),
                        const Icon(Icons.safety_check,color: Colors.black,)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.to(const SalesInvoice());
                  },
                  child: Container(
                    height: height/6.4.h,
                    width: width/2.5.w,
                    decoration: BoxDecoration(
                        color: const Color(0xffd4ffe2),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 30.h,),
                        const Mytext(text: "Sales Invoice", color: Colors.black),
                        SizedBox(height: 10.h,),
                        const Icon(Icons.area_chart,color: Colors.black,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h,),
            GestureDetector(
              onTap: (){
                Get.to(const Purchaseinward());
              },
              child: Container(
                height: height/6.4.h,
                width: width/2.5.w,
                decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30.h,),
                    const Mytext(text: "Purchase Inward", color: Colors.black),
                    SizedBox(height: 10.h,),
                    const Icon(Icons.insert_chart_outlined,color: Colors.black,)
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h,),
          ],
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
