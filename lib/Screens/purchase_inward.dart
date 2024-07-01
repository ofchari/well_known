import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:well_known/Screens/purchase_invoice.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';

import '../Services/purchase_api.dart';

class Purchaseinward extends StatefulWidget {
  const Purchaseinward({super.key});

  @override
  State<Purchaseinward> createState() => _PurchaseinwardState();
}

class _PurchaseinwardState extends State<Purchaseinward> {
  late double height;
  late double width;
  var suppli = '';

  @override
  void initState() {
    fetching();
    super.initState();
  }

  Future<List<PurchaseInvoice>> fetching() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await http.get(
        Uri.parse(
            'https://erp.wellknownssyndicate.com/api/resource/Purchase Invoice?fields=["name","supplier","supplier_gstin","posting_date","tax_id","company","rounded_total","status"]&limit_page_length=50000'),
        headers: {
          "Authorization": "token c5a479b60dd48ad:d8413be73e709b6"
        });
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((e) => PurchaseInvoice.fromJson(e)).toList();
    } else {
       throw Exception("Failed to fetch data");
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
            ScreenUtil.init(
              context,
              designSize: Size(width, height),
              minTextAdapt: true,
            );
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
    return Stack(
      children: [
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
          bottom: 0, // Added bottom: 0 to expand till the bottom
          child: _buildBody(),
        ),
      ],
    );
  }

                                // App Bar //
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
        ),
      ),
      title: const Headingtext(
        text: "Purchase Inward",
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
      child: FutureBuilder<List<PurchaseInvoice>>(
        future: fetching(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                PurchaseInvoice purchase = snapshot.data![index];
                return
                  Padding(
                    padding:  EdgeInsets.all(8.0.w),
                    child: Container(
                      height: height / 2.2.h,
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
                            text: purchase.supplier.toString(),
                            colo: Colors.blue.shade900,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(height: 30.h),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Subhead(
                                  text: "Company :",
                                  colo: Colors.black,
                                  weight: FontWeight.w500),
                              FittedBox(
                                child: Mytext(
                                    text: purchase.company.toString(),
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(left: ScreenUtil().setWidth(100.0)),
                                child: Row(
                                  children: [
                                    const Mytext(
                                        text: " DATE :",
                                        color: Colors.black),
                                    Mytext(
                                        text: purchase.postingDate
                                            .toString(),
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Subhead(
                                  text: "Supplier GST",
                                  colo: Colors.black,
                                  weight: FontWeight.w500),
                              Mytext(
                                  text: purchase.supplierGstin.toString(),
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
                                  text: "Billing Amount",
                                  colo: Colors.black,
                                  weight: FontWeight.w500
                              ),
                              FittedBox(
                                child: Mytext(
                                    text: purchase.rounded_total.toString(),
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Subhead(
                                  text: "Status",
                                  colo: Colors.black,
                                  weight: FontWeight.w500),
                              Mytext(
                                  text: purchase.status.toString(),
                                  color: Colors.black),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          GestureDetector(
                            onTap: () {
                              print(purchase.name.toString());
                              print(purchase.supplier.toString());
                              print(purchase.supplierGstin.toString());
                              print(purchase);

                              Get.to(
                                  PurchaseInvoicess(purchaseInvoice: purchase,));
                            },
                            child: Buttons(
                              heigh: height / 22.h,
                              width: width / 1.4.w,
                              color: Colors.blue,
                              text: "View",
                              radius: BorderRadius.circular(10),
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
              }
              );
          }
        },
    ),
    );
  }
}