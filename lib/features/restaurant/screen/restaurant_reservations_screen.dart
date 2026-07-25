import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mat3amy/core/utils/styles/colors.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_cubit.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_dashboard_state.dart';

class RestaurantReservationsScreen extends StatelessWidget {
  const RestaurantReservationsScreen({super.key});

  Widget reservationStatus(String status) {
    Color color;
    String text;

    switch (status) {
      case "accepted":
        color = Colors.green;
        text = "مقبول";
        break;

      case "rejected":
        color = Colors.red;
        text = "مرفوض";
        break;

      default:
        color = Colors.orange;
        text = "قيد الانتظار";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الحجوزات"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocBuilder<RestaurantDashboardCubit, RestaurantDashboardState>(
        builder: (context, state) {
          if (state is RestaurantDashboardLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestaurantDashboardErrorState) {
            return Center(child: Text(state.error));
          }

          if (state is RestaurantDashboardSuccessState) {
            final reservations = state.reservations;

            if (reservations.isEmpty) {
              return const Center(child: Text("لا توجد حجوزات"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(reservation.userName ?? ""),
                          subtitle: Text(reservation.phone ?? ""),
                        ),

                        const Divider(),

                        Text("عدد الأفراد : ${reservation.persons}"),

                        const SizedBox(height: 5),

                        Text("التاريخ : ${reservation.date}"),

                        const SizedBox(height: 5),

                        Text("الوقت : ${reservation.time}"),

                        const SizedBox(height: 5),

                        Text("الإجمالي : ${reservation.totalPrice} جنيه"),

                        reservationStatus(reservation.status ?? "pending"),
                        const SizedBox(height: 12),

                        const Text(
                          "الوجبات",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        const SizedBox(height: 8),

                        ...reservation.meals!.map(
                          (meal) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.fastfood, size: 18),
                                const SizedBox(width: 8),
                                Expanded(child: Text(meal["name"])),
                                Text("x${meal["quantity"]}"),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: reservation.status == "pending"
                                    ? () {
                                        context
                                            .read<RestaurantDashboardCubit>()
                                            .updateReservationStatus(
                                              reservationId: reservation.id!,
                                              status: "accepted",
                                            );
                                      }
                                    : null,
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "قبول",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: reservation.status == "pending"
                                    ? () {
                                        context
                                            .read<RestaurantDashboardCubit>()
                                            .updateReservationStatus(
                                              reservationId: reservation.id!,
                                              status: "rejected",
                                            );
                                      }
                                    : null,
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "رفض",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
