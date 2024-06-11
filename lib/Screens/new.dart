import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:well_known/Widgets/heading_text.dart';
import 'package:well_known/Widgets/text.dart';

class Newsprofo extends StatefulWidget {
  const Newsprofo({super.key});

  @override
  State<Newsprofo> createState() => _NewsprofoState();
}

class _NewsprofoState extends State<Newsprofo> {
  late double height;
  late double width;


  @override
  Widget build(BuildContext context) {
    // define size //
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        ScreenUtil.init(context,designSize: Size(width, height),minTextAdapt: true);
        if(width <=450){
          return _smallBuildLayout();
          // Mobile screen sizes //
        }
        else{
          return const Text("Large");
        }
      },
      ),
    );
  }
  Widget _smallBuildLayout(){
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
            child: _buildAppBar(),
        ),
        Positioned(
          top: 60,
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBody(),
        )
      ],
    );
  }
  // App Bar //
  Widget _buildAppBar(){
    return AppBar(
      toolbarHeight: 80.h,
      title: const Mytext(text: "Hello Team members", color: Colors.black),
      actions: const [
        Icon(Icons.filter_alt_sharp,color: Colors.blue,)
      ],
    );
  }
           // Body //
  Widget _buildBody(){
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Headingtext(text: "Hey!>", color: Colors.blue, weight: FontWeight.w500),
            const SizedBox(height: 20,),
            const Mytext(text: "Hello", color: Colors.blue),
            Container(
              height: height/5.h,
              width: width/3.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  // The images comes from the Network //
                  image: NetworkImage("https://cdn.pixabay.com/photo/2022/01/30/13/33/github-6980894_1280.png"),fit: BoxFit.cover
                )
              ),
            )

          ],
        ),
      ),
    );
  }
}


