import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:well_known/Screens/New_Invoice.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/text.dart';
import '../Widgets/heading_text.dart';

class NewproformaVoice extends StatefulWidget {
  const NewproformaVoice({super.key});

  @override
  State<NewproformaVoice> createState() => _NewproformaVoiceState();
}

class _NewproformaVoiceState extends State<NewproformaVoice> {

           // Textediting controller //

  final salesperso = TextEditingController();
  final date = TextEditingController();
  final custom = TextEditingController();
  final custom_name = TextEditingController();
  final custom_address = TextEditingController();
  final companee = TextEditingController();
  final contactname = TextEditingController();
  final contactnumber = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  late double height;
  late double width;

                // Intialize Api //
  @override
  void initState() {
    mobileDocument(context);
    super.initState();
  }

            // Post Api //
  Future<void> mobileDocument(BuildContext context) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    const credentials = 'c5a479b60dd48ad:d8413be73e709b6';
    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
      'Content-Type': 'application/json',
    };

    final data = {
      'doctype': 'Proforma Invoice',
      'sales_person': salesperso.text,
      'transaction_date': date.text,
      'customer':custom.text,
      'customer_name':custom_name.text,
      'customer_address':custom_address.text,
      'company':companee.text,
      'contact_name':contactname.text,
      'contact_number':contactnumber.text,
    };

    final body = jsonEncode(data);

    final response = await ioClient.post(
      Uri.parse("https://erp.wellknownssyndicate.com/api/resource/Proforma Invoice"),
      headers: headers,
      body: body,
    );

    dynamic responseJson = json.decode(response.body.toString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Newinvoice()),
      );
    }
    else if (response.statusCode == 417) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Request to fill all the field'),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      dynamic responseList = responseJson['_server_messages'];
      dynamic responcemsg = responseList['message'];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Message'),
          content: SingleChildScrollView(
            child: Text(responcemsg),
          ),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
    else {
      showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
          child: AlertDialog(
            title: Text('Error'),
            content: Text('Request failed with status: ${response.statusCode} ${response.body}'),
            actions: [
              ElevatedButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
      print(response.body);
      print(response.toString());
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
            ScreenUtil.init(context, designSize: Size(width, height), minTextAdapt: true);
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Headingtext(text: "  New Proforma Invoice", color: Colors.black, weight: FontWeight.w400),
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: salesperso,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.stacked_line_chart, color: Color(0xffff035e32)),
                      labelText: "  Sales Person",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      height: height / 14.h,
                      width: width / 1.1.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range, color: Colors.blue),
                            const SizedBox(width: 8), // Added spacing for better UI
                            Text(
                              ' ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 15.8,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     _selectDate(context);
                  //   },
                  //   child: Container(
                  //     height: height / 14,
                  //     width: width / 2.4,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(15),
                  //         border: Border.all(color: Colors.green)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Row(
                  //         children: [
                  //           const Icon(Icons.date_range, color: Colors.blue),
                  //           const SizedBox(width: 8), // Added spacing for better UI
                  //           Text(
                  //             ' ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  //             style: GoogleFonts.poppins(
                  //               textStyle: const TextStyle(
                  //                 fontSize: 15.8,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: custom,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Color(0xffff035e32)),
                      labelText: "Customer",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: custom_name,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.verified_user, color: Color(0xffff035e32)),
                      labelText: "Customer Name",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: custom_address,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.place_outlined, color: Color(0xffff035e32)),
                      labelText: "Customer Address",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: companee,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.compare, color: Color(0xffff035e32)),
                      labelText: "Company",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: contactname,
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.drive_file_rename_outline, color: Color(0xffff035e32)),
                      labelText: "Contact Name",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: contactnumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.call, color: Color(0xffff035e32)),
                      labelText: "Contact Number",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: (){
                  mobileDocument(context);
                },
                child: Buttons(
                    heigh: height / 20,
                    width: width / 1.8,
                    color: const Color(0xffff035e32),
                    text: "Next",
                    radius: BorderRadius.circular(16)),
              ),
              const SizedBox(height: 30,),
            ],
          ),

        ),
      ),
    );
  }
}
