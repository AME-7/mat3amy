import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/features/main/home/model/reservation_model.dart';
import 'package:mat3amy/features/main/home/page/edit_reservation_screen.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  List<ReservationModel> reservations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getReservations();
  }

  Future<void> getReservations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        reservations = await FirebaseProvider.getReservationsData(user.uid);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteReservation(String id) async {
    await FirebaseProvider.deleteReservation(id);

    setState(() {
      reservations.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("حجوزاتي")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reservations.isEmpty
          ? const Center(child: Text("لا توجد حجوزات"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                reservation.restaurantName ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final result = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("إلغاء الحجز"),
                                    content: const Text(
                                      "هل أنت متأكد من إلغاء الحجز؟",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text("لا"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text("نعم"),
                                      ),
                                    ],
                                  ),
                                );

                                if (result == true) {
                                  await deleteReservation(reservation.id!);
                                }
                              },
                            ),
                            IconButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditReservationScreen(
                                      reservation: reservation,
                                    ),
                                  ),
                                );

                                getReservations();
                              },
                              icon: Icon(Icons.edit, color: Colors.blue),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text("عدد الأشخاص: ${reservation.persons}"),

                        const SizedBox(height: 5),

                        Text("التاريخ: ${reservation.date}"),

                        const SizedBox(height: 5),

                        Text("الوقت: ${reservation.time}"),

                        const SizedBox(height: 5),

                        Text("رقم الهاتف: ${reservation.phone ?? ''}"),

                        const SizedBox(height: 10),

                        if (reservation.meals != null &&
                            reservation.meals!.isNotEmpty) ...[
                          const Text(
                            "الوجبات:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 5),

                          ...reservation.meals!.map(
                            (meal) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                "${meal['mealName']} x ${meal['quantity']}",
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 10),

                        Text(
                          "الإجمالي: ${reservation.totalPrice?.toStringAsFixed(0) ?? 0} ج",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
