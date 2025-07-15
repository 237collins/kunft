// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:flutter/material.dart';

class WidgetAnimation3 extends StatefulWidget {
  final String img;

  const WidgetAnimation3({Key? superkey, required this.img})
    : super(key: superkey);

  @override
  State<WidgetAnimation3> createState() => _WidgetAnimation3State();
}

class _WidgetAnimation3State extends State<WidgetAnimation3> {
  bool _showFirstChild = true;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // Container(
        //   height: screenHeight * .3,
        //   decoration: BoxDecoration(
        //     color: Colors.grey[300],
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: Center(
        //     child: ClipRRect(
        //       borderRadius: BorderRadius.circular(20),
        //       child: Image.network(
        //         widget.img,
        //         fit: BoxFit.cover,
        //         width: double.infinity,
        //       ),
        //     ),
        //   ),
        // ),
        //
        AnimatedSwitcherPlus.translationRight(
          duration: const Duration(milliseconds: 800),
          child: Container(
            key: ValueKey(_showFirstChild),
            // padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              // color: _showFirstChild ? Colors.blue.shade50 : Colors.red.shade50,
              // borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Container(
              height: screenHeight * .3,
              decoration: BoxDecoration(
                // color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child:
                  _showFirstChild
                      ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              widget.img,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          //
                          Positioned(
                            bottom: 6,
                            child: Container(
                              padding: EdgeInsets.only(right: 10),
                              height: screenHeight * .15,
                              width: screenWidth * .95,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  // topLeft: Radius.circular(50),
                                  // topRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black45],
                                ),
                              ),
                              // child:
                            ),
                          ),
                        ],
                      )
                      : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              widget.img,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          //
                          Positioned(
                            bottom: 0,
                            child: Container(
                              padding: EdgeInsets.only(right: 10),
                              height: screenHeight * .15,
                              width: screenWidth * .95,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  // topLeft: Radius.circular(50),
                                  // topRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black45],
                                ),
                              ),
                              // child:
                            ),
                          ),
                        ],
                      ),
            ),

            // Text(
            //   _showFirstChild ? 'Primary Text' : 'Secondary Text',
            // ),
          ),
        ),

        // AnimatedSwitcherPlus.flipX(
        //   duration: const Duration(milliseconds: 1500),
        //   child: Container(
        //     height: screenHeight * .3,
        //     decoration: BoxDecoration(
        //       color: Colors.grey[300],
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     child: Stack(
        //       children: [
        //         ClipRRect(
        //           borderRadius: BorderRadius.circular(20),
        //           child: Image.network(
        //             widget.img,
        //             fit: BoxFit.cover,
        //             width: double.infinity,
        //           ),
        //         ),
        //         //
        //         Positioned(
        //           bottom: 0,
        //           child: Container(
        //             padding: EdgeInsets.only(right: 10),
        //             height: screenHeight * .15,
        //             width: screenWidth * .95,
        //             decoration: const BoxDecoration(
        //               borderRadius: BorderRadius.only(
        //                 // topLeft: Radius.circular(50),
        //                 // topRight: Radius.circular(50),
        //                 bottomLeft: Radius.circular(20),
        //                 bottomRight: Radius.circular(20),
        //               ),
        //               gradient: LinearGradient(
        //                 begin: Alignment.topCenter,
        //                 end: Alignment.bottomCenter,
        //                 colors: [Colors.transparent, Colors.black45],
        //               ),
        //             ),
        //             // child:
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),

        //   //  _showFirstChild ?
        //   //   const Text('Primary Text', key: ValueKey(0)) :
        //   //   const Text('Secondary Text', key: ValueKey(1)),
        // ),

        //
      ],
    );
  }
}
