import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat3amy/core/constants/app_images.dart';
import 'package:mat3amy/core/functions/image_uploader.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/core/widget/main_button.dart';
import 'package:mat3amy/features/auth/presentation/model/user_model.dart';
import 'package:mat3amy/features/main/profile/page/edit_profile_screen.dart';
import 'package:mat3amy/features/main/profile/widgets/item_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _imagePath;
  File? file;

  String? userId;

  Future<void> _getUser() async {
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> _pickImage() async {
    _getUser();
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        file = File(pickedFile.path);
      });
    }
    String? profileUrl = await uploadImageToCloudinary(file!);
    FirebaseProvider.updateUser(UserModel(uid: userId, image: profileUrl));
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text('الحساب الشخصي'),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.settings, color: AppColors.whiteColor),
            onPressed: () {
              // pushTo(context, Routes.settings);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseProvider.getCurrentUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            UserModel model = UserModel.fromJson(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.whiteColor,
                              child: CircleAvatar(
                                backgroundColor: AppColors.whiteColor,
                                radius: 60,
                                backgroundImage:
                                    (model.image?.isNotEmpty == true)
                                    ? NetworkImage(model.image!)
                                    : (_imagePath != null)
                                    ? FileImage(File(_imagePath!))
                                          as ImageProvider
                                    : const AssetImage(AppImages.bg),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _pickImage();
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${model.name}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.title18,
                              ),
                              const SizedBox(height: 10),
                              (model.city?.isNotEmpty == true)
                                  ? Text(
                                      "${model.city}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.body16,
                                    )
                                  : MainButton(
                                      text: 'تعديل الحساب',

                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EditProfileScreen(user: model),
                                          ),
                                        );
                                      },
                                    ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "نبذه تعريفيه",
                      style: AppTextStyles.body16.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      model.bio?.isNotEmpty == true
                          ? model.bio ?? ''
                          : 'لم تضاف',
                      style: AppTextStyles.small14,
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    Text(
                      "معلومات التواصل",
                      style: AppTextStyles.body16.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.accentColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TileWidget(
                            text: model.email ?? 'لم تضاف',
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 15),
                          TileWidget(
                            text: model.phone?.isNotEmpty == true
                                ? model.phone ?? ''
                                : 'لم تضاف',
                            icon: Icons.call,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 20),
                    Text(
                      "حجوزاتي",
                      style: AppTextStyles.body16.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
