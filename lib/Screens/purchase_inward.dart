import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:well_known/Utils/purchase_utils.dart';
import 'package:well_known/Utils/refreshdata.dart';
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

  @override
  void initState() {
    fetching();
    super.initState();
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
              return Text("Large");
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
      // toolbarHeight: 100,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: Headingtext(
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                PurchaseInvoice purchase = snapshot.data![index];
                return Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Container(
                    height: height / 4.5.h,
                    width: width / 1.1.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 1.5.w,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Subhead(
                              text: purchase.supplier.toString(),
                              colo: Colors.lightBlue.shade400,
                              weight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Subhead(
                              text: "Company",
                              colo: Colors.green,
                              weight: FontWeight.w500,
                            ),
                            Mytext(
                              text: purchase.company.toString(),
                              color: Colors.black,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Subhead(
                              text: "Supplier Gst",
                              colo: Colors.green,
                              weight: FontWeight.w500,
                            ),
                            Mytext(
                              text: purchase.supplierGstin.toString(),
                              color: Colors.black,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Subhead(
                              text: "Posting date",
                              colo: Colors.green,
                              weight: FontWeight.w500,
                            ),
                            Mytext(
                              text: purchase.postingDate.toString(),
                              color: Colors.black,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Subhead(
                              text: "Tax Id",
                              colo: Colors.green,
                              weight: FontWeight.w500,
                            ),
                            Mytext(
                              text: purchase.taxId.toString(),
                              color: Colors.black,
                            ),
                          ],
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
