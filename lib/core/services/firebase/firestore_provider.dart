import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mat3amy/core/services/local/shared_pref.dart';
import 'package:mat3amy/features/auth/presentation/model/user_model.dart';
import 'package:mat3amy/features/main/home/model/meal_model.dart';
import 'package:mat3amy/features/main/home/model/rating_model.dart';
import 'package:mat3amy/features/main/home/model/reservation_model.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';

class FirebaseProvider {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final usersCollection = _firestore.collection("users");

  static final restaurantsCollection = _firestore.collection("restaurants");

  static final mealsCollection = _firestore.collection("meals");

  static final reservationsCollection = _firestore.collection("reservations");
  static final favoritesCollection = _firestore.collection("favorites");
  static final ratingsCollection = FirebaseFirestore.instance.collection(
    'ratinges',
  );

  static User? get currentUser => _auth.currentUser;

  // ================= USERS =================

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

  static Future<List<RestaurantModel>> getRestaurantsData() async {
    final snapshot = await restaurantsCollection.get();

    return snapshot.docs.map((doc) {
      return RestaurantModel.fromJson(doc.data(), doc.id);
    }).toList();
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

  static Future<List<MealModel>> getMealsData(String restaurantId) async {
    final snapshot = await mealsCollection
        .where("restaurantId", isEqualTo: restaurantId)
        .get();

    return snapshot.docs.map((doc) {
      return MealModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  // ================= RESERVATIONS =================

  static Future<void> addReservation(ReservationModel reservation) async {
    await reservationsCollection.add(reservation.toJson());
  }

  static Future<List<ReservationModel>> getReservationsData(
    String userId,
  ) async {
    final snapshot = await reservationsCollection
        .where("userId", isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      return ReservationModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  static Future<void> addRating(RatingModel rating) async {
    await ratingsCollection.add(rating.toJson());
  }

  static Future<List<RatingModel>> getRestaurantRatings(
    String restaurantId,
  ) async {
    final snapshot = await ratingsCollection
        .where("restaurantId", isEqualTo: restaurantId)
        .get();

    return snapshot.docs.map((doc) {
      return RatingModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  static Future<void> deleteReservation(String reservationId) async {
    await reservationsCollection.doc(reservationId).delete();
  }

  static Future<void> updateReservation(ReservationModel reservation) async {
    await reservationsCollection
        .doc(reservation.id)
        .update(reservation.toJson());
  }

  static Future<void> addFavorite({
    required String userId,
    required String restaurantId,
  }) async {
    await favoritesCollection.add({
      "userId": userId,
      "restaurantId": restaurantId,
    });
  }

  static Future<void> removeFavorite(String userId, String restaurantId) async {
    final snapshot = await favoritesCollection
        .where("userId", isEqualTo: userId)
        .where("restaurantId", isEqualTo: restaurantId)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  static Future<bool> isFavorite(String userId, String restaurantId) async {
    final snapshot = await favoritesCollection
        .where("userId", isEqualTo: userId)
        .where("restaurantId", isEqualTo: restaurantId)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  static Future<List<RestaurantModel>> getFavoriteRestaurants(
    String userId,
  ) async {
    final favoritesSnapshot = await favoritesCollection
        .where("userId", isEqualTo: userId)
        .get();

    List<RestaurantModel> restaurants = [];

    for (final favorite in favoritesSnapshot.docs) {
      final restaurantId = favorite["restaurantId"];

      final restaurantDoc = await restaurantsCollection.doc(restaurantId).get();

      if (restaurantDoc.exists) {
        restaurants.add(
          RestaurantModel.fromJson(restaurantDoc.data()!, restaurantDoc.id),
        );
      }
    }

    return restaurants;
  }
}
