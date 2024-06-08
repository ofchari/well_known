import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return SingleChildScrollView(
      child: FutureBuilder<SalesOrder>(
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
                                  color: Colors.blue,
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
                            color: Colors.blue,
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
                                  color: Colors.blue,
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
                            color: Colors.blue,
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
                                  color: Colors.blue,
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
                            color: Colors.blue,
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
                            color: Colors.blue,
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
                                  color: Colors.blue,
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
                            color: Colors.blue,
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
                                  color: Colors.blue,
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
                            color: Colors.blue,
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
                          border: Border.all(color: Colors.blue)),
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
                                  color: Colors.blue,
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
                            color: Colors.blue,
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
                                  color: Colors.blue,
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
                            color: Colors.blue,
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
                                  color: Colors.blue,
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
                    SizedBox(height: 20.h,),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: 'Items'),
                        Tab(text: 'Taxes'),
                        Tab(text: 'HSN Tax'),
                        Tab(text: 'Payment'),
                      ],
                    ),
                    SizedBox(height: 40,),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
                        child: TabBarView(
                            controller: _tabController,
                            children: [SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // height: 3000.h, // Set a fixed height here or calculate dynamically based on the items count
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: invoices.items!.length,
                      itemBuilder: (context, index) {
                        final item = invoices.items?[index];
                        return Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Text(
                                'Item Name',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                '${item['item_code']}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Divider(),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Row #${item['idx']}',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'HSN: ${item['gst_hsn_code']}',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Container(

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Quantity:',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${item['qty']}',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Container(

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Rate:',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${item['rate']}',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Amount:',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${item['amount']}',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Container(

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Discount:',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${item['discount_amount']}',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Container(

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'GST:',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${item['gst_per']}',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Uom:',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${item['uom']}',
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      // physics: NeverScrollableScrollPhysics(),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue,
                                width: 2
                            ),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: DataTable(
                          headingTextStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.grey)),
                          columns: <DataColumn>[
                            DataColumn(label: Text('TYPE')),
                            DataColumn(label: Text('ACC_HEAD')),
                            DataColumn(label: Text('RATE')),
                            DataColumn(label: Text('AMOUNT')),
                            DataColumn(label: Text('TOTAL')),
                          ],
                          rows: (invoices.taxes)!.map((item) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(item['charge_type'],style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['account_head'],style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['rate'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['tax_amount'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['total'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),

                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue,
                                width: 2
                            ),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: DataTable(
                          headingTextStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.grey)),
                          columns: <DataColumn>[
                            DataColumn(label: Text('GST')),
                            DataColumn(label: Text('RATE')),
                            DataColumn(label: Text('TAXABLE')),
                            DataColumn(label: Text('CGST_Tax')),
                            DataColumn(label: Text('CGST_Amount')),
                            DataColumn(label: Text('SGST_Tax')),
                            DataColumn(label: Text('SGST_Tax')),
                            DataColumn(label: Text('IGST_Tax')),
                            DataColumn(label: Text('IGST_Tax')),
                            DataColumn(label: Text('TotalAmount')),
                          ],
                          rows: invoices.ts_tax_breakup_table!.map((item) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(item['ts_gst_hsn'] ,style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['ts_gst_rate'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)), )),
                                DataCell(Text(item['ts_taxable_values'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['ts_central_tax'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['ts_central_amount'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['ts_state_tax'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['ts_state_amount'].toString())),
                                DataCell(Text(item['ts_igst_tax'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['ts_igst_amount'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['ts_total_tax_amount'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue,
                                width: 2
                            ),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: DataTable(
                          headingTextStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.grey)),
                          columns: <DataColumn>
                          [
                            DataColumn(label: Text('PAYMENT_TERM',)),
                            DataColumn(label: Text('DESCRIPTION')),
                            DataColumn(label: Text('DUE_DATE')),
                            DataColumn(label: Text('INVOICE_PORTION')),
                            DataColumn(label: Text('PAYMENT_AMOUNT')),

                          ],
                          rows: invoices.payment_schedule!.map((item) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(item['payment_term'],style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)), )),
                                DataCell(Text(item['description'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)), )),
                                DataCell(Text(item['due_date'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['invoice_portion'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                                DataCell(Text(item['payment_amount'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),

                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),]))

                ]
                ),
              );
            }
          }),
    );
  }

}



                  // DefaultTabController(
                  //   length: 4, // Number of tabs
                  //   child: Column(
                  //     children: [
                  //       SizedBox(height: 20.h),
                  //       TabBar(
                  //         tabs: [
                  //           Tab(text: 'Items'),
                  //           Tab(text: 'Tax Charges'),
                  //           Tab(text: 'Breakup'),
                  //           Tab(text: 'Payment'),
                  //         ],
                  //       ),
                  //       Expanded(
                  //         child: Container(
                  //           constraints: BoxConstraints.expand(),
                  //           child:
                  //           TabBarView(
                  //             children: [
                  //               SingleChildScrollView(
                  //                 child: Column(
                  //                   children: [
                  //                     Container(
                  //                       // height: 3000.h, // Set a fixed height here or calculate dynamically based on the items count
                  //                       child: ListView.builder(
                  //                         shrinkWrap: true,
                  //                         physics: NeverScrollableScrollPhysics(),
                  //                         itemCount: invoices.items!.length,
                  //                         itemBuilder: (context, index) {
                  //                           final item = invoices.items?[index];
                  //                           return Container(
                  //                             margin: EdgeInsets.all(8),
                  //                             padding: EdgeInsets.all(8),
                  //                             decoration: BoxDecoration(
                  //                               border: Border.all(color: Colors.blue, width: 2),
                  //                               borderRadius: BorderRadius.circular(15),
                  //                             ),
                  //                             child: Column(
                  //                               crossAxisAlignment: CrossAxisAlignment.center,
                  //                               children: [
                  //
                  //                                 Text(
                  //                                   'Item Name',
                  //                                   style: GoogleFonts.poppins(
                  //                                     textStyle: TextStyle(
                  //                                       fontSize: 14,
                  //                                       fontWeight: FontWeight.w500,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                                 Text(
                  //                                   '${item['item_code']}',
                  //                                   style: GoogleFonts.poppins(
                  //                                     textStyle: TextStyle(
                  //                                       fontSize: 14,
                  //                                       fontWeight: FontWeight.w500,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                                 Divider(),
                  //                                 SizedBox(height: 8),
                  //                                 Row(
                  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                                   children: [
                  //                                     Text(
                  //                                       'Row #${item['idx']}',
                  //                                       style: GoogleFonts.poppins(
                  //                                         textStyle: TextStyle(
                  //                                           fontSize: 15,
                  //                                           fontWeight: FontWeight.w500,
                  //                                           color: Colors.grey,
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     Text(
                  //                                       'HSN: ${item['gst_hsn_code']}',
                  //                                       style: GoogleFonts.poppins(
                  //                                         textStyle: TextStyle(
                  //                                           fontSize: 14,
                  //                                           fontWeight: FontWeight.w500,
                  //                                           color: Colors.grey,
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //
                  //                                 IntrinsicHeight(
                  //                                   child: Row(
                  //                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                                     children: [
                  //                                       Expanded(
                  //                                         child: Container(
                  //
                  //                                           child: Column(
                  //                                             crossAxisAlignment: CrossAxisAlignment.center,
                  //                                             children: [
                  //                                               Text(
                  //                                                 'Quantity:',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                               Text(
                  //                                                 '${item['qty']}',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.w500,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                       VerticalDivider(
                  //                                         width: 5,
                  //                                       ),
                  //                                       Expanded(
                  //                                         child: Container(
                  //
                  //                                           child: Column(
                  //                                             crossAxisAlignment: CrossAxisAlignment.center,
                  //                                             children: [
                  //                                               Text(
                  //                                                 'Rate:',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                               Text(
                  //                                                 '${item['rate']}',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.w500,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                       VerticalDivider(
                  //                                         width: 5,
                  //                                       ),
                  //                                       Expanded(
                  //                                         child: Container(
                  //                                           child: Column(
                  //                                             crossAxisAlignment: CrossAxisAlignment.center,
                  //                                             children: [
                  //                                               Text(
                  //                                                 'Amount:',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                               Text(
                  //                                                 '${item['amount']}',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.w500,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                     ],
                  //                                   ),
                  //                                 ),
                  //                                 Divider(),
                  //                                 IntrinsicHeight(
                  //                                   child: Row(
                  //                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                                     children: [
                  //                                       Expanded(
                  //                                         child: Container(
                  //
                  //                                           child: Column(
                  //                                             crossAxisAlignment: CrossAxisAlignment.center,
                  //                                             children: [
                  //                                               Text(
                  //                                                 'Discount:',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                               Text(
                  //                                                 '${item['discount_amount']}',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.w500,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                       VerticalDivider(
                  //                                         width: 5,
                  //                                       ),
                  //                                       Expanded(
                  //                                         child: Container(
                  //
                  //                                           child: Column(
                  //                                             crossAxisAlignment: CrossAxisAlignment.center,
                  //                                             children: [
                  //                                               Text(
                  //                                                 'GST:',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                               Text(
                  //                                                 '${item['gst_per']}',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.w500,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                       VerticalDivider(
                  //                                         width: 5,
                  //                                       ),
                  //                                       Expanded(
                  //                                         child: Container(
                  //                                           child: Column(
                  //                                             crossAxisAlignment: CrossAxisAlignment.center,
                  //                                             children: [
                  //                                               Text(
                  //                                                 'Uom:',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                               Text(
                  //                                                 '${item['uom']}',
                  //                                                 style: GoogleFonts.poppins(
                  //                                                   textStyle: TextStyle(
                  //                                                     fontSize: 14,
                  //                                                     fontWeight: FontWeight.w500,
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                     ],
                  //                                   ),
                  //                                 ),
                  //
                  //                               ],
                  //                             ),
                  //                           );
                  //                         },
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               SingleChildScrollView(
                  //                 child: Column(
                  //                   children: [
                  //                     SingleChildScrollView(
                  //                       scrollDirection: Axis.horizontal,
                  //                       // physics: NeverScrollableScrollPhysics(),
                  //                       child: Container(
                  //                         decoration: BoxDecoration(
                  //                             border: Border.all(
                  //                                 color: Colors.blue,
                  //                                 width: 2
                  //                             ),
                  //                             borderRadius: BorderRadius.circular(15)
                  //                         ),
                  //                         child: DataTable(
                  //                           headingTextStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.grey)),
                  //                           columns: <DataColumn>[
                  //                             DataColumn(label: Text('TYPE')),
                  //                             DataColumn(label: Text('ACC_HEAD')),
                  //                             DataColumn(label: Text('RATE')),
                  //                             DataColumn(label: Text('AMOUNT')),
                  //                             DataColumn(label: Text('TOTAL')),
                  //                           ],
                  //                           rows: (invoices.taxes)!.map((item) {
                  //                             return DataRow(
                  //                               cells: <DataCell>[
                  //                                 DataCell(Text(item['charge_type'],style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['account_head'],style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['rate'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['tax_amount'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['total'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //
                  //                               ],
                  //                             );
                  //                           }).toList(),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               SingleChildScrollView(
                  //                 child: Column(
                  //                   children: [
                  //                     SingleChildScrollView(
                  //                       scrollDirection: Axis.horizontal,
                  //                       child: Container(
                  //                         decoration: BoxDecoration(
                  //                             border: Border.all(
                  //                                 color: Colors.blue,
                  //                                 width: 2
                  //                             ),
                  //                             borderRadius: BorderRadius.circular(15)
                  //                         ),
                  //                         child: DataTable(
                  //                           headingTextStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.grey)),
                  //                           columns: <DataColumn>[
                  //                             DataColumn(label: Text('GST')),
                  //                             DataColumn(label: Text('RATE')),
                  //                             DataColumn(label: Text('TAXABLE')),
                  //                             DataColumn(label: Text('CGST_Tax')),
                  //                             DataColumn(label: Text('CGST_Amount')),
                  //                             DataColumn(label: Text('SGST_Tax')),
                  //                             DataColumn(label: Text('SGST_Tax')),
                  //                             DataColumn(label: Text('IGST_Tax')),
                  //                             DataColumn(label: Text('IGST_Tax')),
                  //                             DataColumn(label: Text('TotalAmount')),
                  //                           ],
                  //                           rows: invoices.ts_tax_breakup_table!.map((item) {
                  //                             return DataRow(
                  //                               cells: <DataCell>[
                  //                                 DataCell(Text(item['ts_gst_hsn'] ,style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['ts_gst_rate'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)), )),
                  //                                 DataCell(Text(item['ts_taxable_values'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['ts_central_tax'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['ts_central_amount'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['ts_state_tax'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['ts_state_amount'].toString())),
                  //                                 DataCell(Text(item['ts_igst_tax'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['ts_igst_amount'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['ts_total_tax_amount'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                               ],
                  //                             );
                  //                           }).toList(),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               SingleChildScrollView(
                  //                 child: Column(
                  //                   children: [
                  //                     SingleChildScrollView(
                  //                       scrollDirection: Axis.horizontal,
                  //                       child: Container(
                  //                         decoration: BoxDecoration(
                  //                             border: Border.all(
                  //                                 color: Colors.blue,
                  //                                 width: 2
                  //                             ),
                  //                             borderRadius: BorderRadius.circular(15)
                  //                         ),
                  //                         child: DataTable(
                  //                           headingTextStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.grey)),
                  //                           columns: <DataColumn>
                  //                           [
                  //                             DataColumn(label: Text('PAYMENT_TERM',)),
                  //                             DataColumn(label: Text('DESCRIPTION')),
                  //                             DataColumn(label: Text('DUE_DATE')),
                  //                             DataColumn(label: Text('INVOICE_PORTION')),
                  //                             DataColumn(label: Text('PAYMENT_AMOUNT')),
                  //
                  //                           ],
                  //                           rows: invoices.payment_schedule!.map((item) {
                  //                             return DataRow(
                  //                               cells: <DataCell>[
                  //                                 DataCell(Text(item['payment_term'],style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)), )),
                  //                                 DataCell(Text(item['description'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)), )),
                  //                                 DataCell(Text(item['due_date'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['invoice_portion'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //                                 DataCell(Text(item['payment_amount'].toString(),style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black)),)),
                  //
                  //                               ],
                  //                             );
                  //                           }).toList(),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),


