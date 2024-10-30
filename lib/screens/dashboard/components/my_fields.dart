
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../controllers/Provider/users_provider.dart';
import '../../../models/MyFiles.dart';
import '../../../responsive.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "Users ",
        //       style: Theme.of(context).textTheme.titleMedium,
        //     ),
        //     ElevatedButton.icon(
        //       style: TextButton.styleFrom(
        //         padding: EdgeInsets.symmetric(
        //           horizontal: defaultPadding * 1.5,
        //           vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
        //         ),
        //       ),
        //       onPressed: () {},
        //       icon: Icon(Icons.add),
        //       label: Text("Add New"),
        //     ),
        //   ],
        // ),
        // SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    // Get the user provider
    final userProvider = Provider.of<UserProvider>(context);

    // Filter the users based on their status
    int totalUsers = userProvider.users.length;
    int approvedUsers = userProvider.users.where((user) => user.isApproved).length;
    int disapprovedUsers = userProvider.users.where((user) => !user.isApproved && !user.isBlocked).length;
    int blockedUsers = userProvider.users.where((user) => user.isBlocked).length;

    // Create the CloudStorageInfo list dynamically
    List<CloudStorageInfo> userInfoCards = [
      CloudStorageInfo(
        title: "Tous les utilisateurs",
        numOfFiles: totalUsers,
        svgSrc: "assets/icons/menu_profile.svg",
        totalStorage: "200",
        color: primaryColor,
        percentage: totalUsers == 0 ? 0 : (totalUsers / totalUsers * 100).toInt(),
      ),
      CloudStorageInfo(
        title: "LES COMMANDE VALIDE",
        numOfFiles: approvedUsers,
        svgSrc: "assets/icons/menu_task.svg",
        totalStorage: "200",
        color: Color(0xFF36FF51),
        percentage: totalUsers == 0 ? 0 : (approvedUsers / totalUsers * 100).toInt(),
      ),
      CloudStorageInfo(
        title: "Stock d’arrivée",
        numOfFiles: disapprovedUsers,
        svgSrc: "assets/icons/menu_doc.svg",
        totalStorage: "200",
        color: Color(0xFFE1B311),
        percentage: totalUsers == 0 ? 0 : (disapprovedUsers / totalUsers * 100).toInt(),
      ),
      CloudStorageInfo(
        title: "LES COMMANDE REFUSE",
        numOfFiles: blockedUsers,
        svgSrc: "assets/icons/drop_box.svg",
        totalStorage: "200",
        color: Color(0xFFC90A0A),
        percentage: totalUsers == 0 ? 0 : (blockedUsers / totalUsers * 100).toInt(),
      ),
    ];

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: userInfoCards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: userInfoCards[index]),
    );
  }
}
