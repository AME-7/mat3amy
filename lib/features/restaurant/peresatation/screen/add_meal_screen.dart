import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat3amy/core/functions/image_uploader.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/widget/custom_text_form_field.dart';
import 'package:mat3amy/core/widget/main_button.dart';
import 'package:mat3amy/features/main/home/presentation/model/meal_model.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_cubit.dart';

class AddMealScreen extends StatefulWidget {
  final MealModel? meal;

  const AddMealScreen({super.key, this.meal});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  File? imageFile;
  String? oldImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.meal != null) {
      nameController.text = widget.meal!.name ?? "";
      descriptionController.text = widget.meal!.description ?? "";
      priceController.text = widget.meal!.price?.toString() ?? "";

      oldImage = widget.meal!.image;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal == null ? "إضافة وجبة" : "تعديل وجبة"),
      ),

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
                      : oldImage != null
                      ? NetworkImage(oldImage!)
                      : null,
                  child: imageFile == null && oldImage == null
                      ? const Icon(Icons.fastfood, size: 40)
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              CustomTextFormField(
                controller: nameController,
                hintText: "اسم الوجبة",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "ادخل اسم الوجبة";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              CustomTextFormField(
                controller: descriptionController,
                hintText: "الوصف",
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "ادخل وصف الوجبة";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              CustomTextFormField(
                controller: priceController,
                hintText: "السعر",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "ادخل السعر";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator()
                  : MainButton(
                      text: widget.meal == null
                          ? "إضافة الوجبة"
                          : "حفظ التعديلات",
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        if (imageFile == null && oldImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("اختر صورة للوجبة")),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        String imageUrl = oldImage ?? "";

                        if (imageFile != null) {
                          final uploadedImage = await uploadImageToCloudinary(
                            imageFile!,
                          );

                          if (uploadedImage == null) {
                            setState(() {
                              isLoading = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("فشل رفع الصورة")),
                            );

                            return;
                          }

                          imageUrl = uploadedImage;
                        }

                        final restaurant =
                            await FirebaseProvider.getMyRestaurant();

                        if (restaurant == null) {
                          setState(() {
                            isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("لم يتم العثور على المطعم"),
                            ),
                          );

                          return;
                        }

                        final meal = MealModel(
                          id: widget.meal?.id,
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          image: imageUrl,
                          price: double.parse(priceController.text.trim()),
                          rate: widget.meal?.rate ?? 0,
                          restaurantId: restaurant.id,
                        );

                        final cubit = context.read<RestaurantDashboardCubit>();

                        if (widget.meal == null) {
                          await cubit.addMeal(meal);
                        } else {
                          await cubit.updateMeal(meal);
                        }

                        setState(() {
                          isLoading = false;
                        });
                        await cubit.loadDashboard();
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
