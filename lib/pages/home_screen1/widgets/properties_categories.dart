import 'package:flutter/material.dart';

class PropertiesCategories extends StatefulWidget {
  const PropertiesCategories({super.key});

  @override
  State<PropertiesCategories> createState() => _PropertiesCategoriesState();
}

class _PropertiesCategoriesState extends State<PropertiesCategories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        // color: const Color(0x0d256AFD),
        border: Border.all(width: 1, color: const Color(0xff256AFD)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              // width: 180,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0x0d256AFD),
                // border: Border.all(width: 1, color: Color(0xff256AFD)),
                borderRadius: BorderRadius.circular(17),
                // borderRadius: BorderRadius.circular(20)
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Résidences',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff256AFD),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Parcourez l\'ensemble de nos résidences disponibles ',
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          //
          const SizedBox(width: 7),
          //
          Expanded(
            child: Container(
              // width: 180,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                color: const Color(0x0d256AFD),
                // border: Border.all(width: 1, color: Color(0xff256AFD)),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Standards',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff256AFD),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Parcourez l\'ensemble de nos logement standard disponibles',
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
