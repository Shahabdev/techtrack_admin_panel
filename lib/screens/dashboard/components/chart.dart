import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../controllers/Provider/users_provider.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Consumer<UserProvider>(builder: (context, userProvider, child) {
        int totalUsers = userProvider.users.length;
        int approvedUsers = userProvider.users.where((user) => user.isApproved).length;
        int disapprovedUsers = userProvider.users.where((user) => !user.isApproved && !user.isBlocked).length;
        int blockedUsers = userProvider.users.where((user) => user.isBlocked).length;
        List<PieChartSectionData> paiChartSelectionData = [
          PieChartSectionData(
            color: Color(0xFF36FF51),
            value: approvedUsers.toDouble(),
            showTitle: false,
            radius: 22,
          ),
          PieChartSectionData(
            color: Color(0xFFE1B311),
            value: disapprovedUsers.toDouble(),
            showTitle: false,
            radius: 22,
          ),
          PieChartSectionData(
            color: Color(0xFFEE2727),
            value: blockedUsers.toDouble(),
            showTitle: false,
            radius: 22,
          ),
          PieChartSectionData(
            color: primaryColor,
            value: totalUsers.toDouble(),
            showTitle: false,
            radius: 22,
          ),
        ];

        return Stack(
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
                  startDegreeOffset: -90,
                  sections: paiChartSelectionData,
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: defaultPadding),
                    Text(
                      totalUsers.toString(),
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 0.5,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

