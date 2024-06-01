import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:well_known/Screens/dashboard.dart';
import 'package:well_known/Widgets/subhead.dart';
import 'package:well_known/Widgets/text.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:ui' as ui;

import 'package:well_known/utils/refreshdata.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late double height;
  late double width;
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: refreshdata,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          height = constraints.maxHeight;
          width = constraints.maxWidth;
          ScreenUtil.init(context, designSize: Size(width, height), minTextAdapt: true);
          if (width <= 600) {
            return _smallbuildlayout();
          } else {
            return Text("Large");
          }
        },
        ),
      ),
    );
  }

  Widget _smallbuildlayout() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xffFF035e32),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 60,),
              Center(child: Subhead(text: "LOGIN", colo: Colors.white, weight: FontWeight.w500)),
              SizedBox(height: 30,),
              Form(
                key: _key,
                child: Container(
                  height: height / 2.0.h,
                  width: width / 1.2.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50,),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Mytext(text: "  EMAIL", color: Colors.black,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail_lock_outlined, color: Colors.grey,),
                            ),
                            validator: (email) {
                              if (email == null || email.isEmpty || !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Mytext(text: "  PASSWORD", color: Colors.black,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_person_outlined, color: Colors.grey,),
                            ),
                            validator: (password) {
                              if (password == null || password.isEmpty || password.length < 3) {
                                return 'Please enter a valid password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                        const Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Mytext(text: "Forgot Password? ", color: Colors.green),
                            )),
                        SizedBox(height: 10,),
                        Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (_key.currentState!.validate()) {
                                    if (_emailController.text == "regent@gmail.com" &&
                                        _passwordController.text == "abc@123") {
                                      Get.off(Dashboard());
                                    } else {
                                      Get.snackbar(
                                        "Error",
                                        "Invalid email or password",
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  height: height / 16.h,
                                  width: width / 6.w,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green
                                  ),
                                  child: Icon(Icons.arrow_forward, color: Colors.white,),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: height / 5.5.h,
                width: width / 1.2.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Subhead(text: "Contact Us", colo: Colors.black, weight: FontWeight.w600),
                        )),
                    SizedBox(height: 10,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                            height: 45,
                            // width: 200,
                            "assets/insta.png"),
                        Image.network(
                            height: 45,
                            "https://static.vecteezy.com/system/resources/previews/014/414/666/non_2x/whatsapp-black-logo-on-transparent-background-free-vector.jpg"),
                        Image.network(
                            height: 45,
                            "https://i.pinimg.com/originals/bd/51/0c/bd510c9c46e3c3a1388776dfb11f5ed9.png"),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    const Mytext(text: "     Already have an account?", color: Colors.white),
                    Text("   Click Here", style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white, decorationThickness: 1)),)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
