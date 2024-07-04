import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Searchingbar extends StatefulWidget {
  const Searchingbar({super.key});

  @override
  State<Searchingbar> createState() => _SearchingbarState();
}

class _SearchingbarState extends State<Searchingbar> {
  late double height;
  late double width;
  final textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
      // Define Size //
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
     //Initialize the Screen Util //
    ScreenUtil.init(context,designSize: Size(width, height),minTextAdapt: true);

    return Scaffold(
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        height = constraints.maxWidth;
        if(width<=450){
          return _smallBuildLayout();
        }
        else{
          return const Text("Please make sure your devices is Mobile");
        }
      },)

    );
  }
  Widget _smallBuildLayout(){
    return Stack(
      children: [
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          bottom: 0,
            child: _buildBody()
        )
      ],
    );
  }
                     //Body //
  Widget _buildBody(){
    return SizedBox(
      width: width.w,
      child: Column(
        children: [
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimSearchBar(
              width: 400,
              textController: textcontroller,
              onSuffixTap: (){
                setState(() {
                  textcontroller.clear();
                });

              }, onSubmitted: (String ) {
              setState(() {

              });
            },
              animationDurationInMilli: 400,

            ),
          ),
        ],
      ),
    );
  }
}
