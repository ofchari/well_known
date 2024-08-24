import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late double height;
  late double width;
  final ScrollController _controller = ScrollController();


  @override
  Widget build(BuildContext context) {
      // Define Size //
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

        // Initialize the Screen Util //
    ScreenUtil.init(context,designSize:  Size(width, height),minTextAdapt: true);
    return Scaffold(
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        if(width<=450){
          return _smallBuildLayout();
          // Mobile Screen Devices //
        }
        else{
          return const Text("It's adapts only for Mobile Screen Devices");
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
      child: SingleChildScrollView(
        controller: _controller,
        child: const Column(
          children: [


          ],
        ),
      ),

      );
  }
}
