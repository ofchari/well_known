import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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
  String _searchTerm = '';
  List<Sales> _salesList = [];
  List<Sales> _filteredSalesList = [];

  @override
  void initState() {
    fetch();
    super.initState();
  }

  // Api's Response //
  Future<List<Sales>> fetch() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await http.get(
        Uri.parse(
            'https://erp.wellknownssyndicate.com/api/resource/Sales Invoice?fields=["name","sales_person","billing_person","attended_by","attended_person","company","branch","customer","attended_person","customer_address","posting_date","due_date","base_total"]&limit_page_length=50000'),
        headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
    if (response.statusCode == 200) {
      // Handle the responses //
      print(response.body);
      List<dynamic> data = jsonDecode(response.body)['data'];
      _salesList = data.map((e) => Sales.fromJson(e)).toList();
      _filteredSalesList = _salesList;
      setState(() {}); // Trigger rebuild to show data
      return _salesList;
    } else {
      // error status code (404,500) //
      throw Exception("Failed to load data : ${response.statusCode}");
    }
  }

  void _filterSales() {
    setState(() {
      if (_searchTerm.isEmpty) {
        _filteredSalesList = _salesList;
      } else {
        _filteredSalesList = _salesList
            .where((sales) =>
            sales.name!.toLowerCase().contains(_searchTerm.toLowerCase()))
            .toList();
      }
    });
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
            ScreenUtil.init(context,
                designSize: Size(width, height), minTextAdapt: true);
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
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                  _filterSales();
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                hintText: "Search SalesInvoice",
                hintStyle: GoogleFonts.dmSans(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          _salesList.isEmpty
              ? Column(
                children: [
                  const SizedBox(height: 200,),
                   const Center(child:SpinKitSpinningLines(color: Colors.blue,duration: Duration(seconds: 5),size: 80)),
                  SizedBox(height: 10.h,),
                ],
              )
              : Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _filteredSalesList.length,
              itemBuilder: (context, index) {
                Sales sales = _filteredSalesList[index];
                return Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Container(
                    height: height / 2.45.h,
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
                        Subhead(
                          text: sales.name.toString(),
                          colo: Colors.blue.shade900,
                          weight: FontWeight.w500,
                        ),
                        SizedBox(height: 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Subhead(
                                text: "Customer :",
                                colo: Colors.black,
                                weight: FontWeight.w500),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Mytext(
                                  text: sales.customer.toString(),
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Mytext(
                                    text: " DATE :",
                                    color: Colors.black),
                                Mytext(
                                    text:
                                    "${(((sales.posting_date.toString()).split('-')).toList())[2]}-${(((sales.posting_date.toString()).split('-')).toList())[1]}-${(((sales.posting_date.toString()).split('-')).toList())[0]}",
                                    color: Colors.black),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0.w),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Mytext(
                                      text: "Due Date :",
                                      color: Colors.black),
                                  Mytext(
                                      text:
                                      "${(((sales.due_date.toString()).split('-')).toList())[2]}-${(((sales.due_date.toString()).split('-')).toList())[1]}-${(((sales.due_date.toString()).split('-')).toList())[0]}",
                                      color: Colors.black),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        const Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            const Subhead(
                                text: "Billing Value",
                                colo: Colors.black,
                                weight: FontWeight.w500),
                            Mytext(
                                text: sales.base_total.toString(),
                                color: Colors.black),
                          ],
                        ),
                        const Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Subhead(
                                text: "Attended person",
                                colo: Colors.black,
                                weight: FontWeight.w500
                            ),
                            FittedBox(
                              child: Mytext(
                                  text: sales.attended_person.toString(),
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 17.h),
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
            ),
          ),
        ],
      ),
    );
  }
}
