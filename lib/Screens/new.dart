import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
   late double height;
   late double width;


  @override
  Widget build(BuildContext context) {

                   // Define Size //

    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

               // Initialize the Screen Util //
    ScreenUtil.init(context,designSize: Size(width, height),minTextAdapt: true);
    return Scaffold(
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        if(width<=450){
          return _smallBuildLayout();
        }
        else{
          return const Text("It's adapt's only mobile Screen Devices ");
        }
      },
      ),
    );
  }
  Widget _smallBuildLayout(){
    return Stack(
      children: [
        Positioned(
          top: 30.h,
            left: 0,
            right: 0,
            child: _buildAppBar()
        ),
        Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBody()
        )
      ],
    );
  }
                     // App Bar //
  Widget _buildAppBar(){
    return AppBar(
      leading: const Icon(Icons.menu),
      title: const Text(""),
      actions: const [
        Icon(Icons.qr_code),
        Icon(Icons.keyboard_voice),
      ],
    );
  }

                      // Body //
 Widget _buildBody(){
    return SizedBox(
      width: width.w,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height/10.h,
              width: width/3.w,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(15.r),
              ),
            )

          ],
        ),
      ),
    );
 }
}
