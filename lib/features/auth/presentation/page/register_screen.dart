import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:mat3amy/core/constants/app_images.dart';
import 'package:mat3amy/core/functions/validations.dart';
import 'package:mat3amy/core/routes/navigations.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/core/widget/custom_text_form_field.dart';
import 'package:mat3amy/core/widget/main_button.dart';
import 'package:mat3amy/core/widget/password_text_form_field.dart';
import 'package:mat3amy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mat3amy/features/auth/presentation/cubit/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  bool isRestaurant = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }

        if (state is AuthSuccessState) {
          if (isRestaurant) {
            pushReplacement(context, Routes.restaurantInfo);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم إنشاء الحساب بنجاح")),
            );

            pushReplacement(context, Routes.login);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            leading: const BackButton(color: AppColors.primaryColor),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppImages.logoSvg, height: 200),

                      const SizedBox(height: 20),

                      Text('سجل حساب جديد', style: AppTextStyles.title18),

                      const SizedBox(height: 30),

                      CustomTextFormField(
                        controller: cubit.nameController,
                        keyboardType: TextInputType.text,
                        hintText: 'اسم المستخدم',
                        prefixIcon: const Icon(Icons.person),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك ادخل الاسم';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      CustomTextFormField(
                        controller: cubit.emailController,
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.end,
                        hintText: 'example@gmail.com',
                        prefixIcon: const Icon(Icons.email_rounded),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك ادخل الايميل';
                          }

                          if (!isEmailValid(value)) {
                            return 'من فضلك ادخل ايميل صحيح';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      PasswordTextFormField(
                        controller: cubit.passwordController,
                        hintText: '********',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك ادخل كلمة المرور';
                          }

                          if (value.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          }

                          return null;
                        },
                      ),
                      Column(
                        children: [
                          RadioListTile<bool>(
                            value: false,
                            groupValue: isRestaurant,
                            title: const Text("مستخدم"),
                            onChanged: (value) {
                              setState(() {
                                isRestaurant = value!;
                              });
                            },
                          ),

                          RadioListTile<bool>(
                            value: true,
                            groupValue: isRestaurant,
                            title: const Text("صاحب مطعم"),
                            onChanged: (value) {
                              setState(() {
                                isRestaurant = value!;
                              });
                            },
                          ),
                        ],
                      ),

                      const Gap(20),

                      MainButton(
                        onPressed: state is AuthLoadingState
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  cubit.register(isRestaurant: isRestaurant);
                                }
                              },
                        text: state is AuthLoadingState
                            ? "جاري إنشاء الحساب..."
                            : "تسجيل حساب جديد",
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لدي حساب ؟',
                              style: AppTextStyles.body16.copyWith(
                                color: AppColors.darkColor,
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                pushReplacement(context, Routes.login);
                              },
                              child: Text(
                                'سجل دخول',
                                style: AppTextStyles.body16.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
