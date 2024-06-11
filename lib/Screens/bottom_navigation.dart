import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:well_known/Screens/New_Invoice.dart';
import 'package:well_known/Screens/dashboard.dart';
import 'package:well_known/Screens/items.dart';
import 'package:well_known/Screens/message.dart';

class navigat extends StatefulWidget {
  const navigat({super.key});

  @override
  State<navigat> createState() => _navigatState();
}

class _navigatState extends State<navigat> {
  int currentindex = 0;

  final pages = [
    const Dashboard(),
    const Message(),
    const Message(),

  ];
  void krish(index){
    setState(() {
      currentindex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentindex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.blue,
              width: 2,
            )
          )
        ),
        child: BottomAppBar(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: IconButton(onPressed: (){
                  setState(() {
                    currentindex = 0;
                  });
                }, icon: const Icon(Icons.home,color: Colors.black,)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: IconButton(onPressed: (){
                  setState(() {
                    currentindex = 1;
                  });
                }, icon: const Icon(Icons.message,color: Colors.black,)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: IconButton(onPressed: (){
                  setState(() {
                    currentindex = 2;
                  });
                }, icon: const Icon(Icons.settings,color: Colors.black,)),
              ),
            ],
          ),

        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffff035e32),
        onPressed: () {
          Get.to(const Items());
        },child: const Icon(Icons.search,color: Colors.white,),
      ),
    );
  }
}
