import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/restaurant/model/restaurant_model.dart';
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
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: AppColors.greyColor,
                  ),

                  SizedBox(height: 20),

                  Text(
                    "لا توجد عناصر في المفضلة",
                    style: AppTextStyles.title18,
                  ),

                  SizedBox(height: 10),

                  Text(
                    "أضف مطاعمك المفضلة لتظهر هنا",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.small14,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: getFavorites,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          restaurant.image ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        restaurant.name ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("⭐ ${restaurant.rate ?? 0}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;

                          if (user == null) return;

                          await FirebaseProvider.removeFavorite(
                            user.uid,
                            restaurant.id!,
                          );

                          setState(() {
                            restaurants.removeAt(index);
                          });

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("تمت الإزالة من المفضلة"),
                            ),
                          );
                        },
                      ),
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
            ),
    );
  }
}
