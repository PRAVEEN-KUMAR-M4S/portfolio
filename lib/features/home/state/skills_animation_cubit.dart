import 'package:flutter_bloc/flutter_bloc.dart';

class SkillsAnimationCubit extends Cubit<bool> {
  SkillsAnimationCubit() : super(false);

  void markDone() => emit(true);
  void reset() => emit(false);
}
