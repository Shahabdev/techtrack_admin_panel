
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisApprovedUsersScreen extends StatefulWidget {
  @override
  State<DisApprovedUsersScreen> createState() => _DisApprovedUsersScreenState();
}

class _DisApprovedUsersScreenState extends State<DisApprovedUsersScreen> {
  TextEditingController searchController = TextEditingController();
  String searchText = "", availability = "false", rating = "", lat = "0.0", lng = "0.0", distance = "";
  int currentIndex = 0;

  ValueNotifier<String> searchNotifier = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      searchNotifier.value = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Disapproved Users',
      //     style: Theme.of(context).textTheme.titleLarge,
      //   ),
      // ),
      // body: Consumer<UserProvider>(builder: (context, userProvider, child) {
      //   print("User length ${userProvider.users.length}");
      //   if (userProvider.loading) {
      //     return Center(
      //       child: CircularProgressIndicator(
      //         color: primaryColor,
      //       ),
      //     );
      //   }
      //   List<User> disapproveUsers = userProvider.users.where((user) => !user.isApproved).toList();
      //   return Column(
      //     children: [
      //       Container(
      //         alignment: Alignment.topLeft,
      //         padding: const EdgeInsets.all(defaultPadding),
      //         decoration: BoxDecoration(
      //           color: bgColor,
      //           borderRadius: BorderRadius.circular(defaultPadding),
      //         ),
      //         width: MediaQuery.of(context).size.width,
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             SizedBox(
      //               width: MediaQuery.of(context).size.width * 0.20,
      //               child: TextFormField(
      //                 controller: searchController,
      //                 decoration: InputDecoration(
      //                   prefixIcon: const Icon(Icons.search),
      //                   prefixIconColor: primaryColor,
      //                   contentPadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      //                   hintText: "Search User Name",
      //                   hintStyle: const TextStyle(color: primaryColor),
      //                   labelText: "User Name",
      //                   labelStyle: const TextStyle(color: primaryColor),
      //                   border: InputBorder.none,
      //                   enabledBorder: OutlineInputBorder(
      //                     borderSide: const BorderSide(color: primaryColor, width: 2),
      //                     borderRadius: BorderRadius.circular(defaultPadding),
      //                   ),
      //                   focusedBorder: OutlineInputBorder(
      //                     borderSide: const BorderSide(color: primaryColor, width: 2),
      //                     borderRadius: BorderRadius.circular(defaultPadding),
      //                   ),
      //                 ),
      //                 onChanged: (value) {
      //                   searchText = value;
      //                   // // usersProvider.getAllUsers(true, searchText, availability, rating, lat, lng, distance);
      //                 },
      //               ),
      //             ),
      //             // Expanded(
      //             //   child: Container(
      //             //     margin: const EdgeInsets.only(left: defaultPadding / 2),
      //             //     decoration: BoxDecoration(
      //             //       borderRadius: BorderRadius.circular(defaultPadding),
      //             //       color: secondaryColor,
      //             //     ),
      //             //     alignment: Alignment.center,
      //             //     padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      //             //     child: DropdownButton<String>(
      //             //       dropdownColor: primaryColor,
      //             //       isExpanded: true,
      //             //       value: "Select Rating",
      //             //       borderRadius: BorderRadius.circular(defaultPadding),
      //             //       icon: const Icon(Icons.arrow_drop_down),
      //             //       iconSize: 24,
      //             //       elevation: 12,
      //             //       underline: const SizedBox(),
      //             //       style: const TextStyle(color: Colors.white),
      //             //       onChanged: (String? newValue) {
      //             //         setState(() {
      //             //           rating = newValue ?? '';
      //             //           // // usersProvider.getAllUsers(true, searchText, availability, rating, lat, lng, distance);
      //             //         });
      //             //       },
      //             //       items: [
      //             //         "Select Rating",
      //             //         "1",
      //             //         "2",
      //             //         "3",
      //             //         "4",
      //             //         "5",
      //             //       ].map((String value) {
      //             //         return DropdownMenuItem<String>(
      //             //           value: value,
      //             //           child: Text(value),
      //             //         );
      //             //       }).toList(),
      //             //     ),
      //             //   ),
      //             // ),
      //             // Expanded(
      //             //   child: Container(
      //             //     margin: const EdgeInsets.only(left: defaultPadding / 2),
      //             //     decoration: BoxDecoration(
      //             //       borderRadius: BorderRadius.circular(defaultPadding),
      //             //       color: secondaryColor,
      //             //     ),
      //             //     alignment: Alignment.center,
      //             //     padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      //             //     child: DropdownButton<String>(
      //             //       isExpanded: true,
      //             //       value: "Select Order",
      //             //       borderRadius: BorderRadius.circular(defaultPadding),
      //             //       icon: const Icon(Icons.arrow_drop_down),
      //             //       dropdownColor: primaryColor,
      //             //       iconSize: 24,
      //             //       elevation: 12,
      //             //       underline: const SizedBox(),
      //             //       style: const TextStyle(color: Colors.white),
      //             //       onChanged: (String? newValue) {
      //             //         setState(() {
      //             //           availability = newValue == "Ascending " ? "true" : "false";
      //             //           // usersProvider.getAllUsers(true, searchText, availability, rating, lat, lng, distance);
      //             //         });
      //             //       },
      //             //       items: <String>["Select Order", "Ascending ", "Descending"].map((String value) {
      //             //         return DropdownMenuItem<String>(
      //             //           value: value,
      //             //           child: Text(value),
      //             //         );
      //             //       }).toList(),
      //             //     ),
      //             //   ),
      //             // ),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(
      //         height: defaultPadding,
      //       ),
      //       Expanded(
      //         child: Container(
      //           padding: const EdgeInsets.all(defaultPadding),
      //           decoration: BoxDecoration(
      //             color: bgColor,
      //             borderRadius: BorderRadius.circular(defaultPadding),
      //           ),
      //           width: MediaQuery.of(context).size.width,
      //           height: MediaQuery.of(context).size.height * 0.70,
      //           child: ValueListenableBuilder<String>(
      //               valueListenable: searchNotifier,
      //               builder: (context, searchValue, child) {
      //                 List<User> filteredUsers = disapproveUsers
      //                     .where((user) => user.name.toLowerCase().contains(searchValue.toLowerCase()))
      //                     .toList();
      //               return Column(
      //                 children: [
      //                   Row(
      //                     children: [
      //                       const TableHeaderText(text: 'Image'),
      //                       if (Responsive.isDesktop(context)) ...[
      //                         const SizedBox(
      //                           width: defaultPadding,
      //                         ),
      //                         const Expanded(flex: 1, child: TableHeaderText(text: 'ID'))
      //                       ],
      //                       const Expanded(flex: 1, child: TableHeaderText(text: 'Name')),
      //                       if (!(Responsive.isMobile(context))) const Expanded(flex: 1, child: TableHeaderText(text: 'Phone')),
      //                       if (!(Responsive.isMobile(context))) const Expanded(flex: 1, child: TableHeaderText(text: 'Email')),
      //                       const Expanded(flex: 1, child: TableHeaderText(text: 'Date of Birth')),
      //                       if (Responsive.isDesktop(context)) const Expanded(flex: 1, child: TableHeaderText(text: 'Country')),
      //                       const Expanded(flex: 2, child: TableHeaderText(text: 'Followers')),
      //                       const Expanded(flex: 2, child: TableHeaderText(text: 'Action')),
      //                     ],
      //                   ),
      //                   SizedBox(height: 10,),
      //                   Expanded(
      //                     child: WillPopScope(
      //                       onWillPop: () async {
      //                         return false;
      //                       },
      //                       child: ListView.separated(
      //                         shrinkWrap: true,
      //                         physics: const NeverScrollableScrollPhysics(),
      //                         itemCount: filteredUsers.length,
      //                         separatorBuilder: (context, index) => const Divider(),
      //                         itemBuilder: (context, index) {
      //                           var user = filteredUsers[index];
      //                           return Row(
      //                             mainAxisAlignment: MainAxisAlignment.start,
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               CircleAvatar(
      //                                 backgroundImage: NetworkImage(user.profileImage.toString()),
      //                                 foregroundImage: NetworkImage(user.profileImage.toString()),
      //                                 backgroundColor: bgColor,
      //                               ),
      //                               if (Responsive.isDesktop(context)) ...[
      //                                 const SizedBox(
      //                                   width: defaultPadding,
      //                                 ),
      //                                 Expanded(
      //                                     flex: 2,
      //                                     child: Text(
      //                                       user.id.toString(),
      //                                       textAlign: TextAlign.center,
      //                                     )),
      //                               ],
      //                               Expanded(
      //                                   flex: 2,
      //                                   child: Text(
      //                                     user.name.toString(),
      //                                     textAlign: TextAlign.center,
      //                                   )),
      //                               Expanded(
      //                                   flex: 1,
      //                                   child: Text(
      //                                     user.dob.toString(),
      //                                     textAlign: TextAlign.center,
      //                                   )),
      //                               if (Responsive.isDesktop(context))
      //                                 Expanded(
      //                                     flex: 1,
      //                                     child: Text(
      //                                       user.country.toString(),
      //                                       textAlign: TextAlign.center,
      //                                     )),
      //                               Expanded(
      //                                 flex: 2,
      //                                 child: InkWell(
      //                                   hoverColor: bgColor,
      //                                   borderRadius: BorderRadius.circular(12),
      //                                   child: Container(
      //                                     decoration: BoxDecoration(color: bgColor.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
      //                                     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
      //                                     margin: const EdgeInsets.all(5),
      //                                     alignment: Alignment.center,
      //                                     child: Text(user.followers.toString()),
      //                                   ),
      //                                   onTap: () {
      //                                     // CurrentVariables.currentUserId = currentUser?.id ?? '';
      //                                     // pageProvider.selectedPage = PageName.userDetails;
      //                                   },
      //                                 ),
      //                               ),
      //                               Expanded(
      //                                 flex: 2,
      //                                 child: InkWell(
      //                                   borderRadius: BorderRadius.circular(10),
      //                                   child: Container(
      //                                     decoration: BoxDecoration(
      //                                       color: Colors.green,
      //                                       borderRadius: BorderRadius.circular(12),
      //                                     ),
      //                                     margin: const EdgeInsets.all(5),
      //                                     padding: const EdgeInsets.all(5),
      //                                     child: Container(
      //                                       padding: const EdgeInsets.symmetric(vertical: 3),
      //                                       child: userProvider.isLoading(user.id)
      //                                           ? Center(child: CircularProgressIndicator(color: Colors.white))
      //                                           : Row(
      //                                               mainAxisAlignment: MainAxisAlignment.center,
      //                                               children: [
      //                                                 Icon(
      //                                                   Icons.check_circle_outline,
      //                                                   color: Colors.white,
      //                                                 ),
      //                                                 const SizedBox(width: 12 / 2),
      //                                                 Text(
      //                                                   "Approve",
      //                                                   style: const TextStyle(color: Colors.white),
      //                                                 ),
      //                                               ],
      //                                             ),
      //                                     ),
      //                                   ),
      //                                   onTap: () async {
      //                                     await userProvider.approveUser(user.id);
      //                                   },
      //                                 ),
      //                               ),
      //                             ],
      //                           );
      //                         },
      //                       ),
      //                     ),
      //                   ),
      //                   Container(
      //                     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      //                     decoration: const BoxDecoration(
      //                       color: bgColor,
      //                     ),
      //                     child: Row(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [
      //                         IconButton(
      //                           onPressed: () {
      //                             //usersProvider.loadPreviousPage(searchText, availability, rating, lat, lng, distance);
      //                           },
      //                           icon: const Icon(
      //                             Icons.keyboard_arrow_left,
      //                             color: Colors.white,
      //                           ),
      //                         ),
      //                         Text(
      //                           "Page 1 of 12",
      //                           style: const TextStyle(fontWeight: FontWeight.bold),
      //                           textAlign: TextAlign.center,
      //                         ),
      //                         IconButton(
      //                           onPressed: () {
      //                             // usersProvider.loadNextPage(searchText, availability, rating, lat, lng, distance);
      //                           },
      //                           icon: const Icon(
      //                             Icons.keyboard_arrow_right,
      //                             color: Colors.white,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               );
      //             }
      //           ),
      //         ),
      //       ),
      //     ],
      //   );
      // }),
    );
  }
}
