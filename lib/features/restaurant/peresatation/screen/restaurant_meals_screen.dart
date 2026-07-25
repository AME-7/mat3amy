import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_cubit.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_state.dart';
import 'package:mat3amy/features/restaurant/peresatation/screen/add_meal_screen.dart';

class RestaurantMealsScreen extends StatefulWidget {
  const RestaurantMealsScreen({super.key});

  @override
  State<RestaurantMealsScreen> createState() => _RestaurantMealsScreenState();
}

class _RestaurantMealsScreenState extends State<RestaurantMealsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantDashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إدارة الوجبات"),
        backgroundColor: AppColors.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMealScreen()),
          );

          context.read<RestaurantDashboardCubit>().loadDashboard();
        },
        child: const Icon(Icons.add),
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
            if (state.meals.isEmpty) {
              return const Center(child: Text("لا توجد وجبات"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: state.meals.length,
              itemBuilder: (context, index) {
                final meal = state.meals[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        meal.image ?? "",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(Icons.fastfood),
                      ),
                    ),

                    title: Text(meal.name ?? ""),

                    subtitle: Text("${meal.price?.toStringAsFixed(0)} جنيه"),

                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == "edit") {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddMealScreen(meal: meal),
                            ),
                          );

                          context
                              .read<RestaurantDashboardCubit>()
                              .loadDashboard();
                        }

                        if (value == "delete") {
                          await context
                              .read<RestaurantDashboardCubit>()
                              .deleteMeal(meal.id!);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: "edit", child: Text("تعديل")),
                        PopupMenuItem(value: "delete", child: Text("حذف")),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
