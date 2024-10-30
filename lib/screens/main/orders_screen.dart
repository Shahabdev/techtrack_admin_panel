import 'dart:io';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../constants.dart';
import '../../controllers/Provider/users_provider.dart'; // For formatting the date

class AdminOrderScreen extends StatefulWidget {
  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    Provider.of<UserProvider>(context, listen: false).ordersData = [] ;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Fetch orders on screen load
    Provider.of<UserProvider>(context, listen: false).fetchOrders();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff151726),
        automaticallyImplyLeading: false,
        title: const Text(
          'Commandes des utilisateurs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, stockProvider, child) {
            if (stockProvider.ordersData.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
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
                              stockProvider.filterOrders(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: stockProvider.filteredOrdersData.length,
                    itemBuilder: (context, index) {
                      var order = stockProvider.filteredOrdersData[index];
                      return Card(
                        color: bgColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //_buildOrderHeader(order, context, stockProvider.orders),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    " ${order['userName']}",
                                    style: const TextStyle(

                                      fontSize: 18,
                                      color: Colors.white, // Darker color for order ID
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      downloadReceiptPdf(order);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 14.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 40,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.receipt_long,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              const Divider(height: 30, thickness: 1),
                              _buildOrderItems(order['items']),
                              const SizedBox(height: 16),
                              _buildTotalPrice(order['totalPrice']),
                              const SizedBox(height: 12),
                              _buildOrderDetails(order),
                              const SizedBox(height: 12),
                              // Buttons at the bottom-right
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //_buildAcceptButton(context, order),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: order['isAccept'] ? Colors.grey : Colors.green, // Disable if accepted
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: order['isAccept']
                                          ? null
                                          : () async {
                                        try {
                                          // Update Firestore: Set isAccepted to true
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(order['docId'])
                                              .update({'isAccept': true});

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('commande ${order['docId']} Accepté')),
                                          );
                                          setState(() {

                                          });
                                        } catch (e) {
                                          print('Error accepting order: $e');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Échec de l acceptation de la commande')),
                                          );
                                        }
                                      },
                                      child: Text(order['isAccept'] ? 'Accepté' : 'Accepter'),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildRefuseButton(context, order),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )

                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> downloadReceiptPdf(Map order) async {
    // Load the logo
    final Uint8List logoBytes = await loadLogo();
    final imageLogo = pw.MemoryImage(logoBytes);

    // Create a PDF document
    final pdf = pw.Document();
    final font = pw.Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'));
    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logo and Title
              pw.Column(
                  children: [

                    pw.Row(children: [
                      pw.SizedBox(width: 130),
                      pw.Image(pw.MemoryImage(logoBytes), width: 80, height: 80),
                      pw.SizedBox(width: 30),
                      pw.Container(
                        width: 0.5,  // Thickness of the divider
                        height: 90,  // Height of the divider (same as logo)
                        color: PdfColor.fromInt(0xff9d968a),  // Color of the divider
                      ),
                      pw.SizedBox(width: 30),
                      pw.Text('BARKENE \n    BFCS', style: pw.TextStyle(fontSize: 28,color: PdfColor.fromInt(0xff093d50), fontWeight: pw.FontWeight.bold)),
                    ]),
                  ]
              ),
              pw.Padding(padding: pw.EdgeInsets.only(left: 150),
                  child: pw.Container(
                    width: 300,  // Thickness of the divider
                    height: 0.5,  // Height of the divider (same as logo)
                    color: PdfColor.fromInt(0xff9d968a),
                    // Color of the divider
                  )

              ),



              pw.SizedBox(height: 10),

              // Divider
              pw.Divider(thickness: 0.5, color: PdfColor.fromInt(0xff9d968a)),

              pw.SizedBox(height: 20),

              // Order ID and Date
              pw.Text('Numéro de commande: ${order['docId']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Date de commande: ${DateFormat.yMMMd().format(order['dateTime'])}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),


              // Table Header for Order Items
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Article', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Quantité', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Prix', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(thickness: 1),

              // List of Items
              ...order['items'].map<pw.Widget>((item) {
                return pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(item['productName'], style: pw.TextStyle(fontSize: 12)),
                    pw.Text('${item['quantity']}', style: pw.TextStyle(fontSize: 12)),
                    pw.Text('€${(item['price'] * item['quantity']).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 12,font: font)),
                  ],
                );
              }).toList(),

              pw.Divider(thickness: 1),

              // Total Price
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Prix total', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text('€${order['totalPrice'].toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold,font: font)),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Save the document as bytes
    Uint8List pdfBytes = await pdf.save();

    // Create a blob and initiate the download
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "receipt_${order['docId']}.pdf")
      ..click();

    // Cleanup the object URL to avoid memory leaks
    html.Url.revokeObjectUrl(url);
  }

  Future<Uint8List> loadLogo() async {
    final ByteData data = await rootBundle.load('assets/images/logo.png');
    return data.buffer.asUint8List();
  }


  // Helper widget to display ordered items
  Widget _buildOrderItems(List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${item['productName']} (x${item['quantity']})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white54, // Dark color for product name
                ),
              ),
              Text(
                "\$${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue, // Blue color for item price
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Helper widget to display total price
  Widget _buildTotalPrice(double totalPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total Price:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey, // Grey color for label
          ),
        ),
        Text(
          "\$${totalPrice.toStringAsFixed(2)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.green, // Green color for total price
          ),
        ),
      ],
    );
  }

  // Helper widget to display order details (date and user ID)
  Widget _buildOrderDetails(Map order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white, size: 18),
            const SizedBox(width: 5),
            Text(
              DateFormat.yMMMd().format(order['dateTime']),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey, // Grey color for date
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.blueAccent, size: 18),
            const SizedBox(width: 5),
            Text(
              "Order ID: ${order['docId']}",
              style: const TextStyle(

                fontSize: 18,
                color: Colors.green, // Darker color for order ID
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildRefuseButton(BuildContext context, Map order) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Refuse button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
        try {
          // Delete the order from Firestore
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(order['docId'])
              .delete();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Commande ${order['docId']} refusé et supprimé')),
          );
          setState(() {

          });
        } catch (e) {
          print('Error refusing order: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Échec du refus de la commande')),
          );
        }
      },
      child: const Text('refuser'),
    );
  }
}
