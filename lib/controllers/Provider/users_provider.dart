import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../models/users_model.dart';

class UserProvider with ChangeNotifier {
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> stockData = [];
  List<Map<String, dynamic>> ordersData = [];
  List<Map<String, dynamic>> filteredOrdersData = [];
  List<Map<String, dynamic>> filteredStocksData = [];
  List<User> _users = [];
  bool _loading = false;
  bool _stockLoading = false;
  Set<String> _loadingUsers = {};

  List<User> get users => _users;

  bool get loading => _loading;
  bool get stockLoading => _stockLoading;

  UserProvider() {
    fetchUsers();
  }

  void setLoading(bool value) {
    _loading = value;
    Future.microtask(() => notifyListeners());
  }
  set setStockLoading(bool value) {
    _stockLoading = value;
    notifyListeners();
  }

  bool isLoading(String userId) {
    return _loadingUsers.contains(userId);
  }

  void fetchUsers() async {
    FirebaseFirestore.instance.collection('users').snapshots().listen(
      (querySnapshot) {
        _users = querySnapshot.docs
            .map((doc) =>
                User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        notifyListeners();
      },
      onError: (e) {
        print(e);
      },
    );
  }

  Future<void> fetchNextPage() async {
    CollectionReference userCollectionRef =
        FirebaseFirestore.instance.collection("users");

    try {
      // Build the query based on the statusController value
      userData = [];
      // Execute query
      QuerySnapshot querySnapshot;
      querySnapshot = await userCollectionRef.get();

      // Handle the results
      if (querySnapshot.docs.isNotEmpty) {
        print("Data fetched, document count: ${querySnapshot.docs.length}");
        // Add new documents to playerData
        querySnapshot.docs.asMap().forEach((index, doc) {
          // Skip the first document (index == 0)
          if (doc.id == '3RoBW6Ewq0U0FmPsDCDED1IHLqr1') {
            return;
          }

          // Check if the document already exists in userData
          if (!userData.any((element) => element['id'] == doc.id)) {
            Map<String, dynamic> user = doc.data() as Map<String, dynamic>;
            user['id'] = doc.id; // Add the document ID
            userData.add(user);
          }
        });
        print("user  data --->${userData.toString()}");
      } else {
        print("No more data available.");
      }

      // Notify listeners of the changes
      notifyListeners();
    } catch (error) {
      // Handle errors here
      print("Error fetching next page: $error");
    }
  }
  // Function to delete a stock item by document ID
  Future<void> deleteStock(String documentId) async {
    try {
      // Reference to Firestore collection
      await FirebaseFirestore.instance
          .collection('stocks')
          .doc(documentId)
          .delete();

      // Remove the deleted item from the local stockData list if needed
      stockData.removeWhere((stockItem) => stockItem['id'] == documentId);

      // Notify listeners to rebuild UI after deletion
      notifyListeners();

      print('Product deleted successfully.');
    } catch (error) {
      print('Failed to delete product: $error');
    }
  }
  // Function to update a stock item by document ID
  Future<void> editStock(String documentId, Map<String, dynamic> updatedData) async {
    try {
      // Reference to Firestore document
      await FirebaseFirestore.instance
          .collection('stocks')
          .doc(documentId)
          .update(updatedData);

      // Update the local stockData list if needed
      int index = stockData.indexWhere((stockItem) => stockItem['id'] == documentId);
      if (index != -1) {
        stockData[index] = updatedData;
      }

      // Notify listeners to rebuild the UI after updating
      notifyListeners();

      print('Product updated successfully.');
    } catch (error) {
      print('Failed to update product: $error');
    }
  }
  /// ----  add stock function ------>
  Future<void> addStock({
    required String productName,
    required String category,
    required int stock,
    required double price,
    required Uint8List imageBytes,
    required String imageName,
  }) async {
    try {
      setStockLoading = true;
      String imageUrl = await uploadImageToStorage(imageBytes, imageName);
      // Generate a new document reference with an auto-generated ID
      DocumentReference docRef = FirebaseFirestore.instance.collection('stocks').doc();

      // Add a new document with the generated ID
      await docRef.set({
        'productName': productName,
        'category': category,
        'stock': stock,
        'price': price,
        'imageUrl': imageUrl,
        'docId': docRef.id, // Include the document ID as a field
        'createdAt': FieldValue.serverTimestamp(),
      });
      setStockLoading = false;
      // Notify listeners if needed to refresh the UI
      notifyListeners();
    } catch (e) {
      setStockLoading = false;
      notifyListeners();
      print("Error adding stock: $e");
      throw e; // Re-throw error for further handling
    }
  }


  // Fetch all orders from Firestore
  Future<void> fetchOrders() async {
    try {
      final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

      QuerySnapshot snapshot = await ordersCollection.get();

      // Parse the documents into a list of maps
      ordersData = snapshot.docs.map((doc) {
        return {
          'docId': doc.id,
          'items': doc['items'],
          'totalPrice': doc['totalPrice'],
          'dateTime': (doc['dateTime'] as Timestamp).toDate(),
          'userId': doc['userId'],
          'userName': doc['userName'],
          'isAccept': doc['isAccept'],
        };
      }).toList();

      // Initialize the filtered data with the full list of orders
      filteredOrdersData = List.from(ordersData);

      notifyListeners();
    } catch (error) {
      print("Error fetching orders: $error");
    }
  }
  void filterOrders(String query) {
    if (query.isEmpty) {
      // If the search is cleared, show all orders
      filteredOrdersData = List.from(ordersData);
    } else {
      // Otherwise, filter the orders list
      filteredOrdersData = ordersData
          .where((order) => order['userName']
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void filterStocks(String query) {
    if (query.isEmpty) {
      // If the search is cleared, show all orders
      filteredStocksData = List.from(stockData);
    } else {
      // Otherwise, filter the orders list
      filteredStocksData = stockData
          .where((order) => order['productName']
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
  /// ----------> get the stock data function --------->
  Future<void> fetchStockData() async {
    try {
      // Access the Firestore instance and the stock collection
      CollectionReference stockCollection = FirebaseFirestore.instance.collection('stocks');

      // Get the snapshot of the collection
      QuerySnapshot querySnapshot = await stockCollection.get();

      // Clear the current stock data
      stockData.clear();

      // Convert the snapshot documents into a list of maps and add it to the stockData list
      for (var doc in querySnapshot.docs) {
        stockData.add({
          ...doc.data() as Map<String, dynamic>, // Convert document data to a Map
          'id': doc.id, // Add document ID
        });
      }
      filteredStocksData = List.from(stockData);

      // Notify listeners to rebuild the UI with updated data
      notifyListeners();
    } catch (error) {
      print("Error fetching stock data: $error");
    }
  }
  Future<void> blockUser(String userId) async {
    _loadingUsers.add(userId);
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isBlocked': true,
      });

      int index = _users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        _users[index].isBlocked = true;
      }
    } catch (e) {
      print(e);
    } finally {
      _loadingUsers.remove(userId);
      notifyListeners();
    }
  }
  /// upload image in storage ------>
  Future<String> uploadImageToStorage(Uint8List imageBytes, String imageName) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('productImages/$imageName');
      UploadTask uploadTask = storageRef.putData(imageBytes);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw e;
    }
  }
  Future<void> unblockUser(String userId) async {
    _loadingUsers.add(userId);
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isBlocked': false,
      });

      int index = _users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        _users[index].isBlocked = false;
      }
    } catch (e) {
      print(e);
    } finally {
      _loadingUsers.remove(userId);
      notifyListeners();
    }
  }

  Future<void> approveUser(String userId) async {
    _loadingUsers.add(userId);
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isApproved': true,
      });

      int index = _users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        _users[index].isApproved = true;
      }
    } catch (e) {
      print(e);
    } finally {
      _loadingUsers.remove(userId);
      notifyListeners();
    }
  }

  Future<void> disapproveUser(String userId) async {
    _loadingUsers.add(userId);
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isApproved': false,
      });

      int index = _users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        _users[index].isApproved = false;
      }
    } catch (e) {
      print(e);
    } finally {
      _loadingUsers.remove(userId);
      notifyListeners();
    }
  }
}
