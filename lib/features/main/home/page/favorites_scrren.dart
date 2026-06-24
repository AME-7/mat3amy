import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';
import 'package:mat3amy/features/main/home/page/details/restaurant_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<RestaurantModel> restaurants = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  Future<void> getFavorites() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        restaurants = await FirebaseProvider.getFavoriteRestaurants(user.uid);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المفضلة")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : restaurants.isEmpty
          ? const Center(child: Text("لا توجد مطاعم مفضلة"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        restaurant.image ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(restaurant.name ?? ''),
                    subtitle: Text("⭐ ${restaurant.rate ?? 0}"),
                    trailing: const Icon(Icons.favorite, color: Colors.red),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RestaurantDetailsScreen(restaurant: restaurant),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
