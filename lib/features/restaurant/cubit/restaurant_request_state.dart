class RestaurantRequestState {}

class RestaurantRequestInitialState extends RestaurantRequestState {}

class RestaurantRequestLoadingState extends RestaurantRequestState {}

class RestaurantRequestSuccessState extends RestaurantRequestState {}

class RestaurantRequestErrorState extends RestaurantRequestState {
  final String error;

  RestaurantRequestErrorState({required this.error});
}
