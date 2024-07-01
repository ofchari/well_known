import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:path/path.dart' as path;

// Json Api For PurchaseOrder //
class PurchaseInvoice {
  final String? name;
  final String? supplier;
  final String? supplierGstin;
  final String? postingDate;
  final String? taxId;
  final String? gst_category;
  final String? schedule_date;
  final String? contact;
  final String? status;
  final String? company;
  final double? grand_total;
  final double? rounding_adjustment;
  final double? rounded_total;
  final String? in_words;
  final List? items;
  final List? taxes;
  final List? payment_schedule;

  PurchaseInvoice({
    required this.name,
    required this.supplier,
    required this.supplierGstin,
    required this.postingDate,
    required this.taxId,
    required this.gst_category,
    required this.schedule_date,
    required this.contact,
    required this.status,
    required this.company,
    required this.grand_total,
    required this.rounding_adjustment,
    required this.rounded_total,
    required this.in_words,
    required this.items,
    required this.taxes,
    required this.payment_schedule,
  });

  // Factory constructor to create a PurchaseInvoice from JSON
  factory PurchaseInvoice.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoice(
      name: json['name'] as String?,
      supplier: json['supplier'] as String?,
      supplierGstin: json['supplier_gstin'] as String?,
      postingDate: json['transaction_date'] as String?,
      taxId: json['workflow_state'] as String?,
      gst_category: json['supplier_gstin'] as String?,
      schedule_date: json['schedule_date'] as String?,
      contact: json['contact'] as String?,
      status: json['status'] as String?,
      company: json['company'] as String?,
      grand_total: json['grand_total'] as double?,
      rounding_adjustment: json['rounding_adjustment'] as double?,
      rounded_total: json['rounded_total'] as double?,
      in_words: json['in_words'] as String?,
      items: json['items'] as List?,
      taxes: json['taxes'] as List?,
      payment_schedule: json['payment_schedule'] as List?,
    );
  }
}

class Purchaseorder extends StatefulWidget {
  const Purchaseorder({super.key});

  @override
  State<Purchaseorder> createState() => purchaseOrder();
}

class purchaseOrder extends State<Purchaseorder> {
  late double height;
  late double width;
  var suppli = '';
  String _searchTerm = '';
  final List<PurchaseInvoice> _purchaseorder = [];

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
            'https://erp.wellknownssyndicate.com/api/resource/Purchase%20Order?fields=[%22name%22,%22supplier%22,%22supplier_gstin%22,%22transaction_date%22,%22workflow_state%22,%22company%22,"rounded_total","schedule_date"]&limit_page_length=50000'),
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

                 // Color change based upon the Word //
  Color _getBackgroundColor(String taxId) {
    switch (taxId) {
      case 'Initiated':
        return Colors.grey;
      case 'Approved':
        return Colors.orange.shade600;
      case 'Authorized':
        return Colors.green;
      case 'Cancelled':
        return Colors.red.shade600;
      default:
        return Colors.orangeAccent.shade100; // Default color if none of the conditions match
    }
  }

  String _preprocessString(String input) {
    return input.replaceAll(RegExp(r'[\s,%."]'), '').toLowerCase();
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
        text: "Purchase Order",
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
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
                  hintText: "Search Purchase Order",
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
            FutureBuilder<List<PurchaseInvoice>>(
              future: fetching(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  List<PurchaseInvoice> filteredList = snapshot.data!
                      .where((purchase) => purchase.name!
                      .toLowerCase()
                      .contains(_searchTerm.toLowerCase()))
                      .toList();
                  return SizedBox(
                    height: height / 1.h,
                    width: width / 1.w,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        PurchaseInvoice purchase = filteredList[index];
                        return Padding(
                          padding: EdgeInsets.all(8.0.w),
                          child: Container(
                            height: height / 2.5.h,
                            width: width / 1.w,
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
                                  text: purchase.name.toString(),
                                  colo: Colors.blue.shade900,
                                  weight: FontWeight.w500,
                                ),
                                SizedBox(height: 30.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    Row(
                                      children: [
                                        const Mytext(
                                            text: " DATE :",
                                            color: Colors.black),
                                        Mytext(
                                            text:
                                            "${(((purchase.postingDate.toString()).split('-')).toList())[2]}-${(((purchase.postingDate.toString()).split('-')).toList())[1]}-${(((purchase.postingDate.toString()).split('-')).toList())[0]}",
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
                                              "${(((purchase.schedule_date.toString()).split('-')).toList())[2]}-${(((purchase.schedule_date.toString()).split('-')).toList())[1]}-${(((purchase.schedule_date.toString()).split('-')).toList())[0]}",
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
                                    FittedBox(
                                      child: Mytext(
                                          text: purchase.rounded_total
                                              .toString(),
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Subhead(
                                        text: "Status",
                                        colo: Colors.black,
                                        weight: FontWeight.w500),
                                    Mytext(
                                        text: purchase.taxId.toString(),
                                        color: Colors.black),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                GestureDetector(
                                  onTap: () {
                                    print(purchase.name.toString());
                                    print(purchase.supplier.toString());
                                    print(purchase.supplierGstin.toString());
                                    print(purchase);

                                    Get.to(PurchaseInvoicess(
                                      purchaseInvoice: purchase,
                                    ));
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
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

//


class PurchaseInvoicess extends StatefulWidget {
  final PurchaseInvoice purchaseInvoice;
  const PurchaseInvoicess({super.key, required this.purchaseInvoice});

  @override
  State<PurchaseInvoicess> createState() => _PurchaseInvoicessState();
}

class _PurchaseInvoicessState extends State<PurchaseInvoicess> with SingleTickerProviderStateMixin {
  late double height;
  late double width;
  late TabController _tabController;
  File?  _image;

  Color _getBackgroundColor(String taxId) {
    switch (taxId) {
      case 'Initiated':
        return Colors.grey;
      case 'Approved':
        return Colors.orange.shade600;
      case 'Authorized':
        return Colors.green;
      case 'Cancelled':
        return Colors.red.shade600;
      default:
        return Colors.orangeAccent.shade100; // Default color if none of the conditions match
    }
  }

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

  Future<PurchaseInvoice> fetching() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(
        Uri.parse(
            'https://erp.wellknownssyndicate.com/api/resource/Purchase Order/${widget.purchaseInvoice.name}'),
        headers: {
          "Authorization": "token c5a479b60dd48ad:d8413be73e709b6"
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      // print(data);
      return  PurchaseInvoice.fromJson(data);
    } else {
      throw Exception("Failed to fetch data");
    }
  }
    // Print Format logic and Functionality //
  Future<void> purchaseOrderPrint() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    final response = await ioClient.get(
      Uri.parse(
          'https://erp.wellknownssyndicate.com/api/method/frappe.utils.print_format.download_pdf?doctype=Purchase Order&name=WKS-PO-06-24-00076&format=PIC%20PDF&no_letterhead=0&letterhead=WKS%20Letter%20Head%201&settings=%7B%7D&_lang=en-US'),
      headers: {
        "Authorization": "token c5a479b60dd48ad:d8413be73e709b6"
      },
    );

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/sales_invoice.pdf');
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
               // Access the Camera Logic //

  Future<void> _pickImage() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
          await _saveImageToGallery(File(pickedFile.path));
          _showDialog(context);
        }
      } catch (e) {
        print("Error picking image: $e");
      }
    } else {
      print("Storage permission not granted");
    }
  }

  Future<void> _saveImageToGallery(File image) async {
    try {
      final directory = await getExternalStorageDirectory();
      final String newPath =
      path.join(directory!.parent.path, 'Pictures');
      final Directory newDir = Directory(newPath);
      if (!await newDir.exists()) {
        await newDir.create(recursive: true);
      }
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}.png';
      final File newImage =
      await image.copy('${newDir.path}/$fileName');

      // Notify the media scanner about the new file
      const MethodChannel('com.example.app/gallery_scanner')
          .invokeMethod('scanMediaFile', {'path': newImage.path});

      print('Image saved to ${newDir.path}/$fileName');
    } catch (e) {
      print("Error saving image to gallery: $e");
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hello"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _image == null
                  ? const Text('No image selected.') : Image.file(_image!),
              const SizedBox(height: 16),
              const Text("Image Saved Successfully")
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
                    // void for Action Button //

  void actionAlerts (dynamic BuildContext,context){
    Alert(
        context: context,
        // type: AlertType.warning,
        // title: "Alert Message",style: AlertStyle(titleStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.green)),descStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.blue))),
        // desc: "Are you sure want to Submit",
        type: AlertType.info,
        title: "Action",style: AlertStyle(titleStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.green)),descStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.blue))),
        desc: "Select the Actions",
        buttons: [
          DialogButton(
            color: Colors.grey.shade200,
            onPressed: () {
              // Navigator.pop(context); // Close the dialog on button press
            },
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (actionData == 'Initiated') {
                    actionTake = "Approved";
                  } else {
                    actionTake = "Authorized";
                  }
                });
                showAlerts(BuildContext, context);

              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Mytext(
                  // Assuming MyText is a custom widget for displaying text
                  text: (actionData == 'Initiated') ? "Approved" : "Authorized",
                  color: Colors.blue,
                ),
              ),
            ),
          ),

          DialogButton(
              color: Colors.grey.shade200,
              child: GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: const Mytext(text: "Rejected", color: Colors.red)),
              onPressed: (){
                // Navigator.pop(context);
              }
          )
        ]

    ).show();
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

  String actionData = '';
  String actionTake = '';



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
                bottom: 0,
                child: _buildAppBar(),
              ),
              Positioned(
                top: 120,
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

                           //App Bar //
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
          text: "Purchase Order", color: Colors.black, weight: FontWeight.w400),
      centerTitle: true,
      actions: [
         Padding(
           padding:  EdgeInsets.all(8.0.w),
           child:  GestureDetector(
             onTap: (){
               _pickImage();
               _image == null ? const Text('No image selected.') : Image.file(_image!);
             },
             child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.black,
                     ),
           ),
         ),
        Padding(
          padding:  EdgeInsets.all(4.0.w),
          child: GestureDetector(
            onTap: (){
              purchaseOrderPrint();
            },
              child: const Icon(Icons.print,color: Colors.black,)),
        ),
        Padding(
          padding: EdgeInsets.all(4.0.w),
          child: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
        )
      ],
    );
  }

                           //  Body  //

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: FutureBuilder<PurchaseInvoice>(
          future: fetching(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              PurchaseInvoice invoices = snapshot.data!;
              actionData = invoices.taxId.toString();
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  invoices.taxId.toString(),
                                  style: GoogleFonts.poppins( textStyle: TextStyle(
                                    fontSize: 20.sp,
                                    color: _getBackgroundColor(invoices.taxId.toString()),
                                  ),)
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding:  EdgeInsets.all(8.0.w),
                                      child: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            actionAlerts(BuildContext, context);
                                          });

                                          // alert(BuildContext, context);
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
                              ],
                            ),
                             SizedBox(height: 10.h),

                            const SizedBox(height: 5),
                            Mytext(
                                text: invoices.name.toString(),
                                color: Colors.blue),
                            const SizedBox(height: 5),
                            Mytext(
                                text:
                                "Supplier : ${invoices.supplier
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
                              thickness: 1,
                              color: Colors.blue,
                            ),
                             SizedBox(height: 5.h),
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
                                            text: "${(((invoices.postingDate.toString()).split('-')).toList())[2]}-${(((invoices.postingDate.toString()).split('-')).toList())[1]}-${(((invoices.postingDate.toString()).split('-')).toList())[0]}",
                                            color: Colors.black),
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(
                                    thickness: 1,
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
                                            text: "${(((invoices.postingDate.toString()).split('-')).toList())[2]}-${(((invoices.postingDate.toString()).split('-')).toList())[1]}-${(((invoices.postingDate.toString()).split('-')).toList())[0]}",
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
                              thickness: 1,
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
                                    thickness: 1,
                                    color: Colors.blue,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Mytext(
                                            text: "Gst In",
                                            color: Colors.black),
                                        const SizedBox(height: 4),
                                        Mytext(
                                            text: invoices.gst_category
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
                              thickness: 1,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 10),
                            const Center(
                                child: Mytext(
                                    text: "Supplier Name",
                                    color: Colors.black)),
                            const SizedBox(height: 5),
                            Center(
                                child: Mytext(
                                    text: invoices.supplier.toString(),
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
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        const Mytext(
                                            text: "Grand Total",
                                            color: Colors.black),
                                        SizedBox(height: 10.h),
                                        Mytext(
                                            text: invoices.grand_total.toString(),
                                            color: Colors.black),
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(
                                    thickness: 1,
                                    color: Colors.blue,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const FittedBox(
                                          child: Mytext(
                                              text: "Rounding Adjustment",
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 10.h),
                                        Mytext(
                                            text: invoices.rounding_adjustment.toString(),
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
                              thickness: 1,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "Round Total",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      Mytext(
                                          text: invoices.rounded_total.toString()
                                              .toString(),
                                          color: Colors.black),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              height: 2,
                              thickness: 1,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Mytext(
                                          text: "In Words",
                                          color: Colors.black),
                                      const SizedBox(height: 4),
                                      FittedBox(
                                        child: Mytext(
                                            text: invoices.in_words.toString(),
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      TabBar(
                        physics: const ScrollPhysics(),
                        controller: _tabController,
                        tabs: const [
                          Tab(text: 'Items'),
                          Tab(text: 'Taxes'),
                          Tab(text: 'Payment'),
                        ],
                      ),
                      SizedBox(height: 5.h,),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8, // Adjust the height as needed
                          child: TabBarView(
                              controller: _tabController,
                              children: [
                                SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
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
                                                          "${(((paymentSchedule['due_date'].split('-')).toList())[2])}-${(((invoices.postingDate.toString()).split('-')).toList())[1]}-${(((invoices.postingDate.toString()).split('-')).toList())[0]}",
                                                          // '${paymentSchedule['due_date']}',
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

                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 15.h,),
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Expanded(
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
                                                  const VerticalDivider(
                                                    width: 5,
                                                  ),
                                                  Expanded(
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



  // Future<void> workflow_update() async {
  //   HttpClient client = HttpClient();
  //   client.badCertificateCallback =
  //   ((X509Certificate cert, String host, int port) => true);
  //   IOClient ioClient = IOClient(client);
  //   final response = await http.put(
  //       Uri.parse(
  //           'https://erp.wellknownssyndicate.com/api/resource/Purchase Order/${widget.purchaseInvoice.name}'),
  //       headers: {
  //         "Authorization": "token c5a479b60dd48ad:d8413be73e709b6"
  //       },
  //     body:{
  //         "workflow_state":actionTake
  //     }
  //   );
  //   if (response.statusCode == 200) {
  //     print('success');
  //   } else {
  //     throw Exception("Failed to fetch data");
  //   }
  // }


  Future<void> workflow_update() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    final url = Uri.parse(
        'https://erp.wellknownssyndicate.com/api/resource/Purchase Order/${widget.purchaseInvoice.name}');

    final headers = {
      "Authorization": "token c5a479b60dd48ad:d8413be73e709b6",
      "Content-Type": "application/json", // Assuming the server expects JSON
    };

    final body = {
      "workflow_state": actionTake,
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body), // Convert body to JSON string
      );

      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update workflow'); // Throw specific error message
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch data'); // Rethrow the error with a generic message
    }
  }


                                 // Alert Popup logic //
  void showAlerts (BuildContext,context){
    Alert(
        context: context,
        type: AlertType.warning,
        title: "Alert Message",style: AlertStyle(titleStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.green)),descStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.blue))),
        desc: "Are you sure want to Submit",
        buttons: [
          DialogButton(
              color: Colors.grey.shade200,
              child: GestureDetector(
                  onTap: (){
                    // Function For Route //
                    print(actionTake);
                    workflow_update();
                  },
                  child: const Mytext(text: "Yes", color: Colors.blue)),
              onPressed: (){
                print(widget.purchaseInvoice.name);
                print(actionTake);
                workflow_update();
                // Navigator.pop(context);
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
                // Navigator.pop(context);
              }
          )
        ]

    ).show();
  }
}

