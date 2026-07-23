import 'package:flutter/material.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';

class RestaurantReservationsScreen extends StatelessWidget {
  const RestaurantReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الحجوزات"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 0,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text("اسم العميل"),
              subtitle: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("عدد الأفراد : 4"),
                  Text("الساعة : 8:00 PM"),
                  Text("التاريخ : 20/7/2026"),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (_) => const [
                  PopupMenuItem(value: "accept", child: Text("قبول")),
                  PopupMenuItem(value: "رفض", child: Text("رفض")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
