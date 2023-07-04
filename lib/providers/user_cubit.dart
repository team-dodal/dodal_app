import 'package:dodal_app/model/my_info_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyInfoCubit extends Cubit<User?> {
  MyInfoCubit() : super(null);

  void set(User user) {
    if (user.toString() != state.toString()) {
      emit(user);
    }
  }
}
