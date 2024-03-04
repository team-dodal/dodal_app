import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/widgets/challenge_room/rank_filter_bottom_sheet.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeRankingBloc
    extends Bloc<ChallengeRankingEvent, ChallengeRankingState> {
  final int challengeId;
  ChallengeRankingBloc(this.challengeId) : super(ChallengeRankingState.init()) {
    on<LoadRankingEvent>(_requestRanking);
    on<ChangeFilterEvent>(_changeFilter);
    add(LoadRankingEvent());
  }

  _requestRanking(LoadRankingEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await ChallengeService.getRanks(
        id: challengeId,
        code: state.rankFilter.index,
      );
      if (res.length <= 3) {
        emit(state.copyWith(
          status: CommonStatus.loaded,
          otherList: res,
        ));
      } else {
        emit(state.copyWith(
          status: CommonStatus.loaded,
          topThreeList: res.sublist(0, 3),
          otherList: res,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '랭킹을 불러오는데 실패했습니다.',
      ));
    }
  }

  _changeFilter(ChangeFilterEvent event, emit) async {
    emit(state.copyWith(rankFilter: event.filter));
    add(LoadRankingEvent());
  }
}

abstract class ChallengeRankingEvent extends Equatable {}

class LoadRankingEvent extends ChallengeRankingEvent {
  @override
  List<Object?> get props => [];
}

class ChangeFilterEvent extends ChallengeRankingEvent {
  final ChallengeRankFilterEnum filter;
  ChangeFilterEvent(this.filter);
  @override
  List<Object?> get props => [filter];
}

class ChallengeRankingState extends Equatable {
  final CommonStatus status;
  final String? errorMessage;
  final List<ChallengeRankResponse> topThreeList;
  final List<ChallengeRankResponse> otherList;
  final ChallengeRankFilterEnum rankFilter;

  const ChallengeRankingState({
    required this.status,
    this.errorMessage,
    required this.topThreeList,
    required this.otherList,
    required this.rankFilter,
  });

  ChallengeRankingState.init()
      : this(
          status: CommonStatus.init,
          topThreeList: [],
          otherList: [],
          rankFilter: ChallengeRankFilterEnum.all,
        );

  ChallengeRankingState copyWith({
    CommonStatus? status,
    String? errorMessage,
    List<ChallengeRankResponse>? topThreeList,
    List<ChallengeRankResponse>? otherList,
    ChallengeRankFilterEnum? rankFilter,
  }) {
    return ChallengeRankingState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      topThreeList: topThreeList ?? this.topThreeList,
      otherList: otherList ?? this.otherList,
      rankFilter: rankFilter ?? this.rankFilter,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, topThreeList, otherList, rankFilter];
}
