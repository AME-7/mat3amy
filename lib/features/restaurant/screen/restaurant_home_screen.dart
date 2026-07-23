import 'package:flutter/material.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';

class RestaurantHomeScreen extends StatelessWidget {
  const RestaurantHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة تحكم المطعم"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("مرحبًا بك 👋", style: AppTextStyles.title18),
            const SizedBox(height: 8),
            Text("تابع أداء مطعمك من هنا", style: AppTextStyles.body16),
            const SizedBox(height: 25),

            Row(
              children: const [
                Expanded(
                  child: _DashboardCard(
                    title: "الوجبات",
                    value: "0",
                    icon: Icons.restaurant_menu,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: _DashboardCard(
                    title: "الحجوزات",
                    value: "0",
                    icon: Icons.calendar_month,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: const [
                Expanded(
                  child: _DashboardCard(
                    title: "التقييم",
                    value: "0.0",
                    icon: Icons.star,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: _DashboardCard(
                    title: "الطاولات",
                    value: "0",
                    icon: Icons.table_restaurant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Text("نظرة سريعة", style: AppTextStyles.title18),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "يمكنك من خلال لوحة التحكم إدارة الوجبات، متابعة الحجوزات، والاطلاع على تقييمات العملاء.",
                style: TextStyle(fontSize: 16, height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, size: 35, color: AppColors.primaryColor),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(title),
          ],
        ),
      ),
    );
  }
}
