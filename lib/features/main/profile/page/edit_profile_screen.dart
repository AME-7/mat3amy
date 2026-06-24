import 'package:flutter/material.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/features/auth/presentation/model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController cityController;
  late TextEditingController bioController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user.name ?? '');

    phoneController = TextEditingController(text: widget.user.phone ?? '');

    cityController = TextEditingController(text: widget.user.city ?? '');

    bioController = TextEditingController(text: widget.user.bio ?? '');
  }

  Future<void> saveProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseProvider.updateUser(
        UserModel(
          uid: widget.user.uid,
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          city: cityController.text.trim(),
          bio: bioController.text.trim(),
        ),
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تعديل الحساب")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "الاسم"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "رقم الهاتف"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: "المدينة"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "نبذة تعريفية"),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveProfile,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("حفظ"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
