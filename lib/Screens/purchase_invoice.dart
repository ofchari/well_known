import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import '../../Services/purchase_api.dart';
import '../../Widgets/buttons.dart';
import 'package:http/http.dart'as http;
import 'package:path/path.dart'as path;


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
  File ?  _image;
  late final String  _matching;
  late String camimagePath;
  late String camimagename;
  late File camimagefile;

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
            'https://erp.wellknownssyndicate.com/api/resource/Purchase Invoice/${widget.purchaseInvoice.name}'),
        headers: {
          "Authorization": "token c5a479b60dd48ad:d8413be73e709b6"
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      print(data);
      return PurchaseInvoice.fromJson(data);
    } else {
      throw Exception("Failed to fetch data");
    }
  }

                     // Camera Functionality to capture the image //

  Future<Map<String, dynamic>?> uploadImageToFileManager(
  File imageFile,
  String fileName,
      ) async {
    const apiUrl = 'https://erp.wellknownssyndicate.com/api/method/upload_file';
    // final apiUrlput = 'https://erp.wellknownssyndicate.com/api/resource/Purchase Invoice/${widget.purchaseInvoice.name}';
print(apiUrl);
print(widget.purchaseInvoice.name);
print(widget.purchaseInvoice.name);
print(widget.purchaseInvoice.name);
    final apiUrlput = Uri.parse(
        'https://erp.wellknownssyndicate.com/api/resource/Purchase Invoice/${widget.purchaseInvoice.name}');

    final headers1 = {
      "Authorization": "token c5a479b60dd48ad:d8413be73e709b6",
      "Content-Type": "application/json", // Assuming the server expects JSON
    };

    final body1 = {
      "attached_image_link_app": "/files/$fileName.png",
    };


    try {
      final response = await http.put(
        apiUrlput,
        headers: headers1,
        body: jsonEncode(body1), // Convert body to JSON string
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

    try {
      const credentials = 'c5a479b60dd48ad:d8413be73e709b6'; // Well_known
      final headers = {
        'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
      };

      final ioClient = IOClient(HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true));

      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      // final request1 = http.MultipartRequest('PUT', Uri.parse(apiUrlput));
      request.headers.addAll(headers);

      final imageStream = http.ByteStream(imageFile.openRead());
      final imageLength = await imageFile.length();

      request.files.add(http.MultipartFile(
        'file',
        imageStream,
        imageLength,
        filename: '$fileName.png',
      ));

      final now = DateTime.now(); // Get current date and time
      final messageData = {
      "message": {
        "name": fileName, // Use the desired file name here
        "owner": "Administrator",
        "creation": DateTime.now().toIso8601String(),
        "modified": DateTime.now().toIso8601String(),
        "modified_by": "Administrator",
        "docstatus": 0,
        "idx": 0,
        "file_name": '$fileName.png',
        "is_private": 0,
        "is_home_folder": 0,
        "is_attachments_folder": 0,
        "file_size": imageLength,
        "file_url": "/files/$fileName.png", // Use the correct file URL path
        "folder": "Home/Attachments", // Use the desired folder name
        "is_folder": 0,
        "attached_to_doctype": "Purchase Invoice",
        "attached_to_name":widget.purchaseInvoice.name,
        "content_hash": "", // You may need to calculate the content hash
        "uploaded_to_dropbox": 0,
        "uploaded_to_google_drive": 0,
        "doctype": "File"

      }
      };

      request.fields['data'] = json.encode(messageData);

      final response = await ioClient.send(request);

      if (response.statusCode == 200) {
        final responseBody = json.decode(await response.stream.bytesToString());
        return responseBody;
      } else {
        print(response.statusCode);
        print(await response.stream.bytesToString());
        return null;
      }
    } catch (error) {
      print('Image Upload Error: $error');
      return null;
    }
  }

  Future<void> captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        camimagePath = pickedFile.path;
        camimagefile = File(camimagePath);
        camimagename = path.basenameWithoutExtension(camimagePath);
      });
      final now = DateTime.now();
      final formattedDate = DateFormat('dd-MM-yyyy').format(now); // Format the date
      final formattedTime = DateFormat('HH:mm:ss').format(now); // Format the time
      final purchaseInvoiceName = widget.purchaseInvoice.name; // Get the purchase invoice name

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                "Purchase Inward",
                style: GoogleFonts.outfit(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(File(pickedFile.path)), // Display the captured image
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Name: $purchaseInvoiceName",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h,),
                      Text(
                        " Date: $formattedDate",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h,),
                      Text(
                        "Time: $formattedTime",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      uploadImageToFileManager(camimagefile, camimagename);
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
          text: "Purchase Inward", color: Colors.black, weight: FontWeight.w400),
      centerTitle: true,
      actions: [
         Padding(
           padding:  EdgeInsets.all(8.0.w),
           child: const Icon(
            Icons.home,

                   ),
         ),
        GestureDetector(
          onTap: () async{
            await captureImage();
            _image == null ? const Text('No image selected.') : Image.file(_image!);
          },
          child: Padding(
            padding:  EdgeInsets.all(8.0.w),
            child: const Icon(
              Icons.camera_alt_outlined,

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
      FutureBuilder<PurchaseInvoice>(
          future: fetching(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              PurchaseInvoice invoices = snapshot.data!;
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
                              text: "Supplier",
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
                                "Customer : ${invoices.supplier
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
                                            text: invoices.postingDate
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
                                            text: "Delivery Date",
                                            color: Colors.black),
                                        const SizedBox(height: 4),
                                        Mytext(
                                            text: invoices.postingDate
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
                                            text: "Gst Category",
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
                                    text: "Customer Name",
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
   // Alert Popup logic //
void alert (BuildContext,context){
  Alert(
      context: context,
      type: AlertType.warning,
      // title: "Alert Message",style: AlertStyle(titleStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w500,color: Colors.green)),descStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.blue))),
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
