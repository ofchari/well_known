import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:well_known/Services/sales_api.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import '../Widgets/buttons.dart';

class View_Invoice extends StatefulWidget {
  final String? name;

  const View_Invoice({super.key, this.name});

  @override
  State<View_Invoice> createState() => _View_InvoiceState();
}

class _View_InvoiceState extends State<View_Invoice> with SingleTickerProviderStateMixin {
  late double height;
  late double width;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Sales> fetchSalesDetails(String name) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(
        Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Sales Invoice/$name'),
        headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
    if (response.statusCode == 200) {
      // Handle the responses //
      print(response.body);
      Map<String, dynamic> data = jsonDecode(response.body)['data'];
      return Sales.fromJson(data);
    } else {
      // error status code (404,500) //
      throw Exception("Failed to load data: ${response.statusCode}");
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
            ScreenUtil.init(context, designSize: Size(width, height), minTextAdapt: true);
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
                top: 20,
                left: 0,
                right: 0,
                child: _buildAppBar(),
              ),
              Positioned(
                top: 150,
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
      backgroundColor: Colors.white,
      leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      title: const Headingtext(
          text: "Sales Invoice", color: Colors.black, weight: FontWeight.w400),
      centerTitle: true,
      actions: [
        const Icon(
          Icons.home,
          color: Colors.black,
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
      child: FutureBuilder<Sales>(
          future: widget.name != null ? fetchSalesDetails(widget.name!) : Future.error("Name is null"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            Sales sales = snapshot.data!;
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
                          const SizedBox(height: 10),
                          Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:  EdgeInsets.all(8.0.w),
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
                              text: sales.name.toString(),
                              color: Colors.black),
                          const SizedBox(height: 5),
                          Mytext(
                              text:
                              "Customer : ${sales.customer.toString()
                                  .toString()}",
                              color: Colors.black),
                          const SizedBox(height: 5),
                          Mytext(
                              text:
                              "Company : ${sales.company.toString()}",
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
                                          text: sales.posting_date.toString(),
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
                                          text: sales.due_date.toString(),
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
                                          text: "Billing Person",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: sales.billing_person.toString(),
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
                                          text: "Customer Name",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: sales.customer_name.toString(),
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
                                  text: "Customer Address",
                                  color: Colors.black)),
                          const SizedBox(height: 5),
                          Center(
                              child: Mytext(
                                  text: sales.customer_address.toString(),
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
                                          text: "Billing Person GSTIN",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: sales.billing_address_gstin.toString(),
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
                                          text: "Delivery Mode",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: sales.delivery_mode.toString(),
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
                                          text: "Price List",
                                          color: Colors.black),
                                      const SizedBox(height: 8),
                                      FittedBox(
                                        child: Mytext(
                                            text: sales.selling_price_list.toString(),
                                            color: Colors.black),
                                      ),
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
                                          text: sales.mobile_no.toString(),
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
                          SizedBox(height: 20.h,),
                          TabBar(
                            controller: _tabController,
                            tabs: const [
                              Tab(text: 'Items'),
                              Tab(text: 'Taxes'),
                              Tab(text: 'HSN Tax'),
                              // Tab(text: 'Payment'),
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
                                            itemCount: sales.items!.length,
                                            itemBuilder: (context, index) {
                                              final item = sales.items?[index];
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
                                        itemCount: sales.taxes!.length,
                                        itemBuilder: (context, index) {
                                          final taxes = sales.taxes?[index];
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
                                        itemCount: sales.ts_tax_breakup_table!.length,
                                        itemBuilder: (context, index) {
                                          final tsTaxBreakupTable = sales.ts_tax_breakup_table?[index];
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
                                        itemCount: sales.payment_schedule!.length,
                                        itemBuilder: (context, index) {
                                          final paymentSchedule = sales.payment_schedule?[index];
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ]
              ),
            );
          }
        }
    ),
    );

          }
  }
     // Alert Popup message //
void alert (BuildContext,context){
  Alert(
      context: context,
      type: AlertType.warning,
      title: "Alert Message",style: AlertStyle(titleStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.green)),descStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.blue))),
      desc: "Are you sure want to Submit ",
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

