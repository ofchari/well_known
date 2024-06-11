import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:well_known/Screens/sales_invoiceee.dart';

import '../Services/sales_api.dart';
import '../Utils/refreshdata.dart';
import '../Widgets/buttons.dart';
import '../Widgets/heading_text.dart';
import '../Widgets/subhead.dart';
import '../Widgets/text.dart';

class SalesInvoice extends StatefulWidget {
  const SalesInvoice({super.key});

  @override
  State<SalesInvoice> createState() => _SalesInvoiceState();
}

class _SalesInvoiceState extends State<SalesInvoice> {
  late double height;
  late double width;

  @override
  void initState() {
    fetch();
    super.initState();
  }
  var sales_persons = '';

  // Api's Response //
  Future<List<Sales>> fetch() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await http.get(
        Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Sales Invoice?fields=["name","sales_person","billing_person","attended_by","attended_person","company","branch","customer","attended_person","customer_address","posting_date","due_date"]'),
        headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
    if (response.statusCode == 200) {
      // Handle the responses //
      print(response.body);
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((e) => Sales.fromJson(e)).toList();
    } else {
      // error status code (404,500) //
      throw Exception("Failed to load data : ${response.statusCode}");
    }
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
              // Mobile Screen Sizes //
            } else {
              return const Text("Large");
            }
          },
        ),
      ),
    );
  }

  Widget _smallBuildLayout() {
    return Stack(children: [
      Positioned(
        top: 26.h,
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
    ]);
  }

  // App Bar //
  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      // toolbarHeight: 100,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: const Headingtext(
        text: "Sales Invoice",
        color: Colors.black,
        weight: FontWeight.w500,
      ),
      centerTitle: true,
    );
  }

  // Body //
  Widget _buildBody() {
    return SizedBox(
      width: width.w,
      child: FutureBuilder<List<Sales>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Sales sales = snapshot.data![index];
                return Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Container(
                    height: height / 2.8.h,
                    width: width / 1.1.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Subhead(text: "Sales Person", colo: Colors.green, weight: FontWeight.w500),
                            Subhead(
                              text: sales.name.toString(),
                              colo: Colors.blue.shade900,
                              weight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Subhead(
                                text: "Billing Person",
                                colo: Colors.blue,
                                weight: FontWeight.w500),
                            Mytext(
                                text: sales.billing_person.toString(),
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Subhead(
                                text: "Attended by",
                                colo: Colors.blue,
                                weight: FontWeight.w500),
                            Mytext(
                                text: sales.attended_by.toString(),
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Subhead(
                                text: "Attended person",
                                colo: Colors.blue,
                                weight: FontWeight.w500),
                            Mytext(
                                text: sales.attended_person.toString(),
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Subhead(
                                text: "Company",
                                colo: Colors.blue,
                                weight: FontWeight.w500),
                            Mytext(
                                text: sales.company.toString(),
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Subhead(
                                text: "Branch",
                                colo: Colors.blue,
                                weight: FontWeight.w500),
                            Mytext(
                                text: sales.branch.toString(),
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Subhead(
                                text: "Customer",
                                colo: Colors.blue,
                                weight: FontWeight.w500),
                            Mytext(
                                text: sales.customer.toString(),
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            Get.to(View_Invoice(name: sales.name));
                          },
                          child: Buttons(
                            heigh: height / 22.h,
                            width: width / 1.3.w,
                            color: Colors.blue,
                            text: "View",
                            radius: BorderRadius.circular(15.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
