import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mat3amy/core/routes/navigations.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/core/widget/main_button.dart';
import 'package:mat3amy/features/auth/presentation/model/user_model.dart';

class RestaurantProfileScreen extends StatelessWidget {
  const RestaurantProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("حساب المطعم"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: StreamBuilder(
        stream: FirebaseProvider.getCurrentUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final model = UserModel.fromJson(
            snapshot.data!.data() as Map<String, dynamic>,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      model.image != null && model.image!.isNotEmpty
                      ? NetworkImage(model.image!)
                      : null,
                  child: model.image == null || model.image!.isEmpty
                      ? const Icon(Icons.restaurant, size: 50)
                      : null,
                ),

                const SizedBox(height: 20),

                Text(model.name ?? "", style: AppTextStyles.title18),

                const SizedBox(height: 8),

                Text(model.email ?? "", style: AppTextStyles.body16),

                const SizedBox(height: 30),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text("رقم الهاتف"),
                    subtitle: Text(
                      model.phone?.isNotEmpty == true
                          ? model.phone!
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
                      model.city?.isNotEmpty == true
                          ? model.city!
                          : "غير مضافة",
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("نوع الحساب"),
                    subtitle: Text(model.role ?? ""),
                  ),
                ),

                const SizedBox(height: 35),

                MainButton(
                  text: "تعديل البيانات",
                  onPressed: () {
                    // هنضيف شاشة تعديل بيانات المطعم
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
        },
      ),
    );
  }
}
