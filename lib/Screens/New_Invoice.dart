import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:well_known/Screens/bottom_navigation.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:well_known/utils/refreshdata.dart';
import '../Widgets/buttons.dart';
import 'item_list.dart';
import 'items.dart';

// Create a GetX Controller to manage the state
class InvoiceController extends GetxController {
  var itemsss = <Map<String, dynamic>>[].obs;
  var quantityControllers = <TextEditingController>[].obs;
  var rateControllers = <TextEditingController>[].obs;
  var totalControllers = <TextEditingController>[].obs;
  var netTotalController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    _getItems();
  }

  void calculateNetTotal() {
    double netTotal = 0.0;
    for (var totalController in totalControllers) {
      double total = double.tryParse(totalController.text) ?? 0.0;
      netTotal += total;
    }
    netTotalController.value.text = netTotal.toStringAsFixed(2);
  }

  Future<void> _getItems() async {
    List<Map<String, dynamic>> fetchedItems = await DatabaseHelper().getItemsGroup();
    itemsss.value = fetchedItems;

    if (quantityControllers.isEmpty && rateControllers.isEmpty && totalControllers.isEmpty) {
      quantityControllers.value = List.generate(itemsss.length, (index) => TextEditingController());
      rateControllers.value = List.generate(itemsss.length, (index) => TextEditingController());
      totalControllers.value = List.generate(itemsss.length, (index) => TextEditingController());
    }

    for (int index = 0; index < itemsss.length; index++) {
      var quantityController = quantityControllers[index];
      var rateController = rateControllers[index];
      var totalController = totalControllers[index];
      var item = itemsss[index];

      if (quantityController.text.isEmpty) {
        quantityController.text = item['total_quantity'].toStringAsFixed(0);
      }

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
  }
}

class Newinvoice extends StatelessWidget {
  Newinvoice({super.key});

  final InvoiceController invoiceController = Get.put(InvoiceController());

  Future<void> dialogues(BuildContext context) async {
    return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            width: 420,
            child: AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(context).size.height.h,
                width: MediaQuery.of(context).size.width.w,
                child: const Itemlist(),
              ),
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

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
              return _smallBuildLayout(height, width, context);
            } else {
              return const Text("Large");
            }
          },
        ),
      ),
    );
  }

  Widget _smallBuildLayout(double height, double width, BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Mytext(text: "Items", color: Colors.grey),
                  Column(
                    children: [
                      const Mytext(text: "Net Total", color: Colors.black),
                      Obx(() => Mytext(
                        text: invoiceController.netTotalController.value.text,
                        color: Colors.black,
                      )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 22.0, left: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        dialogues(context); // Pass the correct context here
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
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30.h),
              Obx(() => SizedBox(
                height: height / 1.55.h,
                child: ListView.builder(
                  itemCount: invoiceController.itemsss.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = invoiceController.itemsss[index];
                    var quantityController = invoiceController.quantityControllers[index];
                    var rateController = invoiceController.rateControllers[index];
                    var totalController = invoiceController.totalControllers[index];

                    return Column(
                      children: [
                        Dismissible(
                          key: Key(item['itemName']),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            String itemName = item['itemName'];
                            DatabaseHelper().deleteItem(itemName).then((_) {
                              invoiceController.itemsss.removeAt(index);
                              invoiceController.quantityControllers.removeAt(index);
                              invoiceController.rateControllers.removeAt(index);
                              invoiceController.totalControllers.removeAt(index);
                              invoiceController.calculateNetTotal();
                            }).catchError((error) {
                              print("Error deleting item: $error");
                            });
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 1.5),
                                height: height / 5,
                                width: width / 1.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    FittedBox(
                                      child: Center(
                                        child: Subhead(
                                          text: "${item['itemName']}",
                                          colo: Colors.blue,
                                          weight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: height / 9,
                                            width: width / 4,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              image: const DecorationImage(
                                                image: NetworkImage(
                                                    "https://img.freepik.com/premium-photo/close-up-sewing-machine-with-hands-working_41969-2495.jpg"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                FittedBox(
                                                  child: Mytext(
                                                    text: "Code: ${item['itemCode'].split(' ')[0]}",
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
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
                                height: height/10.h,
                                width: width/1.3.w,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue
                                    ),
                                    borderRadius: BorderRadius.circular(15.r)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 10.h,),
                                        const FittedBox(
                                          child: Mytext(
                                            text: "Qty",
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 30,
                                          width: width / 7,
                                          child: TextFormField(
                                            controller: quantityController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 10.h,),
                                        const FittedBox(
                                          child: Mytext(
                                            text: "Rate",
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 30,
                                          width: width / 7,
                                          child: TextFormField(
                                            controller: rateController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 10.h,),
                                        const FittedBox(
                                          child: Mytext(
                                            text: "Total",
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 26,
                                          width: width / 6.8,
                                          child: TextFormField(
                                            controller: totalController,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            readOnly: true,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  _alertsNewInvoice(context); // Pass the correct context here
                },
                child: Buttons(
                  heigh: height / 18.h,
                  width: width / 1.5.w,
                  color: const Color(0xffff035e32),
                  text: "Submit",
                  radius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  void _alertsNewInvoice(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.info,
      desc: "Are you sure you want to submit?",
      style: AlertStyle(
        descStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
        ),
      ),
      buttons: [
        DialogButton(
          color: Colors.green,
          child: GestureDetector(
            onTap: () {
              Get.offAll(const navigat());
            },
            child: const Mytext(text: "Yes", color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
          color: Colors.red.shade600,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Mytext(text: "No", color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ).show();
  }
}
