import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:well_known/Screens/dashboard.dart';

class navigat extends StatefulWidget {
  const navigat({super.key});

  @override
  State<navigat> createState() => _navigatState();
}

class _navigatState extends State<navigat> {
  int currentindex = 0;

  final pages = [
    Dashboard(),
    '',
    '',
    '',
  ];
  void krish(index){
    setState(() {
      currentindex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
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
                child: IconButton(onPressed: (){}, icon: Icon(Icons.home,color: Colors.black,)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: IconButton(onPressed: (){}, icon: Icon(Icons.message,color: Colors.black,)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: IconButton(onPressed: (){}, icon: Icon(Icons.settings,color: Colors.black,)),
              ),
            ],
          ),

        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffFF035e32),
        onPressed: () {  },child: Icon(Icons.search,color: Colors.white,),
      ),


    );
  }
}
