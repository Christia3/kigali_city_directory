import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Listing>> getListings() {
    return _db.collection('listings').orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Listing.fromFirestore(doc.id, doc.data()))
        .toList());
  }

  Future<void> addListing(Listing listing) async {
    await _db.collection('listings').add(listing.toMap());
  }

  Future<void> updateListing(Listing listing) async {
    await _db.collection('listings').doc(listing.id).update(listing.toMap());
  }

  Future<void> deleteListing(String id) async {
    await _db.collection('listings').doc(id).delete();
  }
}