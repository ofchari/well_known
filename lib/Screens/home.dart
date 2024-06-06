import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/utils/refreshdata.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        ScreenUtil.init(context,designSize: Size(width, height),minTextAdapt: true);
        if(width <=600){
          return _smallbuildlayout();
        }
        return Text("Large");
      },
      ),
    );
  }
  Widget _smallbuildlayout(){
    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
          ],
        ),
      ),


    );
  }
}
