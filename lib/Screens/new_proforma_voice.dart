import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:well_known/Screens/New_Invoice.dart';
import 'package:well_known/Screens/proforma_invoice.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import '../Services/customer_api.dart';
import '../Utils/customer_utils.dart';
import '../Utils/refreshdata.dart';
import '../Utils/willpopscope.dart';
import '../Widgets/buttons.dart';
import '../Widgets/heading_text.dart';


class NewproformaVoice extends StatefulWidget {
  const NewproformaVoice({super.key});

  @override
  State<NewproformaVoice> createState() => _NewproformaVoiceState();
}

class _NewproformaVoiceState extends State<NewproformaVoice> {
  DateTime _selectedDate = DateTime.now();

  // String _selectedCustomer = '';
  // late SingleValueDropDownController _dropDownController;

  final salesPersonController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerAddressController = TextEditingController();
  final companyController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getbank();
    getEmployee();
    getGst();

  }

  // @override
  // void dispose() {
  //   _dropDownController.dispose();
  //   // salesPersonController.dispose();
  //   // customerNameController.dispose();
  //   // customerAddressController.dispose();
  //   // companyController.dispose();
  //   // contactNameController.dispose();
  //   // contactNumberController.dispose();
  //   super.dispose();
  // }

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
          // Post For New Proforma Invoice //
  Future<void> mobileDocument(BuildContext context) async {
    HttpClient client = HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    const credentials = 'd950c312e572164:6325951adb3a2e6';
    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode(credentials))}',
      'Content-Type': 'application/json',
    };

    final data = {
      'doctype': 'Wallet Registration Form',
      // 'full_name': name.text,
      // 'username': username.text,
      // 'email':mail.text,
      // 'mobile_no':phone.text,
      // 'password':passwor.text,
      // 'confirm_password':confirm_pass.text
    };

    final body = jsonEncode(data);

    final response = await ioClient.post(
      Uri.parse("https://btex.regenterp.com/api/resource/Wallet Registration Form"),
      headers: headers,
      body: body,
    );

    dynamic responseJson = json.decode(response.body.toString());
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Newinvoice()),
      );
    }
    else if (response.statusCode == 417) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Request to fill all the field'),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
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
          title: const Text('Message'),
          content: SingleChildScrollView(
            child: Text(responcemsg),
          ),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Request failed with status: ${response.statusCode} ${response.body}'),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      print(response.body);
      print(response.toString());
    }
  }
   // Late Initialize the size //
  late double height;
  late double width;

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
            } else {
              return const Text("Large");
            }
          },
        ),
      ),
    );
  }
  List<DropDownValueModel> bank_list=[];
  List<DropDownValueModel> saless=[];
  List<DropDownValueModel> gst=[];
  String bank_book = '';
  String saleesspers = '';
  String gsttaxe = '';
                           // Bank //
  Future<void> getbank() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(

          Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Customer?fields=[%22name%22,%22customer_name%22]&limit_page_length=50000'),headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["data"];


        for (var item in responseData) {
          if (item["name"] != null) {
            bank_list.add( DropDownValueModel(name: item["customer_name"], value: item["name"]));
          }
        }
        print(bank_list);
        print(bank_list);
        print(bank_list);
        bank_list = bank_list;
        setState(() {
          // Assuming title_list is updated after fetching data
          bank_list = bank_list;
        });


      } else {
        // Handle error
        print('Failed to load Wallet Title data');
        print(response.statusCode );
        print(response.body );
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }
                          // Sales Person //
  Future<void> getEmployee() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
          Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Employee?fields=[%22name%22,%22employee_name%22]&limit_page_length=50000'),headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["data"];


        for (var item in responseData) {
          if (item["name"] != null) {
            saless.add( DropDownValueModel(name: item["employee_name"], value: item["name"]));
          }
        }
        print(saless);
        saless = saless;
        setState(() {
          // Assuming title_list is updated after fetching data
          saless = saless;
        });

      } else {
        // Handle error
        print('Failed to load Wallet Title data');
        print(response.statusCode );
        print(response.body );
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }
                          // Gst In //
  Future<void> getGst() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
          Uri.parse('https://erp.wellknownssyndicate.com/api/resource/Customer?fields=[%22gstin%22,"%22customer_type%22"]&limit_page_length=500000'),headers: {"Authorization": "token c5a479b60dd48ad:d8413be73e709b6"});
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)["data"];


        for (var item in responseData) {
          if (item["customer_type"] != null) {
            gst.add( DropDownValueModel(name: item["gstin"], value: item["customer_type"]));
          }
        }
        print(gst);
        gst = gst;
        setState(() {
          // Assuming title_list is updated after fetching data
          gst = gst;
        });

      } else {
        // Handle error
        print('Failed to load Wallet Title data');
        print(response.statusCode );
        print(response.body );
      }
    } catch (e) {
      throw Exception('Failed to load document IDs: $e');
    }
  }
                             //Willpop Scope //
  Future<bool> _onWillPop() async{
    return await Get.dialog(
        AlertDialog(
          title: const Subhead(text: "Are you sure want to go back?", colo: Colors.blue, weight: FontWeight.w500,),
          actions: [
            GestureDetector(
                onTap: (){
                  Get.back(result: true);
                },
                child: Buttons(heigh: height/22.h, width: width/6.w, color: Colors.green, text: "Yes", radius: BorderRadius.circular(12.r))),
            GestureDetector(
                onTap: (){
                  Get.back(result: false);
                },
                child: Buttons(heigh: height/22.h, width: width/6.w, color: Colors.red.shade600, text: "No", radius: BorderRadius.circular(12.r))),
          ],
        )

    );
  }

  Widget _smallBuildLayout() {
    return WillPopScope(
      onWillPop:()=> _onWillPop(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 80,
          leading: GestureDetector(
            onTap: () {
             _onWillPop();
            },
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: const Headingtext(
            text: "New Proforma Invoice",
            color: Colors.black,
            weight: FontWeight.w400,
          ),
          centerTitle: true,
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: height/16.h,
                      width: width/1.1.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.green
                          )
                      ),
                      child: DropDownTextField(
                        textFieldDecoration:InputDecoration(
                            prefix: const Text('     '),
                            hintText: 'Customer Name',
                            hintStyle: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none
                          // Use OutlineInputBorder for outline border
                        ),
                        clearOption: false,
                        textFieldFocusNode: FocusNode(),
                        // searchFocusNode: searchFocusNode,
                        // searchAutofocus: true,
                        dropDownItemCount: 8,
                        searchShowCursor: false,
                        enableSearch: true,
                        searchKeyboardType: TextInputType.name,
                        dropDownList:bank_list,
                        // onChanged: (value) {
                        //   setState(() {
                        //     dropdownValue = value!;
                        //     cash = value;
                        //   });
                        // },
                        onChanged: (dynamic value) {
                          setState(() {
                            bank_book = value.value;
                          });
                          print(value.name);
                          print(value);
                          print(bank_book);
                          print(value);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: height/16.h,
                      width: width/1.1.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.green
                          )
                      ),
                      child: DropDownTextField(
                        textFieldDecoration:InputDecoration(
                            prefix: const Text('     '),
                            hintText: 'Employee Name',
                            hintStyle: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none
                          // Use OutlineInputBorder for outline border
                        ),
                        clearOption: false,
                        textFieldFocusNode: FocusNode(),
                        // searchFocusNode: searchFocusNode,
                        // searchAutofocus: true,
                        dropDownItemCount: 8,
                        searchShowCursor: false,
                        enableSearch: true,
                        searchKeyboardType: TextInputType.name,
                        dropDownList:saless,
                        // onChanged: (value) {
                        //   setState(() {
                        //     dropdownValue = value!;
                        //     cash = value;
                        //   });
                        // },
                        onChanged: (dynamic value) {
                          setState(() {
                            saleesspers = value.value;
                          });
                          print(value.name);
                          print(value);
                          print(saleesspers);
                          print(value);
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    height: 50,
                    width: width / 1.1.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.date_range, color: Colors.blue),
                          const SizedBox(width: 5),
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
                SizedBox(height: 10.h),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: height/16.h,
                      width: width/1.1.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.green
                          )
                      ),
                      child: DropDownTextField(
                        textFieldDecoration:InputDecoration(
                            prefix: const Text('     '),
                            hintText: 'Gst In ',
                            hintStyle: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none
                          // Use OutlineInputBorder for outline border
                        ),
                        clearOption: false,
                        textFieldFocusNode: FocusNode(),
                        // searchFocusNode: searchFocusNode,
                        // searchAutofocus: true,
                        dropDownItemCount: 8,
                        searchShowCursor: false,
                        enableSearch: true,
                        searchKeyboardType: TextInputType.name,
                        dropDownList:gst,
                        // onChanged: (value) {
                        //   setState(() {
                        //     dropdownValue = value!;
                        //     cash = value;
                        //   });
                        // },
                        onChanged: (dynamic value) {
                          setState(() {
                            gsttaxe = value.value;
                          });
                          print(gsttaxe);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.place_outlined, color: Color(0xffff035e32)),
                      labelText: "Rate",
                      labelStyle: GoogleFonts.poppins(
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.compare, color: Color(0xffff035e32)),
                      labelText: "Company",
                      labelStyle: GoogleFonts.poppins(
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.drive_file_rename_outline, color: Color(0xffff035e32)),
                      labelText: "Contact Name",
                      labelStyle: GoogleFonts.poppins(
                        textStyle: const TextStyle (fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.call, color: Color(0xffff035e32)),
                      labelText: "Contact Number",
                      labelStyle: GoogleFonts.poppins(
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                   Get.to(const Newinvoice());
                   //  mobileDocument(context);
                  },
                  child: Buttons(
                    heigh: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width / 1.8,
                    color: const Color(0xffff035e32),
                    text: "Next",
                    radius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 30),

            ],
            ),
          ),
        ),
      ),
    );
  }
}
void _showAlerts(BuildContext context){
  Alert(
      context: context,
    type: AlertType.info,
    desc: "Are you sure want to go back",style: AlertStyle(descStyle: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.blue))),
    buttons: [
      DialogButton(
        color: Colors.green,
          child: GestureDetector(
            onTap: (){
              Get.to(const ProformaInvoice());
            },
              child: const Mytext(text: "Yes", color: Colors.white)),
          onPressed: (){
            Navigator.pop(context);
          }
      ),
      DialogButton(
        color: Colors.red.shade500,
          child: GestureDetector(
            onTap: (){
              Get.back();
            },
              child: const Mytext(text: "No", color: Colors.white)),
          onPressed: (){
            Navigator.pop(context);
          }
      ),
    ]
  ).show();
}

