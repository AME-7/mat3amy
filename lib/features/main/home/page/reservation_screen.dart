import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/main/home/model/reservation_model.dart';
import 'package:mat3amy/features/main/home/model/restaurant_model.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final TextEditingController personsController = TextEditingController(
    text: "1",
  );

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

    final user = FirebaseAuth.instance.currentUser;
    final phone = userData['phone'];

    final reservation = ReservationModel(
      userId: user?.uid,
      userName: user?.displayName,
      phone: phone,
      restaurantId: widget.restaurant.id,
      restaurantName: widget.restaurant.name,
      persons: int.tryParse(personsController.text) ?? 1,
      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
      time: selectedTime!.format(context),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: personsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "عدد الأشخاص"),
            ),

            const SizedBox(height: 20),

            ListTile(
              title: Text(
                selectedDate == null
                    ? "اختر التاريخ"
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: pickDate,
            ),

            const SizedBox(height: 20),

            ListTile(
              title: Text(
                selectedTime == null
                    ? "اختر الوقت"
                    : selectedTime!.format(context),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: pickTime,
            ),

            const Spacer(),

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
