import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dodal_app/src/common/enum/challenge_code_enum.dart';
import 'package:dodal_app/src/common/model/category_model.dart';
import 'package:dodal_app/src/common/model/challenge_model.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/repositories/challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomChallengeListBloc
    extends Bloc<CustomFeedListEvent, CustomFeedListState> {
  final List<Category> categories;

  CustomChallengeListBloc(this.categories) : super(CustomFeedListState.init()) {
    on<CustomFeedListEvent>((event, emit) async {
      if (event is LoadInterestListEvent) {
        await _onLoadInterestList(event, emit);
      }
      if (event is LoadPopularListEvent) {
        await _onLoadPopularList(event, emit);
      }
      if (event is LoadRecentListEvent) {
        await _onLoadRecentList(event, emit);
      }
    }, transformer: sequential());
    add(LoadInterestListEvent());
    add(LoadPopularListEvent());
    add(LoadRecentListEvent());
  }

  _onLoadInterestList(LoadInterestListEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      List<List<Challenge>> list = [...state.interestList];
      for (final category in categories) {
        final res = await ChallengeRepository.getChallengesByCategory(
          categoryValue: category.value,
          tagValue: '',
          conditionCode: ChallengeCodeEnum.interest.index,
          certCntList: [1, 2, 3, 4, 5, 6, 7],
          page: 0,
          pageSize: 3,
        );
        list.add(res);
      }
      emit(state.copyWith(
        status: CommonStatus.loaded,
        interestList: list.toSet().toList(),
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: 'Failed to load interest list',
      ));
    }
  }

  _onLoadPopularList(LoadPopularListEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await ChallengeRepository.getChallenges(
        conditionCode: ChallengeCodeEnum.popular.index,
        page: 0,
        pageSize: 4,
      );
      emit(state.copyWith(
        status: CommonStatus.loaded,
        popularList: res,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: 'Failed to load popular list',
      ));
    }
  }

  _onLoadRecentList(LoadRecentListEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await ChallengeRepository.getChallenges(
        conditionCode: ChallengeCodeEnum.recent.index,
        page: 0,
        pageSize: 3,
      );
      emit(state.copyWith(
        status: CommonStatus.loaded,
        recentList: res,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: 'Failed to load recent list',
      ));
    }
  }
}

abstract class CustomFeedListEvent extends Equatable {}

class LoadInterestListEvent extends CustomFeedListEvent {
  @override
  List<Object?> get props => [];
}

class LoadPopularListEvent extends CustomFeedListEvent {
  @override
  List<Object?> get props => [];
}

class LoadRecentListEvent extends CustomFeedListEvent {
  @override
  List<Object?> get props => [];
}

class CustomFeedListState extends Equatable {
  final CommonStatus status;
  final List<List<Challenge>> interestList;
  final List<Challenge> popularList;
  final List<Challenge> recentList;
  final String? errorMessage;

  const CustomFeedListState({
    this.status = CommonStatus.init,
    this.interestList = const [],
    this.popularList = const [],
    this.recentList = const [],
    this.errorMessage,
  });

  CustomFeedListState copyWith({
    CommonStatus? status,
    List<List<Challenge>>? interestList,
    List<Challenge>? popularList,
    List<Challenge>? recentList,
    String? errorMessage,
  }) {
    return CustomFeedListState(
      status: status ?? this.status,
      interestList: interestList ?? this.interestList,
      popularList: popularList ?? this.popularList,
      recentList: recentList ?? this.recentList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  CustomFeedListState.init()
      : this(
          status: CommonStatus.init,
          interestList: [],
          popularList: [],
          recentList: [],
        );

  @override
  List<Object?> get props =>
      [status, interestList, popularList, recentList, errorMessage];
}
