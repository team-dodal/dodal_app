import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const CONDITION_LIST = ['인기순', '최신순', '인원 많은 순', '인원 작은 순'];

class ChallengeListFilter {
  Category category;
  Tag tag;
  int conditionCode;
  List<int> certCntList;

  ChallengeListFilter({
    required this.category,
    required this.tag,
    required this.conditionCode,
    required this.certCntList,
  });

  copyWith({
    Category? category,
    Tag? tag,
    int? conditionCode,
    List<int>? certCntList,
  }) {
    return ChallengeListFilter(
      category: category ?? this.category,
      tag: tag ?? this.tag,
      conditionCode: conditionCode ?? this.conditionCode,
      certCntList: certCntList ?? this.certCntList,
    );
  }
}

class ChallengeListFilterCubit extends Cubit<ChallengeListFilter> {
  final Category category;

  ChallengeListFilterCubit({required this.category})
      : super(
          ChallengeListFilter(
            category: category,
            tag: category.tags[0],
            conditionCode: 0,
            certCntList: [1, 2, 3, 4, 5, 6, 7],
          ),
        );

  updateData({
    Category? category,
    Tag? tag,
    int? conditionCode,
    List<int>? certCntList,
  }) {
    final updatedState = state.copyWith(
      category: category,
      tag: tag,
      conditionCode: conditionCode,
      certCntList: certCntList,
    );

    emit(updatedState);
  }
}
