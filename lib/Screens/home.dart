import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'message.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late double height;
  late double width;
  final _introKey = GlobalKey<IntroductionScreenState>();


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
          // Mobile Screen Devices //
        }
        else{
          return Text("It's adapts only for Mobile Screen Devices");
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
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: height, // Ensure minimum height constraint
              maxHeight: height, // Ensure maximum height constraint
            ),
            child: IntroductionScreen(
              key: _introKey,
              pages: [
                PageViewModel(
                  title: "Hello",
                  body: "This is the first page",
                  image: Icon(Icons.access_alarm),
                  decoration: const PageDecoration(
                    pageColor: Colors.green,
                  ),
                ),
                PageViewModel(
                  title: "Hii",
                  body: "This is the second page",
                  image: Container(
                    height: 100,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        image: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjbOlY9VSsWNUyjswk-hpJYX52pV1bC5I-rQ&s",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: const PageDecoration(
                    pageColor: Colors.blue,
                  ),
                ),
                PageViewModel(
                  title: "Hello",
                  body: "This is the third page",
                  image: Container(
                    height: height/7.h,
                    width: width/3.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      image: DecorationImage(
                        image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjbOlY9VSsWNUyjswk-hpJYX52pV1bC5I-rQ&s"),fit: BoxFit.cover
                      )
                    ),

                  ),
                  decoration:  PageDecoration(
                    pageColor: Colors.orange,
                  ),
                ),
              ],
              onDone: () {
                Get.off(const Message());
              },
              onSkip: () {
                Get.off(const Message());
              },
              showSkipButton: false,
              skip: const Icon(Icons.skip_next),
              next: const Icon(Icons.navigate_next),
              done: const Text("Done Successfully"),
              back: const Text("Back"),
              globalBackgroundColor: Colors.white,
              showBackButton: true,
              dotsDecorator: const DotsDecorator(
                size: Size.square(10.0),
                activeSize: Size(22.0, 10.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
        ],
      ),

      );
  }
}
