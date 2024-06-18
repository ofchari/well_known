import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:well_known/Screens/bottom_navigation.dart';
import 'package:well_known/Screens/dashboard.dart';
import 'package:well_known/Screens/item_list.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:well_known/utils/refreshdata.dart';
import '../Widgets/buttons.dart';
import 'items.dart';

class Newinvoice extends StatefulWidget {
  const Newinvoice({super.key});

  @override
  State<Newinvoice> createState() => _NewinvoiceState();
}

class _NewinvoiceState extends State<Newinvoice> {
  late double height;
  late double width;
  List<int> items = [1]; // Example items list

  List<Map<String, dynamic>> itemsss = [];
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> rateControllers = [];
  List<TextEditingController> totalControllers = [];
  TextEditingController netTotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getItems();
  }

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

          //  Show Dialog for NewInvoice  //
  Future<void> dialogues(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return SizedBox(
            width: 420,
            child: AlertDialog(
              content: SizedBox(
                height: height.h,
                width: width.w,
                  child: const Itemlist()),
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,

            ),
          );
        }
    );
  }

  @override
  void dispose() {
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    for (var controller in rateControllers) {
      controller.dispose();
    }
    for (var controller in totalControllers) {
      controller.dispose();
    }
    super.dispose();
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
                        // dialogues(context);
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
              GestureDetector(
                onTap: () {
                  Get.off(const navigat());
                },
                child: Buttons(
                    heigh: height / 18.h,
                    width: width / 1.5.w,
                    color: const Color(0xffff035e32),
                    text: "Submit",
                    radius: BorderRadius.circular(8)),
              ),
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





