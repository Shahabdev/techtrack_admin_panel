
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../controllers/Provider/page_controller.dart';
import '../../all_users_screen.dart';
import '../../approved_users_screen.dart';
import '../../dashboard/dashboard_screen.dart';
import '../orders_screen.dart';


class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: secondaryColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              "assets/images/logo.png",
              height: 100,
            ),
          ),
          DrawerListTile(
            title: "TABLEAU DE BORD",
            svgSrc: "assets/icons/menu_dashboard.svg",
            index: 0,
            press: () {
              context.read<PageControllerProvider>().setPage(DashboardScreen());
              context.read<PageControllerProvider>().setSelectedIndex(0);
              // Navigator.of(context).pop();
            },
          ),DrawerListTile(
            title: "LES UTILISATEURS",
            svgSrc: "assets/icons/menu_dashboard.svg",
            index: 1,
            press: () {
              context.read<PageControllerProvider>().setPage(AllUsersScreen());
              context.read<PageControllerProvider>().setSelectedIndex(1);
              // Navigator.of(context).pop();
            },
          ),
          DrawerListTile(
            title: "COMMANDE REÇUE",
            svgSrc: "assets/icons/menu_profile.svg",
            index: 2,
            press: () {
              context.read<PageControllerProvider>().setPage(AdminOrderScreen());
              context.read<PageControllerProvider>().setSelectedIndex(2);
              // Navigator.of(context).pop();
            },
          ),
          DrawerListTile(
            title: "LISTE DE STOCK",
            svgSrc: "assets/icons/menu_task.svg",
            index: 3,
            press: () {
              context.read<PageControllerProvider>().setPage(ApprovedUsersScreen());
              context.read<PageControllerProvider>().setSelectedIndex(3);
              // Navigator.of(context).pop();
            },
          ),
          // DrawerListTile(
          //   title: "LISTING MATRIALE",
          //   svgSrc: "assets/icons/menu_doc.svg",
          //   index: 4,
          //   press: () {
          //     context.read<PageControllerProvider>().setPage(DisApprovedUsersScreen());
          //     context.read<PageControllerProvider>().setSelectedIndex(4);
          //     // Navigator.of(context).pop();
          //   },
          // ),
          // DrawerListTile(
          //   title: "LISTE DE CLIENT",
          //   svgSrc: "assets/icons/menu_store.svg",
          //   index: 5,
          //   press: () {
          //     context.read<PageControllerProvider>().setPage(BlockedUserScreen());
          //     context.read<PageControllerProvider>().setSelectedIndex(5);
          //     // Navigator.of(context).pop();
          //   },
          // ),
        ],
      ),
    );

  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.index,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final int index;

  @override
  Widget build(BuildContext context) {
    int selectedIndex = context.watch<PageControllerProvider>().selectedIndex;
    bool isSelected = selectedIndex == index;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultPadding,vertical: 3),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: SvgPicture.asset(
          svgSrc,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.white : Colors.white54,
            BlendMode.srcIn,
          ),
          height: 16,
        ),
        title: Text(
          title,
          style: TextStyle(
            color:  isSelected ? Colors.white : Colors.white54,
          ),
        ),
        selected: isSelected,
      ),
    );
  }
}
