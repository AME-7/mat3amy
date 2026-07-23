import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat3amy/core/widget/custom_text_form_field.dart';
import 'package:mat3amy/core/widget/main_button.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  File? imageFile;

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
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة وجبة")),
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
                  backgroundImage: imageFile == null
                      ? null
                      : FileImage(imageFile!),
                  child: imageFile == null
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

              MainButton(
                text: "إضافة الوجبة",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (imageFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("اختر صورة للوجبة")),
                      );
                      return;
                    }

                    // هنربطها بالـ Firebase في الخطوة الجاية
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
