import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Headingtext extends StatefulWidget {
  const Headingtext({super.key,required this.text,required this.color,required this.weight});
  final String text;
  final Color color;
  final FontWeight weight;

  @override
  State<Headingtext> createState() => _HeadingtextState();
}

class _HeadingtextState extends State<Headingtext> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text,style: GoogleFonts.outfit(textStyle: TextStyle(fontSize: 20.5,fontWeight: widget.weight,color: widget.color)),);
  }
}
