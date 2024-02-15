import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/challenge_code_enum.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CustomFeedListStatus { init, loading, success, error }

class CustomFeedListBloc
    extends Bloc<CustomFeedListEvent, CustomFeedListState> {
  final List<MyCategory> categories;

  CustomFeedListBloc(this.categories) : super(CustomFeedListState.init()) {
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
    emit(state.copyWith(status: CustomFeedListStatus.loading));
    List<List<Challenge>> list = [...state.interestList];
    for (final category in categories) {
      final res = await ChallengeService.getChallengesByCategory(
        categoryValue: category.value,
        tagValue: '',
        conditionCode: ChallengeCodeEnum.interest.index,
        certCntList: [1, 2, 3, 4, 5, 6, 7],
        page: 0,
        pageSize: 3,
      );
      if (res != null) {
        list.add(res);
      } else {
        emit(state.copyWith(
          status: CustomFeedListStatus.error,
          errorMessage: 'Failed to load interest list',
        ));
        return;
      }
    }
    emit(state.copyWith(
      status: CustomFeedListStatus.success,
      interestList: list,
    ));
  }

  _onLoadPopularList(LoadPopularListEvent event, emit) async {
    emit(state.copyWith(status: CustomFeedListStatus.loading));
    final res = await ChallengeService.getChallenges(
      conditionCode: ChallengeCodeEnum.popular.index,
      page: 0,
      pageSize: 4,
    );

    if (res != null) {
      emit(state.copyWith(
        status: CustomFeedListStatus.success,
        popularList: res,
      ));
    } else {
      emit(state.copyWith(
        status: CustomFeedListStatus.error,
        errorMessage: 'Failed to load popular list',
      ));
    }
  }

  _onLoadRecentList(LoadRecentListEvent event, emit) async {
    emit(state.copyWith(status: CustomFeedListStatus.loading));
    final res = await ChallengeService.getChallenges(
      conditionCode: ChallengeCodeEnum.recent.index,
      page: 0,
      pageSize: 3,
    );

    if (res != null) {
      emit(state.copyWith(
        status: CustomFeedListStatus.success,
        recentList: res,
      ));
    } else {
      emit(state.copyWith(
        status: CustomFeedListStatus.error,
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
  final CustomFeedListStatus status;
  final List<List<Challenge>> interestList;
  final List<Challenge> popularList;
  final List<Challenge> recentList;
  final String? errorMessage;

  const CustomFeedListState({
    this.status = CustomFeedListStatus.init,
    this.interestList = const [],
    this.popularList = const [],
    this.recentList = const [],
    this.errorMessage,
  });

  CustomFeedListState copyWith({
    CustomFeedListStatus? status,
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

  factory CustomFeedListState.init() {
    return const CustomFeedListState(
      status: CustomFeedListStatus.init,
      interestList: [],
      popularList: [],
      recentList: [],
    );
  }

  @override
  List<Object?> get props =>
      [status, interestList, popularList, recentList, errorMessage];
}
