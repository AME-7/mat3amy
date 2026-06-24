import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mat3amy/core/services/firebase/firestore_provider.dart';
import 'package:mat3amy/features/main/home/model/reservation_model.dart';

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
                                await deleteReservation(reservation.id!);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text("عدد الأشخاص: ${reservation.persons}"),

                        const SizedBox(height: 5),

                        Text("التاريخ: ${reservation.date}"),

                        const SizedBox(height: 5),

                        Text("الوقت: ${reservation.time}"),
                        Gap(5),
                        Text("رقم الهاتف ${reservation.phone ?? ''}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
