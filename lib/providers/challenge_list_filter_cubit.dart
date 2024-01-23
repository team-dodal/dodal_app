import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final CATEGORY_ALL = Category(
  name: '전체',
  subName: '',
  value: null,
  emoji: '',
  tags: [const Tag(name: '전체', value: null)],
);

enum ConditionEnum {
  popularity('인기순'),
  newest('최신순'),
  mostAttendees('인원 많은 순'),
  fewestAttendees('인원 작은 순');

  final String displayName;
  const ConditionEnum(this.displayName);
}

class ChallengeListFilterCubit extends Cubit<ChallengeListFilter> {
  ChallengeListFilterCubit({Category? category, ConditionEnum? condition})
      : super(
          ChallengeListFilter(
            category: category ?? CATEGORY_ALL,
            tag: category != null ? category.tags[0] : CATEGORY_ALL.tags[0],
            condition: condition ?? ConditionEnum.popularity,
            certCntList: const [1, 2, 3, 4, 5, 6, 7],
          ),
        );

  updateCategory({required Category category}) {
    emit(state.copyWith(category: category));
  }

  updateTag({required Tag tag}) {
    emit(state.copyWith(tag: tag));
  }

  updateCondition({required ConditionEnum condition}) {
    emit(state.copyWith(condition: condition));
  }

  updateCertCnt({required List<int> certCntList}) {
    certCntList.sort();
    emit(state.copyWith(certCntList: certCntList));
  }
}

class ChallengeListFilter extends Equatable {
  final Category category;
  final Tag tag;
  final ConditionEnum condition;
  final List<int> certCntList;

  const ChallengeListFilter({
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

  @override
  List<Object?> get props => [category, tag, condition, certCntList];
}
