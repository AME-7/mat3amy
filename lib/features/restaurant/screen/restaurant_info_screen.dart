import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mat3amy/core/widget/custom_text_form_field.dart';
import 'package:mat3amy/core/widget/main_button.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_cubit.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_request_state.dart';
import 'package:mat3amy/features/restaurant/widget/restaurant_categories.dart';

class RestaurantInfoScreen extends StatefulWidget {
  const RestaurantInfoScreen({super.key});

  @override
  State<RestaurantInfoScreen> createState() => _RestaurantInfoScreenState();
}

class _RestaurantInfoScreenState extends State<RestaurantInfoScreen> {
  final formKey = GlobalKey<FormState>();
  String? _imagePath;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        context.read<RestaurantCubit>().imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> selectOpenTime(RestaurantCubit cubit) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      cubit.openHourController.text =
          "${picked.hour}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  Future<void> selectCloseTime(RestaurantCubit cubit) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      cubit.closeHourController.text =
          "${picked.hour}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantCubit, RestaurantRequestState>(
      listener: (context, state) {
        if (state is RestaurantRequestSuccessState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("تم إرسال طلبك بنجاح")));

          Navigator.pop(context);
        }

        if (state is RestaurantRequestErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<RestaurantCubit>();

        return Scaffold(
          appBar: AppBar(title: const Text("بيانات المطعم")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: _imagePath == null
                            ? null
                            : FileImage(File(_imagePath!)),
                        child: _imagePath == null
                            ? const Icon(Icons.restaurant, size: 40)
                            : null,
                      ),
                      GestureDetector(
                        onTap: pickImage,
                        child: const CircleAvatar(
                          radius: 18,
                          child: Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  CustomTextFormField(
                    controller: cubit.nameController,
                    hintText: "اسم المطعم",
                    prefixIcon: const Icon(Icons.restaurant),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "من فضلك ادخل اسم المطعم";
                      }
                      return null;
                    },
                  ),

                  const Gap(16),

                  CustomTextFormField(
                    controller: cubit.phoneController,
                    hintText: "رقم الهاتف",
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "من فضلك ادخل رقم الهاتف";
                      }
                      return null;
                    },
                  ),

                  const Gap(16),

                  CustomTextFormField(
                    controller: cubit.cityController,
                    hintText: "المدينة",
                    prefixIcon: const Icon(Icons.location_city),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "من فضلك ادخل اسم المدينه";
                      }
                      return null;
                    },
                  ),

                  const Gap(16),

                  DropdownButtonFormField<String>(
                    initialValue: cubit.category,
                    decoration: const InputDecoration(
                      labelText: "نوع المطعم",
                      border: OutlineInputBorder(),
                    ),
                    items: restaurantCategories.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (value) {
                      cubit.category = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return "اختر نوع المطعم";
                      }
                      return null;
                    },
                  ),

                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          controller: cubit.openHourController,
                          readOnly: true,
                          hintText: "من",
                          suffixIcon: IconButton(
                            onPressed: () => selectOpenTime(cubit),
                            icon: const Icon(Icons.access_time),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "مطلوب";
                            }
                            return null;
                          },
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: CustomTextFormField(
                          controller: cubit.closeHourController,
                          readOnly: true,
                          hintText: "إلى",
                          suffixIcon: IconButton(
                            onPressed: () => selectCloseTime(cubit),
                            icon: const Icon(Icons.access_time),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "مطلوب";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const Gap(16),

                  CustomTextFormField(
                    controller: cubit.tablesCountController,
                    hintText: "عدد الطاولات",
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.table_restaurant),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "من فضلك ادخل عدد الطاولات";
                      }
                      return null;
                    },
                  ),

                  const Gap(16),

                  CustomTextFormField(
                    controller: cubit.mapUrlController,
                    hintText: "رابط Google Maps",
                    prefixIcon: const Icon(Icons.map),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "من فضلك ادخل رابط الموقع";
                      }
                      return null;
                    },
                  ),

                  const Gap(16),

                  CustomTextFormField(
                    controller: cubit.descriptionController,
                    hintText: "وصف المطعم",
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "من فضلك اكتب وصف المطعم";
                      }
                      return null;
                    },
                  ),

                  const Gap(30),

                  MainButton(
                    text: state is RestaurantRequestLoadingState
                        ? "جاري الإرسال..."
                        : "إرسال الطلب",
                    onPressed: state is RestaurantRequestLoadingState
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              if (cubit.imageFile == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("من فضلك اختر صورة للمطعم"),
                                  ),
                                );
                                return;
                              }

                              cubit.submitRestaurantRequest();
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
