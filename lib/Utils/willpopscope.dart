
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Widgets/buttons.dart';

Future<bool> _onWillPop() async{
  return await Get.dialog(
    AlertDialog(
      title: const Text("Are you sure want to submit? "),
      actions: [
        GestureDetector(
          onTap: (){
            Get.back(result: true);
          },
            child: Buttons(heigh: 40, width: 60, color: Colors.green, text: "Yes", radius: BorderRadius.circular(15.r))),
        GestureDetector(
          onTap: (){
            Get.back(result: false);
          },
            child: Buttons(heigh: 40, width: 60, color: Colors.red, text: "No", radius: BorderRadius.circular(15.r))),
      ],
    )
  );
}