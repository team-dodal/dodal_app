import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ChallengeListStatus { init, loading, success, error }

const pageSize = 20;

class ChallengeListBloc extends Bloc<ChallengeListEvent, ChallengeListState> {
  ChallengeListBloc({
    required Category category,
    required Tag tag,
    required ConditionEnum condition,
    required List<int> certCntList,
  }) : super(ChallengeListState.init()) {
    on<LoadChallengeListEvent>(_loadData);
    on<ResetChallengeListEvent>(_resetData);
    add(LoadChallengeListEvent(
      category: category,
      tag: tag,
      condition: condition,
      certCntList: certCntList,
    ));
  }

  void _resetData(ResetChallengeListEvent event, emit) {
    emit(ChallengeListState.init());
  }

  Future<void> _loadData(LoadChallengeListEvent event, emit) async {
    if (state.status == ChallengeListStatus.loading ||
        state.status == ChallengeListStatus.error) {
      return;
    }
    if (state.isLastPage) return;
    emit(state.copyWith(status: ChallengeListStatus.loading));
    final res = await ChallengeService.getChallengesByCategory(
      categoryValue: event.category.value,
      tagValue: event.tag.value,
      conditionCode: event.condition.index,
      certCntList: event.certCntList,
      page: state.currentPage,
      pageSize: pageSize,
    );
    if (res == null) {
      emit(
        state.copyWith(
          status: ChallengeListStatus.error,
          errorMessage: '불러오는 도중 에러가 발생하였습니다.',
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ChallengeListStatus.success,
          result: [...state.result, ...res],
          currentPage: state.currentPage + 1,
          isLastPage: res.length < pageSize,
        ),
      );
    }
  }
}

abstract class ChallengeListEvent extends Equatable {}

class LoadChallengeListEvent extends ChallengeListEvent {
  final Category category;
  final Tag tag;
  final ConditionEnum condition;
  final List<int> certCntList;
  LoadChallengeListEvent({
    required this.category,
    required this.tag,
    required this.condition,
    required this.certCntList,
  });
  @override
  List<Object?> get props => [category, tag, condition, certCntList];
}

class ResetChallengeListEvent extends ChallengeListEvent {
  @override
  List<Object?> get props => [];
}

class ChallengeListState extends Equatable {
  final ChallengeListStatus status;
  final String? errorMessage;
  final List<Challenge> result;
  final int currentPage;
  final bool isLastPage;

  const ChallengeListState({
    required this.status,
    this.errorMessage,
    required this.result,
    required this.currentPage,
    required this.isLastPage,
  });

  ChallengeListState.init()
      : this(
          result: [],
          status: ChallengeListStatus.init,
          currentPage: 0,
          isLastPage: false,
        );

  ChallengeListState copyWith({
    ChallengeListStatus? status,
    String? errorMessage,
    List<Challenge>? result,
    int? currentPage,
    bool? isLastPage,
  }) {
    return ChallengeListState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, result, currentPage];
}
