import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mat3amy/core/functions/image_uploader.dart';
import 'package:mat3amy/features/restaurant/cubit/restaurant_request_state.dart';
import 'package:mat3amy/features/restaurant/model/restaurant_request_model.dart';
import 'package:mat3amy/features/restaurant/repo/restaurant_repo.dart';

class RestaurantCubit extends Cubit<RestaurantRequestState> {
  RestaurantCubit() : super(RestaurantRequestInitialState());

  final formKey = GlobalKey<FormState>();

  File? imageFile;

  String? category;

  List<RestaurantRequestModel> requests = [];

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final openHourController = TextEditingController();
  final closeHourController = TextEditingController();
  final tablesCountController = TextEditingController();
  final mapUrlController = TextEditingController();

  Future<void> submitRestaurantRequest() async {
    emit(RestaurantRequestLoadingState());

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(RestaurantRequestErrorState(error: "يجب تسجيل الدخول أولاً"));
      return;
    }

    if (imageFile == null) {
      emit(RestaurantRequestErrorState(error: "من فضلك اختر صورة للمطعم"));
      return;
    }

    final imageUrl = await uploadImageToCloudinary(imageFile!);

    if (imageUrl == null) {
      emit(RestaurantRequestErrorState(error: "فشل رفع صورة المطعم"));
      return;
    }

    final request = RestaurantRequestModel(
      ownerId: user.uid,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      image: imageUrl,
      category: category ?? "",
      mapUrl: mapUrlController.text.trim(),
      phone: phoneController.text.trim(),
      city: cityController.text.trim(),
      tablesCount: int.tryParse(tablesCountController.text.trim()) ?? 0,
      workHours: "${openHourController.text} - ${closeHourController.text}",
      status: "pending",
    );

    final result = await RestaurantRepo.addRestaurantRequest(request);

    result.fold(
      (failure) {
        emit(RestaurantRequestErrorState(error: failure.massage));
      },
      (_) {
        emit(RestaurantRequestSuccessState());
      },
    );
  }

  Future<void> approveRestaurant(RestaurantRequestModel request) async {
    emit(RestaurantRequestLoadingState());

    final result = await RestaurantRepo.approveRestaurant(request);

    result.fold(
      (failure) {
        emit(RestaurantRequestErrorState(error: failure.massage));
      },
      (_) async {
        await getRestaurantRequests();
      },
    );
  }

  Future<void> rejectRestaurant(String ownerId) async {
    emit(RestaurantRequestLoadingState());

    final result = await RestaurantRepo.rejectRestaurant(ownerId);

    result.fold(
      (failure) {
        emit(RestaurantRequestErrorState(error: failure.massage));
      },
      (_) async {
        await getRestaurantRequests();
      },
    );
  }

  Future<void> getRestaurantRequests() async {
    emit(RestaurantRequestLoadingState());

    final result = await RestaurantRepo.getRestaurantRequests();

    result.fold(
      (failure) {
        emit(RestaurantRequestErrorState(error: failure.massage));
      },
      (data) {
        requests = data;
        emit(RestaurantRequestSuccessState());
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    cityController.dispose();
    openHourController.dispose();
    closeHourController.dispose();
    tablesCountController.dispose();
    mapUrlController.dispose();

    return super.close();
  }
}
