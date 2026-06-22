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
  final TextEditingController _doctorName = TextEditingController();

  List<RestaurantModel> restaurants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getRestaurants();
  }

  Future<void> getRestaurants() async {
    try {
      restaurants = await FirebaseProvider.getRestaurantsData();
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
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
      body: SingleChildScrollView(
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

              const Gap(30),

              Text("أفضل المطاعم", style: AppTextStyles.title18),

              const Gap(15),

              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (restaurants.isEmpty)
                const Center(child: Text("لا توجد مطاعم"))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RestaurantDetailsScreen(restaurant: restaurant),
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
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              restaurant.image ?? '',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.restaurant),
                              ),
                            ),
                          ),
                          title: Text(
                            restaurant.name ?? '',
                            style: AppTextStyles.body16,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                restaurant.description ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text("⭐ ${restaurant.rate ?? 0}"),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                ),
            ],
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
        controller: _doctorName,
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
