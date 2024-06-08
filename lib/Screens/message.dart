import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 350,),
            Container(
              height: 160,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage("https://t4.ftcdn.net/jpg/03/61/78/21/360_F_361782151_rzuacg30qdRdPulRFqkJJ53osTLXX7nE.jpg")
                )
              ),
            ),
          ],
        )
      ),
    );
  }
}
