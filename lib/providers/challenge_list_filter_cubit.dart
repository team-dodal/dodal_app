import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConditionEnum {
  popularity('인기순'),
  newest('최신순'),
  mostAttendees('인원 많은 순'),
  fewestAttendees('인원 작은 순');

  final String displayName;
  const ConditionEnum(this.displayName);
}

class ChallengeListFilterCubit extends Cubit<ChallengeListFilterState> {
  ChallengeListFilterCubit(
      {required Category category, ConditionEnum? condition})
      : super(ChallengeListFilterState.init(category)) {
    if (condition != null) {
      updateCondition(condition: condition);
    }
  }

  void updateCategory({required Category category}) {
    emit(state.copyWith(category: category, tag: category.tags![0]));
  }

  void updateTag({required Tag tag}) {
    emit(state.copyWith(tag: tag));
  }

  void updateCondition({required ConditionEnum condition}) {
    emit(state.copyWith(condition: condition));
  }

  void updateCertCnt({required List<int> certCntList}) {
    certCntList.sort();
    emit(state.copyWith(certCntList: certCntList));
  }
}

class ChallengeListFilterState extends Equatable {
  final Category category;
  final Tag tag;
  final ConditionEnum condition;
  final List<int> certCntList;

  const ChallengeListFilterState({
    required this.category,
    required this.tag,
    required this.condition,
    required this.certCntList,
  });

  ChallengeListFilterState.init(Category category)
      : this(
          category: category,
          tag: category.tags![0],
          condition: ConditionEnum.popularity,
          certCntList: const [1, 2, 3, 4, 5, 6, 7],
        );

  copyWith({
    Category? category,
    Tag? tag,
    ConditionEnum? condition,
    List<int>? certCntList,
  }) {
    return ChallengeListFilterState(
      category: category ?? this.category,
      tag: tag ?? this.tag,
      condition: condition ?? this.condition,
      certCntList: certCntList ?? this.certCntList,
    );
  }

  @override
  List<Object?> get props => [category, tag, condition, certCntList];
}
