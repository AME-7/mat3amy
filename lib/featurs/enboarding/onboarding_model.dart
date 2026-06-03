import 'package:mat3amy/core/constants/app_images.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingModel> onboardingList = [
  OnboardingModel(
    image: AppImages.on1Svg,
    title: 'ابحث عن  مطعمك',
    description: 'اكتشف مجموعة واسعة من المطاعم .',
  ),
  OnboardingModel(
    image: AppImages.on2Svg,
    title: 'سهولة الحجز',
    description: 'احجز المواعيد بضغطة زرار في أي وقت وفي أي مكان.',
  ),
  OnboardingModel(
    image: AppImages.on3Svg,
    title: 'آمن وسري',
    description: 'كن مطمئنًا لأن خصوصيتك وأمانك هما أهم أولوياتنا.',
  ),
];
