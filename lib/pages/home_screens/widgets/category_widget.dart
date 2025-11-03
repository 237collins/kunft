import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  final String name;

  const CategoryWidget({super.key, required this.name});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, 3),
            spreadRadius: 4,
            blurRadius: 8,
            color: Color(0x1a256AFD),
          ),
        ],
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Widget Hotel
                // Column(
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 12,
                //         vertical: 12,
                //       ),
                //       decoration: BoxDecoration(
                //         color: const Color(0xb3e9e9e9),
                //         borderRadius: BorderRadius.circular(50),
                //       ),
                //       child: const Column(children: [Icon(Icons.home_filled)]),
                //     ),
                //     //
                //     const SizedBox(height: 5),
                //     const Text('Hôtel', style: TextStyle(fontSize: 12)),
                //   ],
                // ),
                // SizedBox(width: 40),
                //
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xb3e9e9e9),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.home_filled, color: Color(0xff256AFD)),
                        ],
                      ),
                    ),
                    //
                    const SizedBox(height: 5),
                    const Text('Rési...', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(width: 40),

                //
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xb3e9e9e9),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.home_filled, color: Color(0xff256AFD)),
                        ],
                      ),
                    ),
                    //
                    const SizedBox(height: 5),
                    const Text('Villa', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(width: 40),

                //
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xb3e9e9e9),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.home_filled, color: Color(0xff256AFD)),
                        ],
                      ),
                    ),
                    //
                    const SizedBox(height: 5),
                    const Text('Appart...', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(width: 40),
                //
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xb3e9e9e9),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.home_filled, color: Color(0xff256AFD)),
                        ],
                      ),
                    ),
                    //
                    const SizedBox(height: 5),
                    const Text('Studio', style: TextStyle(fontSize: 12)),
                  ],
                ),
                // SizedBox(width: 40),
                //
                // Column(
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 12,
                //         vertical: 12,
                //       ),
                //       decoration: BoxDecoration(
                //         color: const Color(0xb3e9e9e9),
                //         borderRadius: BorderRadius.circular(50),
                //       ),
                //       child: const Column(children: [Icon(Icons.home_filled)]),
                //     ),
                //     //
                //     const SizedBox(height: 5),
                //     const Text('Chambre', style: TextStyle(fontSize: 12)),
                //   ],
                // ),
              ],
            ),
          ),
          //
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x80d9d9d9),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 2, color: const Color(0xccd9d9d9)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [SizedBox(width: 8), Text('Les Catégories')]),
                //
                Icon(Icons.keyboard_arrow_right_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
