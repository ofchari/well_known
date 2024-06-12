import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:well_known/Screens/dashboard.dart';
import 'package:well_known/Screens/item_list.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:well_known/utils/refreshdata.dart';
import '../Widgets/buttons.dart';

class Newinvoice extends StatefulWidget {
  const Newinvoice({super.key});

  @override
  State<Newinvoice> createState() => _NewinvoiceState();
}

class _NewinvoiceState extends State<Newinvoice> {
  late double height;
  late double width;
  List<int> items = [1]; // Example items list

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
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
    );
  }

  Widget _smallBuildLayout() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Mytext(text: "Items", color: Colors.grey),
                  const Column(
                    children: [
                      Mytext(text: "Net Total", color: Colors.black),
                      Mytext(text: "84.35", color: Colors.black),
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
                        child: const Center(child: Icon(Icons.add, color: Colors.white, size: 24,)),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 50,),
              // ...items.map((e) => _buildItem(e)).toList(),
              ...items.map((e) => _buildItem(e)).toList(),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Get.off(const Dashboard());
                },
                child: Buttons(heigh: height / 18.h, width: width / 1.5.w, color: const Color(0xffff035e32), text: "Submit", radius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int item) {
    return Column(
      children: [
        Dismissible(
          key: ValueKey(item),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              items.remove(item);
            });
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 1.5),
            height: height / 5.h,
            width: width / 1.1.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.green,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Subhead(text: "Item $item", colo: Colors.black, weight: FontWeight.w500),
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
                        height: height / 9.h,
                        width: width / 4.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage("https://img.freepik.com/premium-photo/close-up-sewing-machine-with-hands-working_41969-2495.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Mytext(text: "Code : 1000", color: Colors.black),
                            SizedBox(height: 10,),
                            Mytext(text: "Item Group", color: Colors.black),
                            SizedBox(height: 10,),
                            Mytext(text: "UOM - PCS", color: Colors.black),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: height / 10.27.h,
          width: width / 1.42.w,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            border: Border.all(
              color: Colors.green,
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10,),
                      const Mytext(text: "Quantity", color: Colors.black),
                      SizedBox(
                        width: width / 10.w,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                            hintText: "0",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10,),
                      const Mytext(text: "Rate", color: Colors.black),
                      SizedBox(
                        width: width / 10.w,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "0.0",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Column(
                    children: [
                      Mytext(text: "Total", color: Colors.grey),
                      Mytext(text: "0.0", color: Colors.grey),
                    ],
                  ),
                  const Column(
                    children: [
                      Mytext(text: "UOM", color: Colors.grey),
                      Mytext(text: "SET", color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}