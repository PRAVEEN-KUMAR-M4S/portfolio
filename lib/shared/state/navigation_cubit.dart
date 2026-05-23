import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<String> {
  NavigationCubit() : super('/');

  void navigateTo(String route) => emit(route);
}
