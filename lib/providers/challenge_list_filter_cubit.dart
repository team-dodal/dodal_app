import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConditionEnum {
  popularity('인기순'),
  newest('최신순'),
  mostAttendees('인원 많은 순'),
  fewestAttendees('인원 작은 순');

  final String displayName;
  const ConditionEnum(this.displayName);
}

class ChallengeListFilter {
  Category category;
  Tag tag;
  ConditionEnum condition;
  List<int> certCntList;

  ChallengeListFilter({
    required this.category,
    required this.tag,
    required this.condition,
    required this.certCntList,
  });

  copyWith({
    Category? category,
    Tag? tag,
    ConditionEnum? condition,
    List<int>? certCntList,
  }) {
    return ChallengeListFilter(
      category: category ?? this.category,
      tag: tag ?? this.tag,
      condition: condition ?? this.condition,
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
            condition: ConditionEnum.popularity,
            certCntList: [1, 2, 3, 4, 5, 6, 7],
          ),
        );

  updateData({
    Category? category,
    Tag? tag,
    ConditionEnum? condition,
    List<int>? certCntList,
  }) {
    if (certCntList != null) {
      certCntList.sort();
    }
    final updatedState = state.copyWith(
      category: category,
      tag: tag,
      condition: condition,
      certCntList: certCntList,
    );

    emit(updatedState);
  }
}
