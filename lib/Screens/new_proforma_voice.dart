import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:well_known/Screens/New_Invoice.dart';
import '../Services/customer_api.dart';
import '../Utils/customer_utils.dart';
import '../Utils/refreshdata.dart';
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

  // final salesPersonController = TextEditingController();
  // final customerNameController = TextEditingController();
  // final customerAddressController = TextEditingController();
  // final companyController = TextEditingController();
  // final contactNameController = TextEditingController();
  // final contactNumberController = TextEditingController();

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


  Widget _smallBuildLayout() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: GestureDetector(
          onTap: () {
            Get.back();
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
                    child:
                    DropDownTextField(
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
                    child:
                    DropDownTextField(
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
                    child:
                    DropDownTextField(
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
                  // mobileDocument(context);
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
    );
  }
}

