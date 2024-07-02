import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class Searchingbar extends StatefulWidget {
  const Searchingbar({super.key});

  @override
  State<Searchingbar> createState() => _SearchingbarState();
}

class _SearchingbarState extends State<Searchingbar> {
  final textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimSearchBar(
                  width: 400,
                  textController: textcontroller,
                  onSuffixTap: (){
                    setState(() {
                      textcontroller.clear();
                    });

                  }, onSubmitted: (String ) {
                    setState(() {

                    });
              },
                animationDurationInMilli: 400,

              ),
            )
          ],
        ),
      ),
    );
  }
}
