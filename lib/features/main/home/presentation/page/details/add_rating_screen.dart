import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/main/home/model/rating_model.dart';

class AddRatingScreen extends StatefulWidget {
  const AddRatingScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  State<AddRatingScreen> createState() => _AddRatingScreenState();
}

class _AddRatingScreenState extends State<AddRatingScreen> {
  double rating = 5;

  final commentController = TextEditingController();

  Future<void> submitRating() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final rate = RatingModel(
      userId: user.uid,
      userName: user.displayName ?? "مستخدم",
      restaurantId: widget.restaurantId,
      rate: rating,
      comment: commentController.text.trim(),
    );

    await FirebaseProvider.addRating(rate);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم إضافة التقييم بنجاح")));

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة تقييم"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (value) {
                rating = value;
              },
            ),

            const SizedBox(height: 25),

            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "اكتب رأيك",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: submitRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text(
                  "إرسال التقييم",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
