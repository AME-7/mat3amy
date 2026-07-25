import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/restaurant/model/reservation_model.dart';

class EditReservationScreen extends StatefulWidget {
  const EditReservationScreen({super.key, required this.reservation});

  final ReservationModel reservation;

  @override
  State<EditReservationScreen> createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  late TextEditingController personsController;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();

    personsController = TextEditingController(
      text: widget.reservation.persons.toString(),
    );

    selectedDate = DateTime.parse(widget.reservation.date!);

    final parts = widget.reservation.time!.split(' ');
    final timeParts = parts[0].split(':');

    selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: selectedDate ?? DateTime.now(),
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
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  Future<void> updateReservation() async {
    final updatedReservation = ReservationModel(
      id: widget.reservation.id,
      userId: widget.reservation.userId,
      userName: widget.reservation.userName,
      restaurantId: widget.reservation.restaurantId,
      restaurantName: widget.reservation.restaurantName,
      phone: widget.reservation.phone,
      meals: widget.reservation.meals,
      totalPrice: widget.reservation.totalPrice,
      persons: int.tryParse(personsController.text) ?? 1,
      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
      time: selectedTime!.format(context),
    );

    await FirebaseProvider.updateReservation(updatedReservation);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم تعديل الحجز بنجاح")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل الحجز"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
              tileColor: Colors.grey.shade100,
              title: Text(DateFormat('yyyy-MM-dd').format(selectedDate!)),
              trailing: const Icon(Icons.calendar_month),
              onTap: pickDate,
            ),

            const SizedBox(height: 15),

            ListTile(
              tileColor: Colors.grey.shade100,
              title: Text(selectedTime!.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: pickTime,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: updateReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text(
                  "حفظ التعديلات",
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
