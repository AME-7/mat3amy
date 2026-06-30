import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/main/home/widgets/header.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';
import 'package:mat3amy/features/main/home/widgets/banner.dart';
import 'package:mat3amy/features/main/home/widgets/categories.dart';
import 'package:mat3amy/features/main/home/widgets/restaurant_list.dart';
import 'package:mat3amy/features/main/home/widgets/restaurants_header.dart';
import 'package:mat3amy/features/main/home/widgets/search_bar.dart';

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
    _searchController.dispose();
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
                Header(currentUser: currentUser),

                const Gap(20),
                HomeBannerWidget(
                  restaurants: restaurants,
                  pageController: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentBanner = index;
                    });
                  },
                ),

                const Gap(25),
                SearchBarWidget(
                  controller: _searchController,
                  onTap: widget.onSearch,
                ),
                const Gap(20),

                CategoriesWidget(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
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
                ),

                const Gap(30),

                RestaurantsHeader(restaurants: restaurants),
                const Gap(15),

                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (restaurants.isEmpty)
                  const Center(child: Text("لا توجد مطاعم"))
                else
                  RestaurantsListWidget(restaurants: filteredRestaurants),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
