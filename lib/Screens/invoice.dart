import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:well_known/Screens/home.dart';
import 'package:well_known/Services/sales_api.dart';
import 'package:well_known/Utils/proforma_utils.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:http/http.dart' as http;

import '../Services/proforma_api.dart';
import '../Widgets/heading_text.dart';

class Invoice extends StatefulWidget {
  final String salesPerson;
  const Invoice({super.key, required this.salesPerson});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> with SingleTickerProviderStateMixin {
  late double height;
  late double width;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<SalesOrder> fetchInvoice() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await http.get(
        Uri.parse(
            'https://erp.wellknownssyndicate.com/api/resource/Sales Order/${widget
                .salesPerson}'),
        headers: {
          "Authorization": "token c5a479b60dd48ad:d8413be73e709b6"
        });
    if (response.statusCode == 200) {
      print("Invoice data ${response.body}");

      var data = jsonDecode(response.body)['data'];
      return SalesOrder.fromJson(data);
    } else {
      throw Exception("Failed to load data : ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            ScreenUtil.init(context,
                designSize: Size(width, height), minTextAdapt: true);
            if (width <= 450) {
              return _smallBuildLayout();
            } else {
              return Text("Large");
            }
          },
        ),
      ),
    );
  }

  Widget _smallBuildLayout() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: _buildAppBar(),
              ),
              Positioned(
                top: 100,
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBody(),
              ),
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      title: Headingtext(
          text: "Invoice", color: Colors.black, weight: FontWeight.w400),
      centerTitle: true,
      actions: [
        Icon(
          Icons.home,
          color: Colors.black,
        ),
        Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return SizedBox(
      width: width.w,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder<SalesOrder>(
                future: fetchInvoice(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    SalesOrder invoices = snapshot.data!;
                    return Container(
                      padding: EdgeInsets.all(8.0.w),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.blue, width: 1.2)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Buttons(
                                        heigh: height / 18.h,
                                        width: width / 4.5.w,
                                        color: Colors.green,
                                        text: "Action",
                                        radius: BorderRadius.circular(26),
                                      ),
                                    )),
                                SizedBox(height: 5),
                                Subhead(
                                  text: "Sales Person",
                                  colo: Colors.black,
                                  weight: FontWeight.w500,
                                ),
                                SizedBox(height: 5),
                                Mytext(
                                    text: invoices.name.toString(),
                                    color: Colors.black),
                                SizedBox(height: 5),
                                Mytext(
                                    text:
                                    "Customer : ${invoices.customer
                                        .toString()}",
                                    color: Colors.black),
                                SizedBox(height: 5),
                                Mytext(
                                    text:
                                    "Company : ${invoices.company.toString()}",
                                    color: Colors.black),
                                SizedBox(height: 15),
                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 5),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Date",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.transactiondate
                                                    .toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                        thickness: 2,
                                        color: Colors.green,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Delivery Date",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.deliveryDate
                                                    .toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Divider(
                                  height: 2,
                                  thickness: 2,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 5),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Status",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.status
                                                    .toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                        thickness: 2,
                                        color: Colors.green,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Gst Category",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.gstcategory
                                                    .toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 2,
                                  thickness: 2,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 10),
                                Center(
                                    child: Mytext(
                                        text: "Customer Name",
                                        color: Colors.black)),
                                SizedBox(height: 5),
                                Center(
                                    child: Mytext(
                                        text: invoices.customerName.toString(),
                                        color: Colors.black)),
                                Divider(
                                  height: 2,
                                  thickness: 2,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 10),
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Billing Person",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.billingPerson
                                                    .toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                        thickness: 2,
                                        color: Colors.green,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Customer Group",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.customer_group
                                                    .toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Divider(
                                  height: 2,
                                  thickness: 2,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 5),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Contact owner",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.owner.toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                        thickness: 2,
                                        color: Colors.green,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Mobile No",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.contactnumber
                                                    .toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 2,
                                  thickness: 2,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 10),
                                Center(
                                    child: Mytext(
                                        text: "Contact Email",
                                        color: Colors.black)),
                                SizedBox(height: 2),
                                Center(
                                    child: Mytext(
                                        text: invoices.customeremail.toString(),
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          // Sales Container //
                          Container(
                            padding: EdgeInsets.all(8.0.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.green)),
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10),
                                            Mytext(
                                                text: "Project",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: "None",
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                        thickness: 2,
                                        color: Colors.green,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Mytext(
                                                  text: "Order Type",
                                                  color: Colors.black),
                                              SizedBox(height: 4),
                                              Mytext(
                                                  text: invoices.ordertype
                                                      .toString(),
                                                  color: Colors.black),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Divider(
                                  height: 2,
                                  thickness: 2,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 5),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Currency",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.currency
                                                    .toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                        thickness: 2,
                                        color: Colors.green,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Exchange Rate",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: "1.00",
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 2,
                                  thickness: 2,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 5),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Selling Price List",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.sellingpricelist
                                                    .toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                      VerticalDivider(
                                        thickness: 2,
                                        color: Colors.green,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Mytext(
                                                text: "Price List",
                                                color: Colors.black),
                                            SizedBox(height: 4),
                                            Mytext(
                                                text: invoices.pricelistcurrency
                                                    .toString(),
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
  //
  // Widget _buildTabBar() {
  //   return DefaultTabController(
  //     length: 4, // Update the length to match the number of tabs
  //     child: Column(
  //       children: [
  //         TabBar(
  //           tabs: [
  //             Mytext(text: "Items", color: Colors.black),
  //             Mytext(text: "Sales & taxes", color: Colors.black),
  //             Mytext(text: "Taxes Breakup", color: Colors.black), // Corrected spelling
  //             Mytext(text: "Payment", color: Colors.black),
  //           ],
  //         ),
  //         Expanded(
  //           child: TabBarView(
  //             children: [
  //               // Add your TabBarView children here
  //               // Example:
  //               Container(
  //                 child: Center(
  //                   child: Text('Items Content'),
  //                 ),
  //               ),
  //               Container(
  //                 child: Center(
  //                   child: Text('Sales & Taxes Content'),
  //                 ),
  //               ),
  //               Container(
  //                 child: Center(
  //                   child: Text('Taxes Breakup Content'),
  //                 ),
  //               ),
  //               Container(
  //                 child: Center(
  //                   child: Text('Payment Content'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
   }
