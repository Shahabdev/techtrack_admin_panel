import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.numOfUsers,
    required this.color,
    required this.bgColor,
  }) : super(key: key);

  final String title;
  final IconData  svgSrc;
  final Color color;
  final Color bgColor;
  final int numOfUsers;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: bgColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Icon(
              svgSrc,
              color: color,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Text(
                  //   "$numOfFiles Files",
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .bodySmall!
                  //       .copyWith(color: Colors.white70),
                  // ),
                ],
              ),
            ),
          ),
          // Text(numOfUsers.toString())
        ],
      ),
    );
  }
}
