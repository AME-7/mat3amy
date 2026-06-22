import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mat3amy/core/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/main/home/page/details/restaurant_details_screen.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onSearch});

  final Function() onSearch;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RestaurantModel> filteredRestaurants = [];

  final List<String> categories = [
    "الكل",
    "مشويات",
    "مأكولات بحرية",
    "بيتزا",
    "برجر",
    "كافيه",
  ];

  String selectedCategory = "الكل";

  final PageController _pageController = PageController();
  int currentBanner = 0;
  Timer? timer;

  final TextEditingController _searchController = TextEditingController();

  List<RestaurantModel> restaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getRestaurants();

    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (restaurants.isEmpty) return;

      currentBanner++;

      if (currentBanner >= restaurants.length) {
        currentBanner = 0;
      }

      _pageController.animateToPage(
        currentBanner,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> getRestaurants() async {
    try {
      restaurants = await FirebaseProvider.getRestaurantsData();

      filteredRestaurants = restaurants;
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              splashRadius: 20,
              icon: const Icon(
                Icons.notifications_active,
                color: AppColors.darkColor,
              ),
              onPressed: () {},
            ),
          ),
        ],
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          'مـــطـــعـامــك',
          style: AppTextStyles.title18.copyWith(color: AppColors.whiteColor),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getRestaurants,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'مرحبا، ', style: AppTextStyles.body16),
                      TextSpan(
                        text: currentUser?.displayName ?? '',
                        style: AppTextStyles.title18.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(20),

                Text(
                  "احجز الآن افضل المطاعم باسرع طريقه.",
                  style: AppTextStyles.title18.copyWith(
                    color: AppColors.darkColor,
                    fontSize: 25,
                  ),
                ),

                const Gap(20),

                _searchBar(context),

                const Gap(20),

                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      final isSelected = selectedCategory == category;

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;

                              if (category == "الكل") {
                                filteredRestaurants = restaurants;
                              } else {
                                filteredRestaurants = restaurants
                                    .where((e) => e.category == category)
                                    .toList();
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: AppColors.primaryColor),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Gap(30),
                SizedBox(
                  height: 170,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: restaurants.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentBanner = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                restaurant.image ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) {
                                  return Container(
                                    color: AppColors.primaryColor,
                                  );
                                },
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: .6),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                              right: 20,
                              left: 20,
                              bottom: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.name ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    restaurant.description ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const Gap(25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("أفضل المطاعم", style: AppTextStyles.title18),
                    Text(
                      "${restaurants.length} مطعم",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Gap(15),

                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (restaurants.isEmpty)
                  const Center(child: Text("لا توجد مطاعم"))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = filteredRestaurants[index];

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
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: .2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    restaurant.image ?? '',
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) {
                                      return Container(
                                        width: 90,
                                        height: 90,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.restaurant),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurant.name ?? '',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        restaurant.description ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),

                                      const SizedBox(height: 8),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text("${restaurant.rate ?? 0}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(Icons.arrow_forward_ios, size: 18),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _searchBar(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .3),
            blurRadius: 15,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: TextFormField(
        readOnly: true,
        onTap: widget.onSearch,
        controller: _searchController,
        cursorColor: AppColors.primaryColor,
        decoration: InputDecoration(
          filled: true,
          hintText: 'ابحث عن مطعم',
          hintStyle: AppTextStyles.body16,
          suffixIcon: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: .9),
              borderRadius: BorderRadius.circular(17),
            ),
            child: IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: widget.onSearch,
            ),
          ),
        ),
      ),
    );
  }
}
