import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../controllers/Provider/users_provider.dart';
import '../models/users_model.dart';

class ApprovedUsersScreen extends StatefulWidget {
  @override
  State<ApprovedUsersScreen> createState() => _ApprovedUsersScreenState();
}

class _ApprovedUsersScreenState extends State<ApprovedUsersScreen> {
  TextEditingController searchController = TextEditingController();
  String searchText = "",
      availability = "false",
      rating = "",
      lat = "0.0",
      lng = "0.0",
      distance = "";
  int currentIndex = 0;

  ValueNotifier<String> searchNotifier = ValueNotifier<String>("");
  Uint8List? _productImageBytes; // Image bytes for the selected image
  String? _imageName; // Name of the image file

  // Function to pick the image
  Future<void> _pickImage(StateSetter setDialogState) async {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    if (bytesFromPicker != null) {
      setDialogState(() {
        _productImageBytes = bytesFromPicker; // Set the image bytes
        _imageName = DateTime.now().millisecondsSinceEpoch.toString(); // Assign a unique name for the image
      });
    }
  }
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      searchNotifier.value = searchController.text;
    });
    Provider.of<UserProvider>(context, listen: false).fetchStockData();

  }

  @override
  void dispose() {
    searchController.dispose();
    searchNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMobile =
        screenSize.width < 600; // Define breakpoint for mobile
    final bool isTablet = screenSize.width >= 600 && screenSize.width < 1024;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bgColor,
        title: Text(
          'LISTE DE STOCK',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(builder: (context, userProvider, child) {
          print("User length ${userProvider.users.length}");
          if (userProvider.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
        
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(

                     // alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(defaultPadding),
                      ),
                     // width: MediaQuery.of(context).size.width,
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
                                userProvider.filterStocks(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.add, size: 40),
                          onPressed: () {
                            final _formKey = GlobalKey<FormState>(); // GlobalKey for Form validation
                            TextEditingController productNameController = TextEditingController();
                            TextEditingController categoryController = TextEditingController();
                            TextEditingController stockController = TextEditingController();
                            TextEditingController priceController = TextEditingController();

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context,StateSetter setDialogState) {
                                      return AlertDialog(
                                        title: Text("Add New Product"),
                                        content: SingleChildScrollView(
                                          child: Form(
                                            key: _formKey, // Assign the GlobalKey to the Form
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Product Name field
                                                TextFormField(
                                                  controller: productNameController,
                                                  decoration: InputDecoration(
                                                    labelText: "Product Name",
                                                    border: OutlineInputBorder(),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: primaryColor),
                                                    ),
                                                  ),

                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter a product name';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 10),
                                                // Category field
                                                TextFormField(
                                                  controller: categoryController,
                                                  decoration: InputDecoration(
                                                    labelText: "Categories",
                                                    border: OutlineInputBorder(),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: primaryColor),
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter a category';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 10),
                                                // Stock field
                                                TextFormField(
                                                  controller: stockController,
                                                  decoration: InputDecoration(
                                                    labelText: "Stock",
                                                    border: OutlineInputBorder(),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: primaryColor),
                                                    ),
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter stock quantity';
                                                    }
                                                    if (int.tryParse(value) == null) {
                                                      return 'Please enter a valid number';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 10),
                                                // Price field
                                                TextFormField(
                                                  controller: priceController,
                                                  decoration: InputDecoration(
                                                    labelText: "Price",
                                                    border: OutlineInputBorder(),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(color: primaryColor),
                                                    ),
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return 'Please enter a price';
                                                    }
                                                    if (double.tryParse(value) == null) {
                                                      return 'Please enter a valid price';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(height: 10),
                                                // Image picker button
                                                TextButton.icon(
                                                  onPressed: () {
                                                    _pickImage(setDialogState); // Pass setDialogState to update the dialog
                                                  },
                                                  icon: Icon(Icons.image),
                                                  label: Text('Select Product Image'),
                                                ),
                                                // Display the selected image preview
                                                if (_productImageBytes != null)
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      height: 150,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Image.memory(
                                                        _productImageBytes!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // Close dialog
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          userProvider.stockLoading ? CircularProgressIndicator(color: Colors.white,): TextButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!.validate() && _productImageBytes != null) {
                                                // If all fields are valid and image is selected, perform the save operation
                                                try {
                                                  await userProvider.addStock(
                                                    productName: productNameController.text,
                                                    category: categoryController.text,
                                                    stock: int.parse(stockController.text),
                                                    price: double.parse(priceController.text),
                                                    imageBytes: _productImageBytes!,
                                                    imageName: _imageName!,
                                                  );
                                                  Navigator.pop(context); // Close dialog
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Product added successfully")),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Failed to add product")),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text("Please fill in all fields and select an image")),
                                                );
                                              }
                                            },
                                            child: Text("Save"),
                                          ),
                                        ],
                                      );
                                    }
                                );
                              },
                            ).then((value) {
                              Provider.of<UserProvider>(context, listen: false).fetchStockData();
                              setState(() {

                              });
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

        
        
          const SizedBox(
                height: defaultPadding,
              ),
              Consumer<UserProvider>(
                builder: (context, stockProvider, child) {
                  return stockProvider.stockData.isEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(top: 130, left: 440),
                    child: CircularProgressIndicator(),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 1 : isTablet ? 2 : 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / (isMobile ? 2.2 : isTablet ? 1.2 : 0.63)),
                      ),
                      itemCount: stockProvider.filteredStocksData.length, // Use dynamic data count
                      itemBuilder: (BuildContext context, int index) {
                        var product = stockProvider.filteredStocksData[index];
        
                        return Container(
                          height: height * 0.55,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    product['imageUrl'] ?? 'https://via.placeholder.com/150',
                                    height: 130,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.001),
                              // Product Name
                              Text(
                                product['productName'],
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              // Product Category
                              Text(
                                "Category: ${product['category']}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              // Product Stock
                              Text(
                                "Stock: ${product['stock']}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: product['stock'] == 'In Stock' ? Colors.green : Colors.red,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              // Product Price
                              Text(
                                "Price: ${product['price']}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),

                              // Edit and Delete Buttons
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        String documentId = product['docId']; // Assuming 'id' is the document ID in your Firestore collection
                                        // Open edit dialog with the product data
                                        _showEditDialog(context, stockProvider, documentId, product);
                                        // Edit action for the product
                                        print('Edit product: ${product['name']}');
                                      },
                                      child: Container(
                                        height: isMobile ? height * 0.07 : isTablet ? height * 0.06 : height * 0.05,
                                        width: isMobile ? width * 0.18 : isTablet ? width * 0.1 : width * 0.04,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(7),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.01),
                                    InkWell(
                                      onTap: () {
                                        String documentId = product['docId']; // Assuming 'id' is the document ID in your Firestore collection
                                        stockProvider.deleteStock(documentId);
                                        print('Delete product: ${product['name']}');
                                      },
                                      child: Container(
                                        height: isMobile ? height * 0.07 : isTablet ? height * 0.06 : height * 0.05,
                                        width: isMobile ? width * 0.18 : isTablet ? width * 0.1 : width * 0.04,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(7),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              )

            ],
          );
        }),
      ),
    );
  }
  void _showEditDialog(BuildContext context, UserProvider stockProvider, String documentId, Map<String, dynamic> product) {
    TextEditingController productNameController = TextEditingController(text: product['productName']);
    TextEditingController categoryController = TextEditingController(text: product['category']);
    TextEditingController imageController = TextEditingController(text: product['imageUrl']);
    TextEditingController stockController = TextEditingController(text: product['stock'].toString());
    TextEditingController priceController = TextEditingController(text: product['price'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Product Name Input
                TextField(
                  controller: productNameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                // Category Input
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                // Stock Input
                TextField(
                  controller: stockController,
                  decoration: InputDecoration(labelText: 'Stock'),
                ),
                // Price Input
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Prepare updated product data
                Map<String, dynamic> updatedData = {
                  'productName': productNameController.text,
                  'category': categoryController.text,
                  'stock': int.parse(stockController.text),
                  'imageUrl': imageController.text,
                  'price': int.parse(priceController.text),
                };

                // Call the editStock function to update the product
                stockProvider.editStock(documentId, updatedData);

                Navigator.of(context).pop(); // Close the dialog after updating
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

}
