import 'package:flutter/material.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/main/home/model/meal_model.dart';
import 'package:mat3amy/features/main/home/model/rating_model.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';
import 'package:mat3amy/features/main/home/page/details/add_rating_screen.dart';
import 'package:mat3amy/features/main/home/page/reservation_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  List<RatingModel> ratings = [];
  List<MealModel> meals = [];
  bool isLoadingRatings = true;
  bool isLoadingMeals = true;
  bool isFavorite = false;
  double averageRating = 0;

  @override
  void initState() {
    super.initState();
    getMeals();
    loadFavorite();
    getRatings();
  }

  Future<void> getRatings() async {
    ratings = await FirebaseProvider.getRestaurantRatings(
      widget.restaurant.id!,
    );

    if (ratings.isNotEmpty) {
      double total = 0;

      for (final rating in ratings) {
        total += rating.rate ?? 0;
      }

      averageRating = total / ratings.length;
    } else {
      averageRating = 0;
    }

    setState(() {
      isLoadingRatings = false;
    });
  }

  Future<void> openMap() async {
    if (widget.restaurant.mapUrl == null || widget.restaurant.mapUrl!.isEmpty) {
      return;
    }

    await launchUrl(
      Uri.parse(widget.restaurant.mapUrl!),
      mode: LaunchMode.externalApplication,
    );
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
            Hero(
              tag: widget.restaurant.id!,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                child: Image.network(
                  widget.restaurant.image ?? '',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return SizedBox(
                      height: 250,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, _, _) {
                    return Container(
                      height: 250,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.restaurant, size: 80),
                      ),
                    );
                  },
                ),
              ),
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

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(height: 5),
                            Text(
                              "${averageRating.toStringAsFixed(1)} (${ratings.length})",
                            ),
                          ],
                        ),

                        GestureDetector(
                          onTap: openMap,
                          child: Column(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(height: 5),
                              Text(widget.restaurant.distance ?? ''),
                            ],
                          ),
                        ),

                        Column(
                          children: [
                            const Icon(Icons.restaurant, color: Colors.green),
                            const SizedBox(height: 5),
                            Text(widget.restaurant.category ?? ''),
                          ],
                        ),
                      ],
                    ),
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
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.star),
                      label: const Text("إضافة تقييم"),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddRatingScreen(
                              restaurantId: widget.restaurant.id!,
                            ),
                          ),
                        );

                        getRatings();
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    "التقييمات",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  if (isLoadingRatings)
                    const Center(child: CircularProgressIndicator())
                  else if (ratings.isEmpty)
                    const Text("لا توجد تقييمات")
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ratings.length,
                      itemBuilder: (context, index) {
                        final rating = ratings[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: Text(
                                        rating.userName ?? "مستخدم",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: List.generate(
                                    5,
                                    (starIndex) => Icon(
                                      starIndex < (rating.rate ?? 0).round()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  rating.comment ?? "",
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReservationScreen(
                      restaurant: widget.restaurant,
                      meals: meals,
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
        ),
      ),
    );
  }
}
