import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double height;
  late double width;

   final List<String> a =
  [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuIZbU5T0ncHQY1T2fL0rgzMErgjZ7UK7ELw&s",
    "https://framerusercontent.com/images/36qyACq2D9HaLA5biRBqQadLHR0.png",
    "https://storage.googleapis.com/cms-storage-bucket/50c707a80fe015e19d39.png",
    "https://ih1.redbubble.net/image.4598476168.2173/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.jpg",
  ];

   bool _enabled = true;
   String daily = "Hari krish";

                      // Show dialog for back  //
  Future<bool> _onScope() async{
    return await Get.dialog(
        AlertDialog(
          title: const Text("Are you sure wan to go back?"),
          actions: [
            GestureDetector(
                onTap: (){
                  Get.back(result: true);
                },
                child: const Text("Yes")),
            GestureDetector(
              onTap: (){
                Get.back(result: false);
              },
                child: const Text("No")),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
       // Define Size //
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
          // Initialize the Screen util //
    ScreenUtil.init(context,designSize: Size(width, height),minTextAdapt: true);
    return WillPopScope(
      onWillPop: _onScope ,
      child: Scaffold(
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          height = constraints.maxHeight;
          width = constraints.maxWidth;
          if(width<=450){
            return _smallBuildLayout();
          }
          else{
            return const Text("Please make sure you devices is Mobile");
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
          top: 0,
          left: 0,
          right: 0,
            child: _buildAppBar()
        ),
        Positioned(
            top: 100.h,
            left: 0,
            right: 0,
            child: _buildBody()
        ),
      ],
    );
  }
                         // App Bar //
  Widget _buildAppBar(){
    return AppBar(
      leading:  const Icon(Icons.arrow_back),
      title: const Text("Hii"),
      actions: const [
        Icon(Icons.menu),
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
            SizedBox(height: 100.h,),
            const Center(child: Text("Hellos")),
            SizedBox(height: 30.h,),
            Skeletonizer(
              enabled: _enabled,
              enableSwitchAnimation: true,
              child: SizedBox(
                height: height/2.h,
                width: width/1.w,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index){
                    return Column(
                      children: [
                        Card(
                          child: Container(
                            height: height/5.h,
                            width: width/2.w,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: NetworkImage("https://ih1.redbubble.net/image.4598476168.2173/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.jpg")
                              ),
                              borderRadius: BorderRadius.circular(15.r)
                            ),
                          ),
                        ),
                        const Text(
                            ""
                        )
                      ],
                    );
                    }
                ),
              ),
            ),
            FloatingActionButton(
                onPressed: (){
                  setState(() {
                    _enabled = !_enabled;
                  });

                },child: Icon(
              _enabled? Icons.subtitles_rounded : Icons.add,
              color: _enabled? Colors.yellow : Colors.blue,



            ),
                )

          ],
        ),
      ),
    );
  }


}
//


