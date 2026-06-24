import 'package:flutter/material.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/main/home/model/meal_model.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';
import 'package:mat3amy/features/main/home/page/reservation_screen.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  List<MealModel> meals = [];
  bool isLoadingMeals = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    getMeals();
    loadFavorite();
  }

  Future<void> getMeals() async {
    try {
      meals = await FirebaseProvider.getMealsData(widget.restaurant.id!);
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoadingMeals = false;
    });
  }

  Future<void> loadFavorite() async {
    final user = FirebaseProvider.currentUser;

    if (user == null) return;

    isFavorite = await FirebaseProvider.isFavorite(
      user.uid,
      widget.restaurant.id!,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name ?? ''),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            onPressed: () async {
              final user = FirebaseProvider.currentUser;

              if (user == null) return;

              if (isFavorite) {
                await FirebaseProvider.removeFavorite(
                  user.uid,
                  widget.restaurant.id!,
                );
              } else {
                await FirebaseProvider.addFavorite(
                  userId: user.uid,
                  restaurantId: widget.restaurant.id!,
                );
              }

              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.restaurant.image ?? '',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return Container(
                  height: 250,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.restaurant, size: 80),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant.name ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.restaurant.description ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 5),
                      Text("${widget.restaurant.rate ?? 0}"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 5),
                      Text(widget.restaurant.distance ?? ''),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "الوجبات",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  if (isLoadingMeals)
                    const Center(child: CircularProgressIndicator())
                  else if (meals.isEmpty)
                    const Text("لا توجد وجبات")
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final meal = meals[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                meal.image ?? '',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(meal.name ?? ''),
                            subtitle: Text(
                              meal.description ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              "${meal.price ?? 0} ج",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReservationScreen(
                              restaurant: widget.restaurant,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: const Text(
                        "احجز الآن",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
