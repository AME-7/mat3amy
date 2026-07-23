import 'package:flutter/material.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/restaurant/screen/add_meal_screen.dart';

class RestaurantMealsScreen extends StatelessWidget {
  const RestaurantMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إدارة الوجبات"),
        backgroundColor: AppColors.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMealScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: 0,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.fastfood, size: 40),
                ),
              ),
              title: const Text("اسم الوجبة"),
              subtitle: const Text("100 جنيه"),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "edit") {
                    // تعديل
                  } else {
                    // حذف
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
      ),
    );
  }
}
