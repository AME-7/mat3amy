import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mat3amy/core/services/local/shared_pref.dart';
import 'package:mat3amy/features/auth/presentation/model/user_model.dart';
import 'package:mat3amy/features/main/home/model/meal_model.dart';
import 'package:mat3amy/features/main/home/model/rating_model.dart';
import 'package:mat3amy/features/restaurant/model/reservation_model.dart';
import 'package:mat3amy/features/restaurant/model/restaurant_model.dart';
import 'package:mat3amy/features/restaurant/model/restaurant_request_model.dart';

class FirebaseProvider {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final usersCollection = _firestore.collection("users");

  static final restaurantsCollection = _firestore.collection("restaurants");
  static final restaurantRequestsCollection = _firestore.collection(
    "restaurant_request",
  );

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

  static Future<UserModel> getUserData(String uid) async {
    final doc = await usersCollection.doc(uid).get();

    return UserModel.fromJson(doc.data()!);
  }

  static Future<void> approveRestaurant(RestaurantRequestModel request) async {
    await restaurantsCollection.doc(request.ownerId).set({
      "ownerId": request.ownerId,
      "name": request.name,
      "description": request.description,
      "image": request.image,
      "category": request.category,
      "mapUrl": request.mapUrl,
      "phone": request.phone,
      "city": request.city,
      "tablesCount": request.tablesCount,
      "workHours": request.workHours,
      "status": "approved",

      "distance": "",
      "rate": 0.0,
    });

    await restaurantRequestsCollection.doc(request.ownerId).delete();
  }

  static Future<void> rejectRestaurant(String ownerId) async {
    await restaurantRequestsCollection.doc(ownerId).delete();
  }

  // ================= RESTAURANTS =================
  static Future<void> addRestaurantRequest(
    RestaurantRequestModel request,
  ) async {
    await restaurantRequestsCollection
        .doc(request.ownerId)
        .set(request.toJson());
  }

  static Future<List<RestaurantRequestModel>> getRestaurantRequests() async {
    final snapshot = await restaurantRequestsCollection.get();

    return snapshot.docs.map((doc) {
      return RestaurantRequestModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  static Future<RestaurantRequestModel?> getMyRestaurantRequest(
    String ownerId,
  ) async {
    final snapshot = await restaurantRequestsCollection
        .where("ownerId", isEqualTo: ownerId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return RestaurantRequestModel.fromJson(
      snapshot.docs.first.data(),
      snapshot.docs.first.id,
    );
  }

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
  static Future<void> addMeal(MealModel meal) async {
    await mealsCollection.add(meal.toJson());
  }

  static Future<void> updateMeal(MealModel meal) async {
    await mealsCollection.doc(meal.id).update(meal.toUpdateData());
  }

  static Future<void> deleteMeal(String mealId) async {
    await mealsCollection.doc(mealId).delete();
  }

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

  static Future<List<ReservationModel>> getRestaurantReservations(
    String restaurantId,
  ) async {
    final snapshot = await reservationsCollection
        .where("restaurantId", isEqualTo: restaurantId)
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

  static Future<void> updateReservationStatus({
    required String reservationId,
    required String status,
  }) async {
    await reservationsCollection.doc(reservationId).update({"status": status});
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

  static Future<RestaurantModel?> getMyRestaurant() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await restaurantsCollection
        .where("ownerId", isEqualTo: uid)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return RestaurantModel.fromJson(
      snapshot.docs.first.data(),
      snapshot.docs.first.id,
    );
  }

  static Future<void> updateRestaurant(RestaurantModel restaurant) async {
    await restaurantsCollection.doc(restaurant.id).update(restaurant.toJson());
  }

  static Future<void> deleteRestaurant(String ownerId) async {
    await restaurantsCollection.doc(ownerId).delete();
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
