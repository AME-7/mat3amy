import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat3amy/core/functions/image_uploader.dart';
import 'package:mat3amy/core/widget/custom_text_form_field.dart';
import 'package:mat3amy/core/widget/main_button.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_cubit.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_state.dart';
import 'package:mat3amy/features/restaurant/model/restaurant_model.dart';

class EditRestaurantScreen extends StatefulWidget {
  final RestaurantModel restaurant;

  const EditRestaurantScreen({super.key, required this.restaurant});

  @override
  State<EditRestaurantScreen> createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final categoryController = TextEditingController();
  final workHoursController = TextEditingController();
  final tablesController = TextEditingController();
  final mapController = TextEditingController();

  File? imageFile;

  String? imageUrl;

  @override
  void initState() {
    super.initState();

    imageUrl = widget.restaurant.image;

    nameController.text = widget.restaurant.name ?? "";
    descriptionController.text = widget.restaurant.description ?? "";
    phoneController.text = widget.restaurant.phone ?? "";
    cityController.text = widget.restaurant.city ?? "";
    categoryController.text = widget.restaurant.category ?? "";
    workHoursController.text = widget.restaurant.workHours ?? "";
    tablesController.text = widget.restaurant.tablesCount?.toString() ?? "";
    mapController.text = widget.restaurant.mapUrl ?? "";
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    cityController.dispose();
    categoryController.dispose();
    workHoursController.dispose();
    tablesController.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RestaurantDashboardCubit, RestaurantDashboardState>(
      listener: (context, state) {
        if (state is RestaurantDashboardSuccessState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("تعديل بيانات المطعم")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: imageFile != null
                        ? FileImage(imageFile!)
                        : (imageUrl != null && imageUrl!.isNotEmpty)
                        ? NetworkImage(imageUrl!)
                        : null,
                    child:
                        imageFile == null &&
                            (imageUrl == null || imageUrl!.isEmpty)
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),

                const SizedBox(height: 25),

                CustomTextFormField(
                  controller: nameController,
                  hintText: "اسم المطعم",
                ),

                const SizedBox(height: 15),

                CustomTextFormField(
                  controller: descriptionController,
                  hintText: "الوصف",
                  maxLines: 4,
                ),

                const SizedBox(height: 15),

                CustomTextFormField(
                  controller: phoneController,
                  hintText: "رقم الهاتف",
                ),

                const SizedBox(height: 15),

                CustomTextFormField(
                  controller: cityController,
                  hintText: "المدينة",
                ),

                const SizedBox(height: 15),

                CustomTextFormField(
                  controller: categoryController,
                  hintText: "التصنيف",
                ),

                const SizedBox(height: 15),

                CustomTextFormField(
                  controller: workHoursController,
                  hintText: "ساعات العمل",
                ),

                const SizedBox(height: 15),

                CustomTextFormField(
                  controller: tablesController,
                  hintText: "عدد الطاولات",
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 15),

                CustomTextFormField(
                  controller: mapController,
                  hintText: "رابط الخريطة",
                ),

                const SizedBox(height: 30),
                MainButton(
                  text: "حفظ التعديلات",
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    String? finalImage = imageUrl;

                    if (imageFile != null) {
                      final uploaded = await uploadImageToCloudinary(
                        imageFile!,
                      );

                      if (uploaded != null) {
                        finalImage = uploaded;
                      }
                    }

                    final restaurant = RestaurantModel(
                      id: widget.restaurant.id,
                      ownerId: widget.restaurant.ownerId,
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                      image: finalImage,
                      category: categoryController.text.trim(),
                      mapUrl: mapController.text.trim(),

                      // نحافظ على القيم القديمة
                      distance: widget.restaurant.distance,
                      rate: widget.restaurant.rate,

                      phone: phoneController.text.trim(),
                      city: cityController.text.trim(),
                      tablesCount: int.tryParse(tablesController.text) ?? 0,
                      workHours: workHoursController.text.trim(),
                      status: widget.restaurant.status,
                    );

                    context.read<RestaurantDashboardCubit>().updateRestaurant(
                      restaurant,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
