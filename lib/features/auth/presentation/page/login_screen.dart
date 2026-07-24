import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:mat3amy/core/constants/app_images.dart';
import 'package:mat3amy/core/functions/validations.dart';
import 'package:mat3amy/core/routes/navigations.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/app_text_styles.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/core/widget/custom_text_form_field.dart';
import 'package:mat3amy/core/widget/main_button.dart';
import 'package:mat3amy/core/widget/password_text_form_field.dart';
import 'package:mat3amy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mat3amy/features/auth/presentation/cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
        if (state is AuthSuccessState) {
          final result = state.loginResult;

          if (result == null) {
            pushToBase(context, Routes.mainApp);
            return;
          }

          if (result.role == "admin") {
            pushToBase(context, Routes.adminRequests);
          } else if (result.role == "user") {
            pushToBase(context, Routes.mainApp);
          } else if (result.role == "restaurant") {
            final restaurant = await FirebaseProvider.getMyRestaurant();

            if (restaurant != null) {
              pushToBase(context, Routes.restaurantMain);
            } else {
              pushToBase(context, Routes.restaurantInfo);
            }
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

                      Text(
                        'سجل دخول الان',
                        style: AppTextStyles.title18.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),

                      const SizedBox(height: 30),

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

                          return null;
                        },
                      ),

                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'نسيت كلمة السر ؟',
                          style: AppTextStyles.small14,
                        ),
                      ),

                      const Gap(20),

                      MainButton(
                        onPressed: state is AuthLoadingState
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  cubit.login();
                                }
                              },
                        text: state is AuthLoadingState
                            ? "جاري تسجيل الدخول..."
                            : "تسجيل الدخول",
                      ),

                      const Gap(30),

                      OutlinedButton.icon(
                        onPressed: () {
                          cubit.loginWithGoogle();
                        },
                        icon: const Icon(Icons.g_mobiledata),
                        label: const Text("تسجيل الدخول بواسطة Google"),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ليس لدي حساب ؟', style: AppTextStyles.body16),
                          const Gap(3),
                          TextButton(
                            onPressed: () {
                              pushReplacement(context, Routes.register);
                            },
                            child: Text(
                              'سجل الان',
                              style: AppTextStyles.body16.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
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
