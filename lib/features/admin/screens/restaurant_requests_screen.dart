import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mat3amy/core/routes/navigations.dart';
import 'package:mat3amy/core/routes/routes.dart';
import 'package:mat3amy/features/auth/presentation/repo/auth_repo.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_cubit.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_request_state.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantCubit>().getRestaurantRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طلبات المطاعم"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final logout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("تسجيل الخروج"),
                  content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("إلغاء"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("خروج"),
                    ),
                  ],
                ),
              );

              if (logout != true) return;

              final result = await AuthRepo.logout();

              result.fold(
                (failure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(failure.massage)));
                },
                (_) {
                  pushToBase(context, Routes.login);
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<RestaurantCubit, RestaurantRequestState>(
        builder: (context, state) {
          final cubit = context.read<RestaurantCubit>();

          if (state is RestaurantRequestLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cubit.requests.isEmpty) {
            return const Center(child: Text("لا توجد طلبات"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cubit.requests.length,
            itemBuilder: (context, index) {
              final request = cubit.requests[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          request.image,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(request.name),
                        subtitle: Text("${request.city} - ${request.category}"),
                        trailing: Text(request.status),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                cubit.approveRestaurant(request);
                              },
                              child: const Text("قبول"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                cubit.rejectRestaurant(request.ownerId);
                              },
                              child: const Text("رفض"),
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
        },
      ),
    );
  }
}
