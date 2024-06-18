
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:well_known/Screens/invoice.dart';
import 'package:well_known/Services/proforma_api.dart';
import 'package:well_known/Utils/proforma_utils.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import '../Utils/refreshdata.dart';
import '../Widgets/heading_text.dart';
import 'new_proforma_voice.dart';


class ProformaInvoice extends StatefulWidget {
  const ProformaInvoice({super.key});

  @override
  State<ProformaInvoice> createState() => _ProformaInvoiceState();
}

class _ProformaInvoiceState extends State<ProformaInvoice> {
  late double height;
  late double width;
  String _searchTerm = '';

  @override
  void initState() {
    fetchProforma();
    super.initState();
  }

  var sales_person = '';

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
          )),
      title: const Headingtext(
          text: "     Proforma Invoice",
          color: Colors.black,
          weight: FontWeight.w500),
      centerTitle: true,
    );
  }

  // Body //
  Widget _buildBody() {
    return Stack(
      children: [
        SizedBox(
          width: width.w,
          child: Column(
            children: [
              SizedBox(height: 30.h,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: "Search Proforma Invoice",
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
              FutureBuilder<List<SalesOrder>>(
                future: fetchProforma(searchTerm: _searchTerm),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          SalesOrder proforma = snapshot.data![index];
                          return Padding(
                            padding: EdgeInsets.all(8.0.w),
                            child: Container(
                              height: height / 3.5.h,
                              width: width / 1.3.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.green, width: 1.2)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Subhead(
                                      text: proforma.name.toString(),
                                      colo: Colors.black,
                                      weight: FontWeight.w600),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Subhead(
                                      text: proforma.billingPerson.toString(),
                                      colo: Colors.black,
                                      weight: FontWeight.w300),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Mytext(
                                              text: " DATE :",
                                              color: Colors.black),
                                          Mytext(
                                              text:
                                              "${(((proforma.transactiondate.toString()).split('-')).toList())[2]}-${(((proforma.transactiondate.toString()).split('-')).toList())[1]}-${(((proforma.transactiondate.toString()).split('-')).toList())[0]}",
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
                                                "${(((proforma.deliveryDate.toString()).split('-')).toList())[2]}-${(((proforma.deliveryDate.toString()).split('-')).toList())[1]}-${(((proforma.deliveryDate.toString()).split('-')).toList())[0]}",
                                                color: Colors.black),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Mytext(
                                          text: "Bill Value",
                                          color: Colors.black),
                                      Mytext(
                                          text: proforma.base_total.toString(),
                                          color: Colors.green),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        sales_person = proforma.name.toString();
                                      });
                                      Get.to(Invoice(
                                          salesPerson: sales_person));
                                    },
                                    child: Container(
                                      height: height / 18.h,
                                      width: width / 1.3.w,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: const Center(
                                          child: Subhead(
                                            text: "View",
                                            colo: Colors.white,
                                            weight: FontWeight.w500,
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: SizedBox(
            height: 50.h,
            width: 50.w,
            child: FloatingActionButton(
              backgroundColor: const Color(0xff75fbff),
              onPressed: () {
                Get.to(const NewproformaVoice());
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
