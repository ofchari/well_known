import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:well_known/Screens/login.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  late double height;
  late double width;
  
  String FullName = '';
  String Company = '';
  String Status = '';
  String Gender = '';
  String DOB = '';
  String DOJ = '';
  String Empcnt = '';
  String Relation = '';
  String phno = '';
  String Aadhar = '';
  String Bank = '';
  String Pan = '';
  String Acc_ = '';
  String Ifsc = '';
  @override
  void initState() {
    super.initState();
    UserDetails();
  }

  Future<void> UserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');

    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);
    var response = await ioClient.get(
      Uri.parse(
          'https://erp.wellknownssyndicate.com/api/resource/Employee/$storedUsername'),
      headers: {
        'Authorization': 'token c5a479b60dd48ad:d8413be73e709b6',
      },

    );

    print(json.decode(response.body));
    print(json.decode(response.body)["data"]);

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
         FullName = (data['data']['first_name']).toString();
         Company = (data['data']['company']).toString();
         Status = (data['data']['status']).toString();
         Gender = (data['data']['gender']).toString();
         DOB = (data['data']['date_of_birth']).toString();
         DOJ = (data['data']['date_of_joining']).toString();
         Empcnt = (data['data']['person_to_be_contacted']).toString();
         Relation = (data['data']['relation']).toString();
         phno = (data['data']['emergency_phone_number']).toString();
         Aadhar = (data['data']['aadhaar_number']).toString();
         Pan = (data['data']['pan_number']).toString();
         Bank = (data['data']['bank_name']).toString();
         Acc_ = (data['data']['bank_ac_no']).toString();
         Ifsc = (data['data']['ifsc_code']).toString();

      });

    }
    else{}

    }
  @override
  Widget build(BuildContext context) {
    // Define Size //
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    
    // Intailize Screen Util //
    ScreenUtil.init(context,designSize: Size(width, height),minTextAdapt: true);

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 70.h,),
              const Headingtext(text: "Profile", color: Colors.black, weight: FontWeight.w500),
              SizedBox(height: 40.h,),
              Card(
                child: Container(
                  height: height/2.55.h,
                  width: width/1.1.w,
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15.r)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Name", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: FullName, color: Colors.black),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                       color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Company", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: Company, color: Colors.black),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Status", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: Status, color: Colors.black),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Gender", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: Gender, color: Colors.black),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Date Of Birth", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: DOB, color: Colors.black),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Date Of Joining", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: DOJ, color: Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h,),
              const Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
              SizedBox(height: 20.h,),
              const Align(
                alignment: Alignment.topLeft,
                  child: Headingtext(text: "   Emergency Contact", color: Colors.green, weight: FontWeight.w500)),
              SizedBox(height: 10.h,),
              Card(
                child: Container(
                  height: height/4.7.h,
                  width: width/1.1.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Emergency Contact name", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: Empcnt, color: Colors.black)
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Releation", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: Relation, color: Colors.black)
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Contact Number", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: phno, color: Colors.black)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              const Align(
                alignment: Alignment.topLeft,
                  child: Headingtext(text: "   Salary Details ", color: Colors.green, weight: FontWeight.w500)),
              SizedBox(height: 10.h,),
              Card(
                child: Container(
                  height: height/2.90.h,
                  width: width/1.1.w,
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15.r)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Bank Name", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: Bank, color: Colors.black),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Pan", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: Pan, color: Colors.black),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Aadhaar", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: Aadhar, color: Colors.black),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "Bank_Acc", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: Acc_, color: Colors.black),
                        ],
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Subhead(text: "IFSC_code", colo: Colors.black, weight: FontWeight.w600),
                          Mytext(text: Ifsc, color: Colors.black),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h,),

              Container(
                height: 50,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Center(child: GestureDetector(
                  onTap: (){
                    // Get.off(Welcome());
          
                    SharedPreferences.getInstance().then((prefs){
                      prefs.clear();
                    });
                    Get.off(const Login());
                  },
                    child: const Mytext(text: "Logout", color: Colors.white))),
              ),
              SizedBox(height: 30.h,),
            ],
          ),
        ),
      ),
    );
  }
}
