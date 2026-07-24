import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mat3amy/core/routes/navigations.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/core/widget/main_button.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_cubit.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_state.dart';
import 'package:mat3amy/features/restaurant/screen/edit_restaurant_Screen.dart';

class RestaurantProfileScreen extends StatelessWidget {
  const RestaurantProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("حساب المطعم"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
        builder: (context, state) {
          if (state is RestaurantDashboardLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestaurantDashboardErrorState) {
            return Center(child: Text(state.error));
          }

          if (state is RestaurantDashboardSuccessState) {
            final restaurant = state.restaurant;

            if (restaurant == null) {
              return const Center(
                child: Text("لم يتم العثور على بيانات المطعم"),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        restaurant.image != null && restaurant.image!.isNotEmpty
                        ? NetworkImage(restaurant.image!)
                        : null,
                    child: restaurant.image == null || restaurant.image!.isEmpty
                        ? const Icon(Icons.restaurant, size: 50)
                        : null,
                  ),

                  const SizedBox(height: 20),

                  Text(restaurant.name ?? "", style: AppTextStyles.title18),

                  const SizedBox(height: 8),

                  Text(restaurant.category ?? "", style: AppTextStyles.body16),

                  const SizedBox(height: 25),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text("رقم الهاتف"),
                      subtitle: Text(
                        restaurant.phone?.isNotEmpty == true
                            ? restaurant.phone!
                            : "غير مضاف",
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.location_city),
                      title: const Text("المدينة"),
                      subtitle: Text(
                        restaurant.city?.isNotEmpty == true
                            ? restaurant.city!
                            : "غير مضافة",
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.schedule),
                      title: const Text("مواعيد العمل"),
                      subtitle: Text(
                        restaurant.workHours?.isNotEmpty == true
                            ? restaurant.workHours!
                            : "غير محددة",
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.table_restaurant),
                      title: const Text("عدد الطاولات"),
                      subtitle: Text("${restaurant.tablesCount ?? 0}"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.star),
                      title: const Text("التقييم"),
                      subtitle: Text("${restaurant.rate ?? 0.0}"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.social_distance),
                      title: const Text("المسافة"),
                      subtitle: Text(restaurant.distance ?? "غير محددة"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text("وصف المطعم"),
                      subtitle: Text(restaurant.description ?? ""),
                    ),
                  ),

                  const SizedBox(height: 35),

                  MainButton(
                    text: "تعديل البيانات",
                    onPressed: () async {
                      final restaurant =
                          await FirebaseProvider.getMyRestaurant();

                      if (restaurant == null) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<RestaurantDashboardCubit>(),
                            child: EditRestaurantScreen(restaurant: restaurant),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  MainButton(
                    text: "تسجيل الخروج",
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      pushToBase(context, Routes.login);
                    },
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
