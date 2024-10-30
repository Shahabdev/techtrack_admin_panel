
import 'package:flutter/material.dart';

import '../constants.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "All Users",
    numOfFiles: 200,
    svgSrc: "assets/icons/menu_profile.svg",
    totalStorage: "200",
    color: primaryColor,
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "Approved",
    numOfFiles: 180,
    svgSrc: "assets/icons/menu_task.svg",
    totalStorage: "200",
    color: Color(0xFF36FF51),
    percentage: 90,
  ),
  CloudStorageInfo(
    title: "Disapproved",
    numOfFiles: 40,
    svgSrc: "assets/icons/menu_doc.svg",
    totalStorage: "200",
    color: Color(0xFFE1B311),
    percentage: 30,
  ),
  CloudStorageInfo(
    title: "Blocked",
    numOfFiles: 20,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "200",
    color: Color(0xFFC90A0A),
    percentage: 10,
  ),
];
