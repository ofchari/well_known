import 'package:flutter/material.dart';
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
import '../Screens/dashboard.dart';
import '../Screens/item_list.dart';
import '../Services/customer_api.dart';
import '../Utils/customer_utils.dart';
import '../Utils/refreshdata.dart';
import '../Widgets/buttons.dart';
import '../Widgets/heading_text.dart';
import '../Widgets/subhead.dart';
import '../Widgets/text.dart';


class testing extends StatefulWidget {
  const testing({super.key});

  @override
  State<testing> createState() => _TestingState();
}

class _TestingState extends State<testing> {

  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    getbank();
    getEmployee();
    getGst();
    _getItems();

  }

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
// -----------------x--------------------
//   page2
  List<int> items = [1]; // Example items list

  List<Map<String, dynamic>> itemsss = [];
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> rateControllers = [];
  List<TextEditingController> totalControllers = [];
  TextEditingController netTotalController = TextEditingController();


  void calculateNetTotal() {
    double netTotal = 0.0;
    for (var totalController in totalControllers) {
      double total = double.tryParse(totalController.text) ?? 0.0;
      netTotal += total;
    }
    netTotalController.text = netTotal.toStringAsFixed(2);
  }

  Future<void> _getItems() async {
    List<Map<String, dynamic>> fetchedItems = await DatabaseHelper().getItemsGroup();
    setState(() {
      itemsss = fetchedItems;
      quantityControllers = List.generate(itemsss.length, (index) => TextEditingController());
      rateControllers = List.generate(itemsss.length, (index) => TextEditingController());
      totalControllers = List.generate(itemsss.length, (index) => TextEditingController());

      for (int index = 0; index < itemsss.length; index++) {
        var quantityController = quantityControllers[index];
        var rateController = rateControllers[index];
        var totalController = totalControllers[index];
        var item = itemsss[index];

        quantityController.text = item['total_quantity'].toStringAsFixed(0);

        void calculateTotal() {
          double quantity = double.tryParse(quantityController.text) ?? 0.0;
          double rate = double.tryParse(rateController.text) ?? 0.0;
          double total = quantity * rate;
          totalController.text = total.toStringAsFixed(2);
          calculateNetTotal();
        }

        quantityController.addListener(calculateTotal);
        rateController.addListener(calculateTotal);
      }
    });
  }

  // @override
  // void dispose() {
  //   for (var controller in quantityControllers) {
  //     controller.dispose();
  //   }
  //   for (var controller in rateControllers) {
  //     controller.dispose();
  //   }
  //   for (var controller in totalControllers) {
  //     controller.dispose();
  //   }
  //   super.dispose();
  // }


  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToNextPage() {
    if (_currentPage < 3) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
              return PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe to change page
                children: [
                  _smallBuildLayout1(),
                  _smallBuildLayout2(),
                  Container(
                    color: Colors.grey,
                    child: const Center(child: Text('Page 3')),
                  ),
                  Container(
                    color: Colors.black,
                    child: const Center(child: Text('Page 4', style: TextStyle(color: Colors.white))),
                  ),
                ],
              );
            } else {
              return const Text("Large");
            }
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _goToPreviousPage,
              child: const Text('Previous'),
            ),
            ElevatedButton(
              onPressed: _goToNextPage,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

 /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Disable swipe to change page
        children: [
          Container(
            color: Colors.blue,
            child: Center(child: Text('Page 1')),
          ),
          Container(
            color: Colors.yellowAccent,
            child: Center(child: Text('Page 2')),
          ),
          Container(
            color: Colors.grey,
            child: Center(child: Text('Page 3')),
          ),
          Container(
            color: Colors.black,
            child: Center(child: Text('Page 4', style: TextStyle(color: Colors.white))),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _goToPreviousPage,
              child: Text('Previous'),
            ),
            ElevatedButton(
              onPressed: _goToNextPage,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }*/


  Widget _smallBuildLayout1() {
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
              // SizedBox(height: 15),
              // GestureDetector(
              //   onTap: () {
              //     // mobileDocument(context);
              //   },
              //   child: Buttons(
              //     heigh: MediaQuery.of(context).size.height / 20,
              //     width: MediaQuery.of(context).size.width / 1.8,
              //     color: const Color(0xffff035e32),
              //     text: "Next",
              //     radius: BorderRadius.circular(16),
              //   ),
              // ),
              const SizedBox(height: 30),


            ],
          ),
        ),
      ),
    );
  }


  Widget _smallBuildLayout2() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Mytext(text: "Items", color: Colors.grey),
                  Column(
                    children: [
                      const Mytext(text: "Net Total", color: Colors.black),
                      Mytext(
                          text: netTotalController.text,
                          color: Colors.black),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 22.0, left: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const Itemlist());
                      },
                      child: Container(
                        height: height / 26.h,
                        width: width / 8.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffff035e32),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            )),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: height / 1.5.h,
                child: ListView.builder(
                  itemCount: itemsss.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = itemsss[index];
                    var quantityController = quantityControllers[index];
                    var rateController = rateControllers[index];
                    var totalController = totalControllers[index];

                    return Column(
                      children: [
                        Dismissible(
                          key: Key(item['itemName']),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            String itemName = item['itemName'];
                            DatabaseHelper().deleteItem(itemName).then((_) {
                              setState(() {
                                itemsss.removeWhere((element) =>
                                element['itemName'] == itemName);
                                quantityControllers.removeAt(index);
                                rateControllers.removeAt(index);
                                totalControllers.removeAt(index);
                                calculateNetTotal();
                              });
                            }).catchError((error) {
                              print("Error deleting item: $error");
                            });
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child:
                            const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 1.5),
                                height: height / 5.h,
                                width: width / 1.1.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FittedBox(
                                        child: Center(
                                            child: Subhead(
                                                text: "${item['itemName']}",
                                                colo: Colors.black,
                                                weight: FontWeight.w500))),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: height / 9.h,
                                            width: width / 4.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              image: const DecorationImage(
                                                image: NetworkImage(
                                                    "https://img.freepik.com/premium-photo/close-up-sewing-machine-with-hands-working_41969-2495.jpg"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 30.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                FittedBox(
                                                  child: Mytext(
                                                    text:
                                                    "Code: ${item['itemCode'].split(' ')[0]}",
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    const FittedBox(
                                                      child: Mytext(
                                                        text: "Group:",
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Mytext(
                                                        text:
                                                        " ${item['itemGroup'].split(' ').sublist(0, 1).join(' ')}",
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Mytext(
                                                    text:
                                                    "UOM: ${item['stock_uom']}",
                                                    color: Colors.black),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: height / 11.0.h,
                                width: width / 1.22.w,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1.2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(50.0)),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Mytext(
                                                    text: "Quantity",
                                                    color: Colors.grey),
                                                SizedBox(
                                                  width: width / 10.w,
                                                  child: TextFormField(
                                                    controller:
                                                    quantityController,
                                                    keyboardType:
                                                    TextInputType.number,
                                                    decoration:
                                                    const InputDecoration(
                                                      contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0.0),
                                                      hintText: "0",
                                                      border: InputBorder.none,
                                                    ),
                                                    onChanged: (value) {
                                                      calculateNetTotal();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Mytext(
                                                    text: "Rate",
                                                    color: Colors.grey),
                                                SizedBox(
                                                  width: width / 10.w,
                                                  child: TextFormField(
                                                    controller: rateController,
                                                    keyboardType:
                                                    TextInputType.number,
                                                    decoration:
                                                    const InputDecoration(
                                                      contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0.0),
                                                      hintText: "0",
                                                      border: InputBorder.none,
                                                    ),
                                                    onChanged: (value) {
                                                      calculateNetTotal();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Mytext(
                                                    text: "Total",
                                                    color: Colors.grey),
                                                SizedBox(
                                                  width: width / 4.w,
                                                  child: TextFormField(
                                                    controller: totalController,
                                                    readOnly: true,
                                                    keyboardType:
                                                    TextInputType.number,
                                                    decoration:
                                                    const InputDecoration(
                                                      contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 0.0),
                                                      hintText: "0",
                                                      hintStyle: TextStyle(
                                                          color: Colors.black),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // GestureDetector(
              //   onTap: () {
              //     Get.off(const Dashboard());
              //   },
              //   child: Buttons(
              //       heigh: height / 18.h,
              //       width: width / 1.5.w,
              //       color: const Color(0xffff035e32),
              //       text: "Submit",
              //       radius: BorderRadius.circular(8)),
              // ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
