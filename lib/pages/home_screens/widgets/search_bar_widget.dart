import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),

      child: Row(
        children: [
          Expanded(
            child: Container(
              // width: screenWidth * .75,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(2, 1),
                    spreadRadius: 5,
                    blurRadius: 8,
                    color: Color(0x1a256AFD),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  const SizedBox(width: 5),
                  const Icon(LucideIcons.search),
                  const SizedBox(width: 7),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        // prefixIcon: Icon(LucideIcons.search),
                        hintText: 'Recherche',
                        hintStyle: TextStyle(fontSize: 14),
                        //
                        fillColor: Colors.amber,
                        focusColor: Colors.blue,
                        border: InputBorder.none,

                        //
                      ),
                    ),
                  ),
                  //
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xb3d9d9d9),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Row(
                      children: [
                        Icon(LucideIcons.home, size: 16),
                        SizedBox(width: 5),
                        Text('Villa', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 7),
                        Icon(Icons.keyboard_arrow_down, size: 17),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFF256AFD),
            ),
            child: const Icon(LucideIcons.map, color: Colors.white, size: 17),
          ),
        ],
      ),
    );
  }
}
