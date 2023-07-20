import 'package:dodal_app/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<User?> {
  UserCubit() : super(null);

  void set(User user) {
    if (user.toString() != state.toString()) {
      emit(user);
    }
  }

  void clear() {
    emit(null);
  }
}
