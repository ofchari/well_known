// import 'package:flutter/material.dart';
// import 'package:flutter_intro/flutter_intro.dart';
//
// class OnboardingScreen extends StatelessWidget {
//   final Intro intro = Intro(
//     // stepCount: 3,
//     padding: const EdgeInsets.all(8.0),
//     borderRadius: BorderRadius.circular(11.0),
//     maskColor: Colors.blue,
//       buttonTextBuilder: texts, child: Text(), [
//     'Welcome to our app!',
//     'Explore the features.',
//     'Get started now!',
//     ],
//     ),
//   );
//
//   var child;
//
//   OnboardingScreen({super.key, required this.child});
//
//   static get texts => null;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Intro Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             intro.start();
//           },
//           child: Text('Start Onboarding'),
//         ),
//       ),
//     );
//   }
// }
