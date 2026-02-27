import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';
import '../services/auth_service.dart';

class ListingProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  List<ListingModel> _listings = [];
  List<ListingModel> get listings => _listings;

  // 🔍 SEARCH + FILTER VARIABLES
  String _searchQuery = "";
  String _selectedCategory = "All";

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  void updateSearch(String value) {
    _searchQuery = value.toLowerCase();
    notifyListeners();
  }

  void updateCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  // 🔵 LISTEN TO FIRESTORE REAL TIME
  void listenToListings() {
    _db
        .collection('listings')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      _listings =
          snapshot.docs.map((doc) => ListingModel.fromFirestore(doc)).toList();
      notifyListeners();
    });
  }

  // 🟢 ADD LISTING
  Future<void> addListing({
    required String name,
    required String category,
    required String address,
    required String contact,
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    await _db.collection('listings').add({
      'name': name,
      'category': category,
      'address': address,
      'contact': contact,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': _auth.currentUser!.uid,
      'timestamp': Timestamp.now(),
    });
  }

  // 🔴 DELETE LISTING
  Future<void> deleteListing(String id) async {
    await _db.collection('listings').doc(id).delete();
  }

  // 🎯 FILTERED LIST FOR DIRECTORY
  List<ListingModel> get filteredListings {
    return _listings.where((item) {
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery);

      final matchesCategory =
          _selectedCategory == "All" || item.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }
}