import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PopScopeProvider extends ChangeNotifier{
  Future<bool> popgetout(BuildContext context) async{
    notifyListeners();
    return await Get.dialog(
      AlertDialog(
        title: Text("Are You sure want to exit?",style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500,color: Colors.blue)),),
        actions: [
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),onPressed: (){
            Get.back(result: true);
          }, child: Text("Yes",style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white)),)),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),onPressed: (){
           Get.back(result: false);
          }, child: Text("No",style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white)))),
        ],

      )
    );
  }
}