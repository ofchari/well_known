import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Samples extends StatefulWidget {
  const Samples({super.key});

  @override
  State<Samples> createState() => _SamplesState();
}

class _SamplesState extends State<Samples> {
  late double height;
  late double width;
  @override
  Widget build(BuildContext context) {
             // Define Size //
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        if(width <= 450){
          return _smallBuildLayout();
        }
        else{
          return const Text("Please Make Sure Your device is in portrait view");
        }
      },
      ),
    );
  }
  Widget _smallBuildLayout(){
    return Stack(
      children: [
        Positioned(
          top: 10.h,
            left: 0,
            right: 0,
            child: _buildAppBar()
        ),
        Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            child: _buildBody()
        )
      ],
    );
  }
              // App Bar //
  Widget _buildAppBar(){
    return AppBar(
      leading:  const Icon(Icons.menu),
      title: const Text("Well Known"),
      automaticallyImplyLeading: true,
    );
  }

              // Body //
 Widget _buildBody(){
    return SizedBox(
      width: width.w,
      child: const Column(
        children: [
          
        ],
      ),
    );
 }
}

