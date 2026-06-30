import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/main/home/model/meal_model.dart';
import 'package:mat3amy/features/main/home/model/reservation_model.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({
    super.key,
    required this.restaurant,
    required this.meals,
  });

  final RestaurantModel restaurant;
  final List<MealModel> meals;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final TextEditingController personsController = TextEditingController(
    text: "1",
  );

  Map<String, int> selectedMeals = {};

  @override
  void initState() {
    super.initState();

    for (final meal in widget.meals) {
      selectedMeals[meal.id!] = 0;
    }
  }

  double get totalPrice {
    double total = 0;

    for (final meal in widget.meals) {
      total += (meal.price ?? 0) * (selectedMeals[meal.id] ?? 0);
    }

    return total;
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  Future<void> confirmReservation() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("اختر التاريخ والوقت")));
      return;
    }

    final userDoc = await FirebaseProvider.getCurrentUser().first;

    final userData = userDoc.data() as Map<String, dynamic>;

    if (userData['phone'] == null ||
        userData['phone'].toString().trim().isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى إضافة رقم الهاتف من الحساب الشخصي أولاً"),
        ),
      );

      return;
    }

    final selectedMealsData = widget.meals
        .where((meal) => (selectedMeals[meal.id] ?? 0) > 0)
        .map(
          (meal) => {
            "mealId": meal.id,
            "mealName": meal.name,
            "price": meal.price,
            "quantity": selectedMeals[meal.id],
          },
        )
        .toList();

    final user = FirebaseAuth.instance.currentUser;

    final reservation = ReservationModel(
      userId: user?.uid,
      userName: user?.displayName,
      phone: userData['phone'],
      restaurantId: widget.restaurant.id,
      restaurantName: widget.restaurant.name,
      persons: int.tryParse(personsController.text) ?? 1,
      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
      time: selectedTime!.format(context),
      meals: selectedMealsData,
      totalPrice: totalPrice,
    );

    await FirebaseProvider.addReservation(reservation);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم الحجز بنجاح")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name ?? ''),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "اختر الوجبات",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ...widget.meals.map((meal) {
              final quantity = selectedMeals[meal.id] ?? 0;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      meal.image ?? '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(meal.name ?? ''),
                  subtitle: Text("${meal.price ?? 0} ج"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 0) {
                            setState(() {
                              selectedMeals[meal.id!] = quantity - 1;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove_circle),
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectedMeals[meal.id!] = quantity + 1;
                          });
                        },
                        icon: const Icon(Icons.add_circle),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            TextField(
              controller: personsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "عدد الأشخاص",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              tileColor: Colors.grey.shade100,
              title: Text(
                selectedDate == null
                    ? "اختر التاريخ"
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: pickDate,
            ),

            const SizedBox(height: 15),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              tileColor: Colors.grey.shade100,
              title: Text(
                selectedTime == null
                    ? "اختر الوقت"
                    : selectedTime!.format(context),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: pickTime,
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text("إجمالي السعر", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    "${totalPrice.toStringAsFixed(0)} ج",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: confirmReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text(
                  "تأكيد الحجز",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
