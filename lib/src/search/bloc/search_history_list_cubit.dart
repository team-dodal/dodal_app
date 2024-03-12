import 'package:hydrated_bloc/hydrated_bloc.dart';

class SearchHistoryListCubit extends HydratedCubit<List<String>> {
  SearchHistoryListCubit() : super([]);

  void addSearchItem(String word) {
    if (state.contains(word)) return;
    final newList = [word, ...state];
    if (newList.length >= 20) {
      newList.removeLast();
    }
    emit(newList);
  }

  void removeItem(int index) {
    final newList = List<String>.from(state);
    newList.removeAt(index);
    emit(newList);
  }

  void removeAll() {
    emit([]);
  }

  @override
  List<String>? fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List;
    return list.map((e) => e as String).toList();
  }

  @override
  Map<String, dynamic>? toJson(List<String> state) => {'list': state};
}
