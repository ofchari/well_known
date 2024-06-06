import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Mytext extends StatefulWidget {
  const Mytext({super.key,required this.text,required this.color});
  final String text;
  final Color color;

  @override
  State<Mytext> createState() => _MytextState();
}

class _MytextState extends State<Mytext> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text,style: GoogleFonts.dmSans(textStyle: TextStyle(fontSize: 15.2.sp,fontWeight: FontWeight.w500,color: widget.color)),);
  }
}
