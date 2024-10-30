import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../controllers/Provider/users_provider.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Consumer<UserProvider>(builder: (context, userProvider, child) {
        int totalUsers = userProvider.users.length;
        int approvedUsers = userProvider.users.where((user) => user.isApproved).length;
        int disapprovedUsers = userProvider.users.where((user) => !user.isApproved && !user.isBlocked).length;
        int blockedUsers = userProvider.users.where((user) => user.isBlocked).length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "LES SORTI ET ENTREE",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: defaultPadding),
              Chart(),
              StorageInfoCard(
                title: "LES SORTI DE STOCK",
                numOfUsers: totalUsers,
                svgSrc: Icons.remove_shopping_cart,
                color: Colors.red,
                bgColor: Colors.red,
              ),
              StorageInfoCard(
                title: "LES ENTREE DE STOCK",
                numOfUsers: approvedUsers,
                svgSrc: Icons.shopping_cart,
                color: Color(0xFF36FF51),
                bgColor: Color(0xFF36FF51),
              ),
              // StorageInfoCard(
              //   title: "Disapproved",
              //   numOfUsers: disapprovedUsers,
              //   svgSrc: "assets/icons/menu_doc.svg",
              //   color: Color(0xFFE1B311),
              // ),
              // StorageInfoCard(
              //   title: "Blocked",
              //   numOfUsers: blockedUsers,
              //   svgSrc: "assets/icons/drop_box.svg",
              //   color: Color(0xFFC90A0A),
              // ),
            ],
          );
        }
      ),
    );
  }
}
