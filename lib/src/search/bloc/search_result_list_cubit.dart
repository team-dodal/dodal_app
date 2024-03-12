import 'package:dodal_app/src/challenge_list/bloc/challenge_list_filter_cubit.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/challenge_model.dart';
import 'package:dodal_app/src/common/repositories/challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const PAGE_SIZE = 20;

class SearchResultListCubit extends Cubit<SearchResultListState> {
  SearchResultListCubit({
    required String word,
    required ConditionEnum condition,
    required List<int> certCntList,
  }) : super(SearchResultListState.init(word)) {
    refreshData(condition, certCntList);
  }

  void refreshData(ConditionEnum condition, List<int> certCntList) async {
    emit(SearchResultListState.init(state.word));
    if (state.status == CommonStatus.loading) return;
    if (state.status == CommonStatus.error) return;
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await ChallengeRepository.getChallengesByKeyword(
        word: state.word,
        conditionCode: condition.index,
        certCntList: certCntList,
        page: state.currentPage,
        pageSize: PAGE_SIZE,
      );
      emit(
        state.copyWith(
          status: CommonStatus.loaded,
          items: List.unmodifiable([...res]),
          currentPage: state.currentPage + 1,
          isLastPage: res.length < PAGE_SIZE,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CommonStatus.error,
          errorMessage: '불러오는 도중 에러가 발생하였습니다.',
        ),
      );
    }
  }

  void addData(ConditionEnum condition, List<int> certCntList) async {
    if (state.status == CommonStatus.loading) return;
    if (state.status == CommonStatus.error) return;
    if (state.isLastPage) return;
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await ChallengeRepository.getChallengesByKeyword(
        word: state.word,
        conditionCode: condition.index,
        certCntList: certCntList,
        page: state.currentPage,
        pageSize: PAGE_SIZE,
      );
      emit(
        state.copyWith(
          status: CommonStatus.loaded,
          items: List.unmodifiable([...state.items, ...res]),
          currentPage: state.currentPage + 1,
          isLastPage: res.length < PAGE_SIZE,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CommonStatus.error,
          errorMessage: '불러오는 도중 에러가 발생하였습니다.',
        ),
      );
    }
  }
}

class SearchResultListState extends Equatable {
  final String word;
  final CommonStatus status;
  final List<Challenge> items;
  final int currentPage;
  final bool isLastPage;
  final String? errorMessage;

  const SearchResultListState({
    required this.word,
    required this.status,
    required this.items,
    required this.currentPage,
    required this.isLastPage,
    this.errorMessage,
  });

  const SearchResultListState.init(String word)
      : this(
          word: word,
          status: CommonStatus.init,
          items: const [],
          currentPage: 0,
          isLastPage: false,
        );

  SearchResultListState copyWith({
    String? word,
    CommonStatus? status,
    List<Challenge>? items,
    int? currentPage,
    bool? isLastPage,
    String? errorMessage,
  }) {
    return SearchResultListState(
      word: word ?? this.word,
      status: status ?? this.status,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [word, items, status, currentPage, isLastPage, errorMessage];
}
