
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:well_known/Screens/dashboard.dart';
import 'package:well_known/Screens/login.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/text.dart';

import '../Utils/refreshdata.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
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
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          height = constraints.maxHeight;
          width = constraints.maxWidth;
          ScreenUtil.init(context,designSize: Size(width, height),minTextAdapt: true);
          if(width<=450){
            return _smallBuildLayout();
          }
          else{
            return const Text("Large");
          }
        },
        ),
      ),
    );
  }
  Widget _smallBuildLayout(){
    return Stack(
      children: [
        Positioned(
          top: 80,
          left: 0,
          right: 0,
            child: _buildBody(),
        )
      ],
    );
  }
  Widget _buildBody(){
    return  SizedBox(
      width: width.w,
      child: Column(
        children: [
          const SizedBox(height: 70,),
          Image.asset(
              height: 300,
              width: 300,
              "assets/well_know.png"),
          const SizedBox(height: 20,),
          Text("Get Start",style: GoogleFonts.outfit(textStyle: const TextStyle(fontSize: 23,fontWeight: FontWeight.w600,color: Colors.black)),),
          const SizedBox(height: 20,),
          Mytext(text: "Begin your journey to a better lifestyle  Fooffit", color: Colors.green.shade900),
          const SizedBox(height: 30,),
          GestureDetector(
            onTap: (){
              Get.off( const Login());
            },
            child: Container(
              height: height/18,
              width: width/1.2,
              decoration: BoxDecoration(
                  color: const Color(0xffff035e32),
                  borderRadius: BorderRadius.circular(2)
              ),
              child: const Center(child: Mytext(text: "Start Now", color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
