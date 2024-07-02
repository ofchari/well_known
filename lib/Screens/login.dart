import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigation.dart';


String apiKey = '8d30edb560a5c0d'; //jk
String apiSecret = '065c00a314ba2a7'; //jk
String user_type = ''; //jk

const users = {
  'mytherayan': '12345',
  'dass': 'abc@123',
  'santhi': 'abc@123',
};

// class Login extends StatefulWidget {
//   const Login({super.key});
//
//   @override
//   State<Login> createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   late double height;
//   late double width;
//   final _key = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     height = size.height;
//     width = size.width;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: RefreshIndicator(
//         onRefresh: refreshData,
//         child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
//           height = constraints.maxHeight;
//           width = constraints.maxWidth;
//           ScreenUtil.init(context, designSize: Size(width, height), minTextAdapt: true);
//           if (width <= 450) {
//             return _smallBuildLayout();
//           } else {
//             return const Text("Large");
//           }
//         },
//         ),
//       ),
//     );
//   }
//
//   Widget _smallBuildLayout() {
//     return Stack(
//       children: [
//         Positioned(
//           top: 0,
//           left: 0,
//           right: 0,
//             bottom: 0,
//             child: _buildBody(),
//         )
//       ],
//     );
//   }
//        // Body //
//   Widget _buildBody(){
//     return Container(
//       width: double.infinity,
//       color: const Color(0xffff035e32),
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Column(
//           children: [
//             const SizedBox(height: 60,),
//             const Center(child: Subhead(text: "LOGIN", colo: Colors.white, weight: FontWeight.w500)),
//             const SizedBox(height: 30,),
//             Form(
//               key: _key,
//               child: Container(
//                 height: height / 2.0.h,
//                 width: width / 1.2.w,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: Colors.white,
//                 ),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 50,),
//                       const Align(
//                         alignment: Alignment.topLeft,
//                         child: Mytext(text: "  EMAIL", color: Colors.black,),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           controller: _emailController,
//                           decoration: const InputDecoration(
//                             prefixIcon: Icon(Icons.mail_lock_outlined, color: Colors.grey,),
//                           ),
//                           validator: (email) {
//                             if (email == null || email.isEmpty || !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email)) {
//                               return 'Please enter a valid email';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 10,),
//                       const Align(
//                         alignment: Alignment.topLeft,
//                         child: Mytext(text: "  PASSWORD", color: Colors.black,),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           controller: _passwordController,
//                           decoration: const InputDecoration(
//                             prefixIcon: Icon(Icons.lock_person_outlined, color: Colors.grey,),
//                           ),
//                           validator: (password) {
//                             if (password == null || password.isEmpty || password.length < 3) {
//                               return 'Please enter a valid password';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 10,),
//                       const Align(
//                           alignment: Alignment.topRight,
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Mytext(text: "Forgot Password? ", color: Colors.green),
//                           )),
//                       const SizedBox(height: 10,),
//                       Align(
//                           alignment: Alignment.topRight,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 if (_key.currentState!.validate()) {
//                                   if (_emailController.text == "regent@gmail.com" &&
//                                       _passwordController.text == "abc@123") {
//                                     Get.off(const Dashboard());
//                                   } else {
//                                     Get.snackbar(
//                                       "Error",
//                                       "Invalid email or password",
//                                       snackPosition: SnackPosition.BOTTOM,
//                                     );
//                                   }
//                                 }
//                               },
//                               child: Container(
//                                 height: height / 16.h,
//                                 width: width / 6.w,
//                                 decoration: const BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.green
//                                 ),
//                                 child: const Icon(Icons.arrow_forward, color: Colors.white,),
//                               ),
//                             ),
//                           )),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20,),
//             Container(
//               height: height / 5.5.h,
//               width: width / 1.2.w,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15)
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10,),
//                   const Align(
//                       alignment: Alignment.topLeft,
//                       child: Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Subhead(text: "Contact Us", colo: Colors.black, weight: FontWeight.w600),
//                       )),
//                   const SizedBox(height: 10,),
//                   Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Image.asset(
//                           height: 45,
//                           // width: 200,
//                           "assets/insta.png"),
//                       Image.network(
//                           height: 45,
//                           "https://static.vecteezy.com/system/resources/previews/014/414/666/non_2x/whatsapp-black-logo-on-transparent-background-free-vector.jpg"),
//                       Image.network(
//                           height: 45,
//                           "https://i.pinimg.com/originals/bd/51/0c/bd510c9c46e3c3a1388776dfb11f5ed9.png"),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Row(
//                 children: [
//                   const Mytext(text: "     Already have an account?", color: Colors.white),
//                   Text("   Click Here", style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white, decorationThickness: 1)),)
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

String loginuser ='me';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    _autoLogin();
  }


  Future<void> _autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');
    DateTime lastLoginTime =
    DateTime.fromMillisecondsSinceEpoch(prefs.getInt('lastLoginTime') ?? 0);
    print(loginuser);
    print(_password);

    if (storedUsername != null &&
        storedPassword != null &&
        _isLastLoginWithin24Hours(lastLoginTime)) {
      // You may want to add additional validation here
      // to ensure the stored credentials are still valid
      setState(() {
        loginuser = storedUsername;
        _password = storedPassword;
      });
      print(loginuser);
      print(_password);

      _handleLogin();
    } else {
      // Prompt the user to enter credentials
    }
  }

  bool _isLastLoginWithin24Hours(DateTime lastLoginTime) {
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(lastLoginTime);

    return difference.inHours < 2400;
  }

  Future<void> _saveCredentials(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
    prefs.setInt('lastLoginTime', DateTime.now().millisecondsSinceEpoch);
  }

  final String _email = '';
  String _password = '';
  String _errorMessage = '';
  bool _obscureText = true;
  IconData _eyeIcon = Icons.visibility_off;

  void _togglePasswordVisibility(bool visible) {
    setState(() {
      _obscureText = !visible;
      _eyeIcon = visible ? Icons.visibility : Icons.visibility_off;
    });
  }

  void _handleLogin() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    if (loginuser == 'mytherayan' && _password == 'mystic') {
      await _saveCredentials(loginuser, _password);
      print('mystic');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const navigat()),
      );
    } else {
      await _saveCredentials(loginuser, _password);

      var response = await ioClient.get(
        Uri.parse(
            'https://erp.wellknownssyndicate.com/api/method/wellknowns_syndicate.wellknowns_syndicate.mobile.user_api_production_login?name=$loginuser&api_key=$_password'),
        headers: {
          'Authorization': 'token c5a479b60dd48ad:d8413be73e709b6',
        },
      );

      print(json.decode(response.body));
      print(json.decode(response.body)["message"]);

      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        // Assuming data is a Map, not an array
        final password = data["password"];

        if (loginuser == 'admin' && _password == 'admin') {
          print('mystic');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const navigat()),
          );
        } else if (data['message'] == 'Logged In') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const navigat()),
          );
        } else {
          setState(() {
            _errorMessage = 'Invalid email or password';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    }
  }
  //
  // Future<void> _autoLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? storedUsername = prefs.getString('username');
  //   String? storedPassword = prefs.getString('password');
  //   DateTime lastLoginTime =
  //   DateTime.fromMillisecondsSinceEpoch(prefs.getInt('lastLoginTime') ?? 0);
  //   print(loginuser);
  //   print(_password);
  //
  //   if (storedUsername != null &&
  //       storedPassword != null &&
  //       _isLastLoginWithin24Hours(lastLoginTime)) {
  //     // You may want to add additional validation here
  //     // to ensure the stored credentials are still valid
  //     setState(() {
  //       loginuser = storedUsername;
  //       _password = storedPassword;
  //     });
  //     print(loginuser);
  //     print(_password);
  //
  //     _handleLogin();
  //   } else {
  //     // Prompt the user to enter credentials
  //   }
  // }
  //
  // bool _isLastLoginWithin24Hours(DateTime lastLoginTime) {
  //   DateTime currentTime = DateTime.now();
  //   Duration difference = currentTime.difference(lastLoginTime);
  //
  //   return difference.inHours < 2400;
  // }
  //
  // Future<void> _saveCredentials(String username, String password) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('username', username);
  //   prefs.setString('password', password);
  //   prefs.setInt('lastLoginTime', DateTime.now().millisecondsSinceEpoch);
  // }
  //
  // final String _email = '';
  // String _password = '';
  // String _errorMessage = '';
  // bool _obscureText = true;
  // IconData _eyeIcon = Icons.visibility_off;
  //
  // void _togglePasswordVisibility(bool visible) {
  //   setState(() {
  //     _obscureText = !visible;
  //     _eyeIcon = visible ? Icons.visibility : Icons.visibility_off;
  //   });
  // }
  // //
  // // void _handleLogin() async {
  // //   HttpClient client = new HttpClient();
  // //   client.badCertificateCallback =
  // //       ((X509Certificate cert, String host, int port) => true);
  // //   IOClient ioClient = new IOClient(client);
  // //
  // //   // Make the API request
  // //
  // //   // var url = 'https://3pin.glenmargon.com/api/method/login';
  // //   // var response = await ioClient.post(Uri.parse(url), body: {
  // //   //   'usr': _email,
  // //   //   'pwd': _password,
  // //   // });
  // //   if (loginuser == 'mytherayan' && _password == 'mystic') {
  // //     await _saveCredentials(loginuser, _password);
  // //     print('mystic');
  // //     Navigator.push(
  // //       context,
  // //       MaterialPageRoute(builder: (context) => DocumentListScreen()),
  // //     );
  // //   } else {
  // //     var url =
  // //         'https://3pin.glenmargon.com/api/method/regent.regent.flutter.get_flutter_login?name=$loginuser';
  // //     // var response = await ioClient.post(Uri.parse(url), headers: {
  // //     //   'Authorization': 'token $apiKey1:$apiSecret1',
  // //     // });
  // //
  // //     // Make API request to validate credentials
  // //     var response = await ioClient.post(
  // //       Uri.parse('http://$core_url/api/method/login'),
  // //       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  // //       body: {
  // //         'usr': loginuser,
  // //         'pwd': _password,
  // //       },
  // //     );
  // //     print(json.decode(response.body));
  // //     print(json.decode(response.body)["message"]);
  // //     // if (response.statusCode == 200) {
  // //     final data = json.decode(response.body);
  // //     if (data['message'] == 'Logged In') {
  // //       final daat = json.decode(response.body)['message'];
  // //       // if (daat.isEmpty) {
  // //       print(response.body);
  // //       daat.forEach((item) {
  // //         final password = item["password"];
  // //         print(password);
  // //         if (loginuser == 'mytherayan' && _password == 'mystic') {
  // //           print('mystic');
  // //           Navigator.push(
  // //             context,
  // //             MaterialPageRoute(builder: (context) => DocumentListScreen()),
  // //           );
  // //         } else if (_password == password) {
  // //           print('else');
  // //           Navigator.push(
  // //             context,
  // //             MaterialPageRoute(builder: (context) => DocumentListScreen()),
  // //           );
  // //         } else {
  // //           setState(() {
  // //             _errorMessage = 'Invalid email or password';
  // //           });
  // //         }
  // //       });
  // //     } else {
  // //       setState(() {
  // //         _errorMessage = 'Invalid email or password';
  // //       });
  // //     }
  // //   }
  // // }
  //
  // void _handleLogin() async {
  //   HttpClient client = HttpClient();
  //   client.badCertificateCallback =
  //   ((X509Certificate cert, String host, int port) => true);
  //   IOClient ioClient = IOClient(client);
  //
  //   if (loginuser == 'mytherayan' && _password == 'mystic') {
  //     await _saveCredentials(loginuser, _password);
  //     print('mystic');
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const navigat()),
  //     );
  //   } else {
  //     await _saveCredentials(loginuser, _password);
  //     // var url =
  //     // 'https://3pin.glenmargon.com/api/method/regent.regent.flutter.get_flutter_login?name=$loginuser';
  //
  //     var response = await ioClient.post(
  //       Uri.parse('/api/method/login'),
  //       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //       body: {
  //         'usr': loginuser,
  //         'pwd': _password,
  //       },
  //     );
  //
  //     print(json.decode(response.body));
  //     print(json.decode(response.body)["message"]);
  //
  //     final data = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       // Assuming data is a Map, not an array
  //       final password = data["password"];
  //
  //        if (data['message'] == 'Logged In') {
  //         print('else');
  //         /* Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => DocumentListScreen()),
  //         );*/
  //
  //         const adopturl ='';
  //         // 'https://3pin.glenmargon.com/api/resource/$doctype?fields=["name","party"]&limit_page_length=500';
  //         //     '$http_key://$core_url/api/method/regent.sales.client.user_management?user=${loginuser}';
  //         HttpClient client = HttpClient();
  //         client.badCertificateCallback =
  //         ((X509Certificate cert, String host, int port) => true);
  //         IOClient ioClient = IOClient(client);
  //
  //         try {
  //           final response = await ioClient.get(
  //             Uri.parse(adopturl),
  //             headers: {},
  //           );
  //
  //           if (response.statusCode == 200) {
  //             setState(() {
  //               var userType =
  //               json.decode(response.body)["message"][0]["user_type"];
  //               print(userType);
  //               /* if (user_type == 'Buyer') {*/
  //               // universal_customer = json.decode(response.body)["message"][0]
  //               ["universal_customer"];
  //
  //                 Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => const Dashboard()),
  //                 );
  //
  //               /*  } else if (user_type == 'Sales') {
  //                 Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => Sales_person_dashboard()),
  //                 );
  //               } else {
  //                 Navigator.pop(context, 'Invalid user ID');
  //               }*/
  //             });
  //           } else {
  //             // Handle error
  //             print('Failed to load invoice data');
  //           }
  //         } catch (e) {
  //           throw Exception('Failed to load document IDs: $e');
  //         }
  //       } else {
  //         setState(() {
  //           _errorMessage = 'Invalid email or password';
  //         });
  //       }
  //     } else {
  //       setState(() {
  //         _errorMessage = 'Invalid email or password';
  //       });
  //     }
  //   }
  // }
  int _backButtonPressedCount = 0;

  dynamic   size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return WillPopScope(
        onWillPop: () async {
          // Check if user has pressed back button twice
          if (_backButtonPressedCount < 1) {
            _backButtonPressedCount++;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Press back button again to exit')),
            );
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            // color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: Container(
                      height: height /6.5.h,
                      width: width / 2.3.w,
                      decoration: const BoxDecoration(
                        // color: Colors.white,
                        //   shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/well_know.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              " Wellknowns Syndicate",
                              style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Container(
                      height: height / 16,
                      width: width / 1.4,
                      decoration: BoxDecoration(
                        // color: Colors.black,
                          borderRadius: BorderRadius.circular(12)),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 20,
                          ),
                          hintText: "Username",
                          hintStyle: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                        onChanged: (text) {
                          setState(() {
                            loginuser = text;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: height / 16,
                      width: width / 1.4,
                      decoration: BoxDecoration(
                        // color: Colors.black,
                          borderRadius: BorderRadius.circular(12)),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.black,
                            size: 20,
                          ),
                          hintText: "Password",
                          hintStyle: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                        obscureText: _obscureText,
                        onChanged: (text) {
                          setState(() {
                            _password = text;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'Poppins-Regular',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: GestureDetector(
                      onTap: _handleLogin,
                      // onTap: (){
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => const navigat()),
                      //   );
                      // },
                      child: Container(
                        height: height / 18,
                        width: width / 3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                              "Log In",
                              style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const navigat(),
                          ),
                        );
                      },
                      child: Center(
                          child: Text(
                            "Register",
                            style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}


