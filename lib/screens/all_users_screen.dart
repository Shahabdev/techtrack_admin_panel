
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controllers/Provider/users_provider.dart';
import '../models/users_model.dart';
import '../responsive.dart';
import 'Utils/tabel_header_text.dart';



class AllUsersScreen extends StatefulWidget {
  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  TextEditingController searchController = TextEditingController();
  String searchText = "", availability = "false", rating = "", lat = "0.0", lng = "0.0", distance = "";
  late UserProvider userProvider;

  ValueNotifier<String> searchNotifier = ValueNotifier<String>("");

  // State variable to control password visibility
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchNextPage();
    searchController.addListener(() {
      searchNotifier.value = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchNotifier.dispose();
    userProvider.userData = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile = screenSize.width < 600; // Define breakpoint for mobile
    final bool isTablet = screenSize.width >= 600 && screenSize.width < 1024;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bgColor,
        title: Text(
          'Tous les utilisateurs',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        print("Longueur des utilisateurs ${userProvider.users.length}");
        if (userProvider.userData.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(defaultPadding),
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: primaryColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                          hintText: "Rechercher un nom d'utilisateur",
                          hintStyle: const TextStyle(color: primaryColor),
                          labelText: "Nom d'utilisateur",
                          labelStyle: const TextStyle(color: primaryColor),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(defaultPadding),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(defaultPadding),
                          ),
                        ),
                        onChanged: (value) {
                          searchText = value;
                          // // usersProvider.getAllUsers(true, searchText, availability, rating, lat, lng, distance);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: bgColor,
                width: isTablet
                    ? width
                    : isMobile
                    ? width
                    : width,
                child: DataTableTheme(
                  data: DataTableThemeData(
                    headingRowColor: MaterialStateProperty.all(bgColor), // Header color
                    headingTextStyle: TextStyle(
                      color: Colors.white, // Header text color
                      fontWeight: FontWeight.bold,
                    ),
                    dataRowColor: MaterialStateProperty.all(bgColor), // Row color
                    dataTextStyle: TextStyle(
                      color: Colors.white, // Text color inside rows
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      cardTheme: CardTheme(
                        color: bgColor,
                      ),
                      textTheme: TextTheme(
                        button: TextStyle(color: Colors.white), // Change pagination numbers color
                      ),
                      iconTheme: IconThemeData(
                        color: Colors.white, // Change pagination icon button color (arrows)
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white, // Change the pagination text button color (rows per page dropdown)
                        ),
                      ),
                    ),
                    child: PaginatedDataTable(
                      onPageChanged: (valu) {},
                      columnSpacing: 10,
                      showEmptyRows: true,
                      rowsPerPage: 5,
                      dataRowHeight: 60,
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Image')),
                        DataColumn(label: Text('Nom')),
                        DataColumn(label: Text('Date de naissance')),
                        DataColumn(label: Text('Mot de passe')),
                        DataColumn(label: Text('Abonnés')),
                        DataColumn(label: Text('Action')),
                      ],
                      source: MyDataTableSource(
                        List<DataRow>.generate(
                          userProvider.userData.length,
                              (index) {
                            var user = userProvider.userData[index];

                            return DataRow(
                              cells: [
                                DataCell(Text(user["uid"], style: TextStyle(fontSize: 8))),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: CircleAvatar(
                                      radius: 45,
                                      backgroundColor: Colors.green,
                                      child: ClipOval(
                                        child: Image.network(
                                          user['profile_image'],
                                          height: 50,
                                          width: 49,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(user['name'], style: TextStyle(fontSize: 14))),
                                DataCell(Text(user['email'], style: TextStyle(fontSize: 14))),
                                DataCell(
                                  Row(
                                    children: [
                                      // Conditionally show password or asterisks
                                      Text(
                                        _isPasswordVisible ? user['password'].toString() : '******',
                                        style: TextStyle(fontSize: 9),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text("Anbos", style: TextStyle(fontSize: 8))),
                                DataCell(
                                  InkWell(
                                    onTap: () async {
                                      user['block'] = !user['block'];
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user['uid']) // Assuming 'uid' is the document ID
                                          .update({
                                        'block': user['block'],
                                      }).then((_) {
                                        print("Block status updated successfully");
                                      }).catchError((error) {
                                        print("Failed to update block status: $error");
                                      });
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: user['block'] ? Colors.green.shade700 : Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          user['block'] ? 'Unblock' : "Block",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}



class UserDetailsDialog extends StatelessWidget {
  final User user;

  UserDetailsDialog({required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 16,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'User Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profileImage.toString()),
                foregroundImage: NetworkImage(user.profileImage.toString()),
                backgroundColor: bgColor,
                radius: 60,
              ),
            ),
            SizedBox(height: 40),
            if (Responsive.isDesktop(context)) ...[
              const SizedBox(
                width: defaultPadding,
              ),
              Text(
                  'User ID : ${user.id}',
                textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18)
              ),
            ],
            SizedBox(height: 10),
            Text(
                'Name : ${user.name}',
              textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18)
            ),
            SizedBox(height: 10),
            Text(
                'DOB : ${user.dob}',
              textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18)
            ),
            SizedBox(height: 10),
            if (Responsive.isDesktop(context))
              Text(
                  'Country : ${user.country}',
                textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18)
              ),

            SizedBox(height: 20),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     style: ButtonStyle(
            //         shape: WidgetStateProperty.all(
            //           RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(15),
            //           ),
            //         ),
            //         backgroundColor: WidgetStateProperty.all(primaryColor)),
            //     child: Text('Close',style: TextStyle(fontSize: 18,color: Colors.white)),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
class MyDataTableSource extends DataTableSource {
  final List<DataRow> rows;

  MyDataTableSource(this.rows);

  @override
  DataRow? getRow(int index) {
    if (index >= rows.length) {
      return null;
    }
    return rows[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;
}