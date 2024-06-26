import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {

  late double height;
  late double width;
  @override
  Widget build(BuildContext context) {
      // Define size //
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
          // Mobile Screen Sizes //
        }
        else{
          return const Text("Please make sure your devices is Mobile");
        }
      },),

    );
  }
  Widget _smallBuildLayout(){
    return Stack(
      children: [
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
                         // Body //
 Widget _buildBody(){
    return SizedBox(
      width: width.w,
      child: Column(
        children: [
          SizedBox(height: 230.h,),
          SizedBox(
            height: height/5.5.h,
              child: Image.network("https://t4.ftcdn.net/jpg/03/61/78/21/360_F_361782151_rzuacg30qdRdPulRFqkJJ53osTLXX7nE.jpg"))
        ],
      ),
    );
 }
}