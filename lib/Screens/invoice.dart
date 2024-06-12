import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:http/http.dart' as http;

import '../Services/proforma_api.dart';
import '../Widgets/heading_text.dart';
import 'package:url_launcher/url_launcher.dart';

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



  Future<void> invoice_print() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    final response = await ioClient.get(
      Uri.parse(
          'https://erp.wellknownssyndicate.com/api/method/frappe.utils.print_format.download_pdf?doctype=Sales%20Order&name=WKS-PI-0624-00262&format=PIC%20PDF&no_letterhead=0&letterhead=WKS%20Letter%20Head%201&settings=%7B%7D&_lang=en-US'),
      headers: {
        "Authorization": "token c5a479b60dd48ad:d8413be73e709b6"
      },
    );

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/invoice.pdf');
      await file.writeAsBytes(response.bodyBytes);

      final url = file.path;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print("doesn't print ");
        throw Exception('Could not launch $url');
      }
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
              return const Text("Large");
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
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      title: const Headingtext(
          text: "Invoice", color: Colors.black, weight: FontWeight.w400),
      centerTitle: true,
      actions: [
        Padding(
          padding:  EdgeInsets.all(8.0.w),
          child: const Icon(
            Icons.home,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: (){invoice_print();},
          child:  Padding(
            padding:  EdgeInsets.all(8.0.w),
            child: const Icon(
              Icons.print,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0.w),
          child: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child:
      FutureBuilder<SalesOrder>(
          future: fetchInvoice(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              SalesOrder invoices = snapshot.data!;
              return
                Container(
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
                          const SizedBox(height: 10),
                          Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: (){
                                    alert(BuildContext, context);
                                  },
                                  child: Buttons(
                                    heigh: height / 18.h,
                                    width: width / 4.5.w,
                                    color: Colors.blue,
                                    text: "Action",
                                    radius: BorderRadius.circular(26),
                                  ),
                                ),
                              )),
                          const SizedBox(height: 5),
                          const Subhead(
                            text: "Sales Person",
                            colo: Colors.black,
                            weight: FontWeight.w500,
                          ),
                          const SizedBox(height: 5),
                          Mytext(
                              text: invoices.name.toString(),
                              color: Colors.black),
                          const SizedBox(height: 5),
                          Mytext(
                              text:
                              "Customer : ${invoices.customer
                                  .toString()}",
                              color: Colors.black),
                          const SizedBox(height: 5),
                          Mytext(
                              text:
                              "Company : ${invoices.company.toString()}",
                              color: Colors.black),
                          const SizedBox(height: 15),
                          const Divider(
                            height: 1,
                            thickness: 2,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 5),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Date",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: invoices.transactiondate
                                              .toString(),
                                          color: Colors.black),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(
                                  thickness: 2,
                                  color: Colors.blue,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Delivery Date",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
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
                          const SizedBox(height: 10),
                          const Divider(
                            height: 2,
                            thickness: 2,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 5),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Status",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: invoices.status
                                              .toString(),
                                          color: Colors.black),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(
                                  thickness: 2,
                                  color: Colors.blue,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Gst Category",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
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
                          const Divider(
                            height: 2,
                            thickness: 2,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 10),
                          const Center(
                              child: Mytext(
                                  text: "Customer Name",
                                  color: Colors.black)),
                          const SizedBox(height: 5),
                          Center(
                              child: Mytext(
                                  text: invoices.customerName.toString(),
                                  color: Colors.black)),
                          const Divider(
                            height: 2,
                            thickness: 2,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 10),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Billing Person",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: invoices.billingPerson
                                              .toString(),
                                          color: Colors.black),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(
                                  thickness: 2,
                                  color: Colors.blue,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Customer Group",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
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
                          const SizedBox(height: 10),
                          const Divider(
                            height: 2,
                            thickness: 2,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 5),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Contact owner",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: invoices.owner.toString(),
                                          color: Colors.black),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(
                                  thickness: 2,
                                  color: Colors.blue,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Mobile No",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
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
                          const Divider(
                            height: 2,
                            thickness: 2,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 10),
                          const Center(
                              child: Mytext(
                                  text: "Contact Email",
                                  color: Colors.black)),
                          const SizedBox(height: 2),
                          Center(
                              child: Mytext(
                                  text: invoices.customeremail.toString(),
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Sales Container //
                    Container(
                      padding: EdgeInsets.all(8.0.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue)),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                const Expanded(
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
                                const VerticalDivider(
                                  thickness: 2,
                                  color: Colors.blue,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Mytext(
                                            text: "Order Type",
                                            color: Colors.black),
                                        const SizedBox(height: 4),
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
                          const SizedBox(height: 10),
                          const Divider(
                            height: 2,
                            thickness: 2,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 5),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Currency",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: invoices.currency
                                              .toString(),
                                          color: Colors.black),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(
                                  thickness: 2,
                                  color: Colors.blue,
                                ),
                                const Expanded(
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
                          const Divider(
                            height: 2,
                            thickness: 2,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 5),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Selling Price List",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: invoices.sellingpricelist
                                              .toString(),
                                          color: Colors.black),
                                    ],
                                  ),
                                ),
                                const VerticalDivider(
                                  thickness: 2,
                                  color: Colors.blue,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Price List",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
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
                      tabs: const [
                        Tab(text: 'Items'),
                        Tab(text: 'Taxes'),
                        Tab(text: 'HSN Tax'),
                        Tab(text: 'Payment'),
                      ],
                    ),
                    const SizedBox(height: 40,),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
                        child: TabBarView(
                            controller: _tabController,
                            children: [SingleChildScrollView(
                          child: Column(
                            children: [
                              // ITEMS //
                              Container(
                                // height: 3000.h, // Set a fixed height here or calculate dynamically based on the items count
                                child:
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: invoices.items!.length,
                                  itemBuilder: (context, index) {
                                    final item = invoices.items?[index];
                                    return Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blue, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Item Name',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${item['item_code']}',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Row #${item['idx']}',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'HSN: ${item['gst_hsn_code']}',
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Quantity:',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${item['qty']}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Rate:',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${item['rate']}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Amount:',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${item['amount']}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                          const Divider(),
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Discount:',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${item['discount_amount']}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'GST:',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${item['gst_per']}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Uom:',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${item['uom']}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                         // Taxes //
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: invoices.taxes!.length,
                            itemBuilder: (context, index) {
                              final taxes = invoices.taxes?[index];
                              return Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'TYPE',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${taxes['charge_type']}',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const Divider(),
                                    SizedBox(height: 8.h),
                                    IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'ACC-HEAD:',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${taxes['account_head']}',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'RATE :',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${taxes['rate']}',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Tax_Amount:',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${taxes['tax_amount']}',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Total:',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${taxes['total']}',
                                                    style: GoogleFonts.poppins(
                                                      textStyle: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
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

                        // HSN - TAX //
                              Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: invoices.ts_tax_breakup_table!.length,
                                  itemBuilder: (context, index) {
                                    final tsTaxBreakupTable = invoices.ts_tax_breakup_table?[index];
                                    return Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          Text(
                                            'HSN',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${tsTaxBreakupTable['ts_gst_hsn']}',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const Divider(),
                                          SizedBox(height: 8.h),
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
                                                          'RATE:',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${tsTaxBreakupTable['ts_gst_rate']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'TAXABLE:',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${tsTaxBreakupTable['ts_taxable_values']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  thickness: 1,
                                                ),

                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 15.h,),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Text(
                                          //       'RATE ${ts_tax_breakup_table['ts_gst_rate']}',
                                          //       style: GoogleFonts.poppins(
                                          //         textStyle: TextStyle(
                                          //           fontSize: 15,
                                          //           fontWeight: FontWeight.w500,
                                          //           color: Colors.black,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     Text(
                                          //       'TAXABLE: ${ts_tax_breakup_table['ts_taxable_values']}',
                                          //       style: GoogleFonts.poppins(
                                          //         textStyle: TextStyle(
                                          //           fontSize: 14,
                                          //           fontWeight: FontWeight.w500,
                                          //           color: Colors.grey,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),

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
                                                          'CGST_TAX:',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${tsTaxBreakupTable['ts_central_tax']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'CGST_AMOUNT:',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${tsTaxBreakupTable['ts_central_amount']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
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
                                          SizedBox(height: 10.h,),
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
                                                          'SGST_TAX:',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${tsTaxBreakupTable['ts_state_tax']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'SGST_AMOUNT:',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${tsTaxBreakupTable['ts_state_amount']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  thickness: 1,
                                                ),

                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10.h,),
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
                                                          'IGST_TAX:',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${tsTaxBreakupTable['ts_igst_tax']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'IGST_AMOUNT:',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${tsTaxBreakupTable['ts_igst_amount']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const Divider(
                                                  thickness: 1,
                                                ),

                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 1,
                                          ),
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Subhead(text: "Total", colo: Colors.black, weight: FontWeight.w500),
                                              Mytext(text: '${tsTaxBreakupTable['ts_total_tax_amount']}', color: Colors.black)
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Payment Term //
                              Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: invoices.payment_schedule!.length,
                                  itemBuilder: (context, index) {
                                    final paymentSchedule = invoices.payment_schedule?[index];
                                    return Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          Text(
                                            'PAYMENT TERM',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${paymentSchedule['payment_term']}',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 8),
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
                                                          'DESCRIPTION :',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${paymentSchedule['description']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'DUE-DATE :',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${paymentSchedule['due_date']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
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
                                          SizedBox(height: 15.h,),

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
                                                          'INVOICE-PORTION :',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${paymentSchedule['invoice_portion']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const VerticalDivider(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Container(

                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'PAYMENT_AMOUNT:',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${paymentSchedule['payment_amount']}',
                                                          style: GoogleFonts.poppins(
                                                            textStyle: const TextStyle(
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


                            ]
                        )
                    )

                ]
                ),
              );
            }
          }),
    );
  }

}

void alert (BuildContext,context){
  Alert(
      context: context,
    type: AlertType.warning,
    title: "Alert Message",style: AlertStyle(titleStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.green)),descStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.blue))),
    desc: "Are you sure want to Submit",
    buttons: [
      DialogButton(
        color: Colors.grey.shade200,
          child: const Mytext(text: "Yes", color: Colors.blue),
          onPressed: (){
            Navigator.pop(context);
          }
      ),
      DialogButton(
        color: Colors.grey.shade200,
          child: GestureDetector(
            onTap: (){
              Get.back();
            },
              child: const Mytext(text: "No", color: Colors.red)),
          onPressed: (){
            Navigator.pop(context);
          }
      )
    ]

  ).show();
}






