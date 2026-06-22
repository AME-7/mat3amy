import 'package:flutter/material.dart';
import 'package:mat3amy/core/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/main/home/page/details/restaurant_details_screen.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<RestaurantModel> restaurants = [];
  bool isLoading = false;

  Future<void> searchRestaurant(String value) async {
    if (value.trim().isEmpty) {
      setState(() {
        restaurants = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await FirebaseProvider.searchRestaurants(value);

      restaurants =
          result?.docs.map((doc) {
            return RestaurantModel.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList() ??
          [];
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("البحث"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: searchRestaurant,
              decoration: InputDecoration(
                hintText: "ابحث عن مطعم",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: restaurants.isEmpty
                    ? const Center(child: Text("لا توجد نتائج"))
                    : ListView.builder(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RestaurantDetailsScreen(
                                    restaurant: restaurant,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    restaurant.image ?? '',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) {
                                      return const Icon(
                                        Icons.restaurant,
                                        size: 50,
                                      );
                                    },
                                  ),
                                ),
                                title: Text(restaurant.name ?? ''),
                                subtitle: Text(
                                  restaurant.description ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("${restaurant.rate ?? 0}"),
                                    const Icon(Icons.star, color: Colors.amber),
                                  ],
                                ),
                                onTap: () {
                                  // افتح صفحة تفاصيل المطعم هنا
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
