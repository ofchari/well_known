import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class Scrolls extends StatefulWidget {
  const Scrolls({super.key});

  @override
  State<Scrolls> createState() => _ScrollsState();
}

class _ScrollsState extends State<Scrolls> {

  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 120),
              SizedBox(
                height: 700,
                width: double.infinity,
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: 100,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 700),
                        child: SlideAnimation(
                          verticalOffset: 30,
                          child: FadeInAnimation(
                            duration: const Duration(seconds: 5),
                            delay: const Duration(seconds: 1),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 200,
                                    width: 300,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Colors.grey,
                                          offset: Offset( -4, 6)
                                        )
                                      ]
                                    ),
                                    child: Column(
                                      children: [
                                        AnimSearchBar(
                                            width: 300,
                                            textController: _controller,
                                            onSuffixTap: (){
                                              _controller.clear();

                                            },
                                            onSubmitted: (String){
                                              setState(() {

                                              });

                                            }
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
