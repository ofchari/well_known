import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Subhead extends StatefulWidget {
  const Subhead({super.key,required this.text,required this.colo, required this.weight});
  final String text;
  final Color colo;
  final FontWeight weight;

  @override
  State<Subhead> createState() => _SubheadState();
}

class _SubheadState extends State<Subhead> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text,style: GoogleFonts.outfit(textStyle: TextStyle(fontSize: 17,fontWeight: widget.weight,color: widget.colo)),);
  }
}
