import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mat3amy/core/services/local/shared_pref.dart';
import 'package:mat3amy/features/auth/presentation/model/reservation_model.dart';
import 'package:mat3amy/features/auth/presentation/model/user_model.dart';

class FirebaseProvider {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final usersCollection = _firestore.collection("users");

  static final restaurantsCollection = _firestore.collection("restaurants");

  static final mealsCollection = _firestore.collection("meals");

  static final reservationsCollection = _firestore.collection("reservations");

  static final reservationItemsCollection = _firestore.collection(
    "reservation_items",
  );

  static User? get currentUser => _auth.currentUser;

  static Future<void> addUser(UserModel user) async {
    await usersCollection.doc(user.uid).set(user.toJson());
  }

  static Future<void> updateUser(UserModel user) async {
    await usersCollection.doc(user.uid).update(user.toUpdateData());
  }

  static Stream<DocumentSnapshot<Object?>> getCurrentUser() {
    return usersCollection.doc(SharedPref.getUserId()).snapshots();
  }

  // ================= RESTAURANTS =================

  static Future<QuerySnapshot> getRestaurants() async {
    return await restaurantsCollection.get();
  }

  static Future<QuerySnapshot?> searchRestaurants(String name) async {
    try {
      return await restaurantsCollection
          .orderBy("name")
          .startAt([name.toLowerCase()])
          .endAt(["${name.toLowerCase()}\uf8ff"])
          .get();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<QuerySnapshot> getRestaurantsByCategory(String category) async {
    return await restaurantsCollection
        .where("category", isEqualTo: category)
        .get();
  }

  // ================= MEALS =================

  static Future<QuerySnapshot> getMeals(String restaurantId) async {
    return await mealsCollection
        .where("restaurantId", isEqualTo: restaurantId)
        .get();
  }

  // ================= RESERVATIONS =================

  static Future<void> addReservation(ReservationModel reservation) async {
    await reservationsCollection.add(reservation.toJson());
  }

  static Future<void> deleteReservation(String id) async {
    await reservationsCollection.doc(id).delete();
  }

  static Future<QuerySnapshot> getUserReservations() async {
    return await reservationsCollection
        .where("userId", isEqualTo: SharedPref.getUserId())
        .get();
  }
}
