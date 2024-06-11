import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:well_known/Screens/New_Invoice.dart';
import 'package:well_known/Utils/refreshdata.dart';
import 'package:well_known/Widgets/buttons.dart';
import 'package:well_known/Widgets/text.dart';
import '../Widgets/heading_text.dart';

class NewproformaVoice extends StatefulWidget {
  const NewproformaVoice({super.key});

  @override
  State<NewproformaVoice> createState() => _NewproformaVoiceState();
}

class _NewproformaVoiceState extends State<NewproformaVoice> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            height = constraints.maxHeight;
            width = constraints.maxWidth;
            ScreenUtil.init(context, designSize: Size(width, height), minTextAdapt: true);
            if (width <= 450) {
              return _smallBuildLayout();
              // Mobile Screen Sizes //
            } else {
              return const Text("Large");
            }
          },
        ),
      ),
    );
  }

  Widget _smallBuildLayout() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Headingtext(text: "  New Proforma Invoice", color: Colors.black, weight: FontWeight.w400),
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Color(0xffff035e32)),
                      labelText: "  Customer",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      height: height / 14,
                      width: width / 2.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range, color: Colors.blue),
                            const SizedBox(width: 8), // Added spacing for better UI
                            Text(
                              ' ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 15.8,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Container(
                      height: height / 14,
                      width: width / 2.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.green)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range, color: Colors.blue),
                            const SizedBox(width: 8), // Added spacing for better UI
                            Text(
                              ' ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 15.8,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.group, color: Color(0xffff035e32)),
                      labelText: "Customer group",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.terrain, color: Color(0xffff035e32)),
                      labelText: "Territory",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.place_outlined, color: Color(0xffff035e32)),
                      labelText: "Customer Address",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.contact_mail, color: Color(0xffff035e32)),
                      labelText: "Contact Person",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.stacked_line_chart, color: Color(0xffff035e32)),
                      labelText: "Sales Person",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.call, color: Color(0xffff035e32)),
                      labelText: "Mobile No",
                      labelStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)))),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: (){
                  Get.to(const Newinvoice());
                },
                child: Buttons(
                    heigh: height / 20,
                    width: width / 1.8,
                    color: const Color(0xffff035e32),
                    text: "Next",
                    radius: BorderRadius.circular(16)),
              ),
              const SizedBox(height: 30,),
            ],
          ),

        ),
      ),
    );
  }
}
