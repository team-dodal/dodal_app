import 'package:dodal_app/src/challenge/challenge_settings_menu/page/challenge_menu_page.dart';
import 'package:dodal_app/src/challenge/feed/page/challenge_feed_page.dart';
import 'package:dodal_app/src/challenge/home/bloc/challenge_info_bloc.dart';
import 'package:dodal_app/src/challenge/manage/bloc/manage_challenge_feed_bloc.dart';
import 'package:dodal_app/src/challenge/manage/bloc/manage_challenge_member_bloc.dart';
import 'package:dodal_app/src/challenge/manage/page/challenge_manage_page.dart';
import 'package:dodal_app/src/challenge/notice/bloc/challenge_notice_list_bloc.dart';
import 'package:dodal_app/src/challenge/notice/bloc/create_challenge_notice_bloc.dart';
import 'package:dodal_app/src/challenge/notice/page/create_notice_page.dart';
import 'package:dodal_app/src/challenge/notice/page/room_notice_list_page.dart';
import 'package:dodal_app/src/challenge/root/page/challenge_root_page.dart';
import 'package:dodal_app/src/challenge_list/bloc/challenge_list_bloc.dart';
import 'package:dodal_app/src/challenge_list/bloc/challenge_list_filter_cubit.dart';
import 'package:dodal_app/src/challenge_list/page/challenge_list_page.dart';
import 'package:dodal_app/src/comment/bloc/comment_bloc.dart';
import 'package:dodal_app/src/comment/page/comment_page.dart';
import 'package:dodal_app/src/common/bloc/nickname_check_bloc.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/common/model/category_model.dart';
import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/common/model/tag_model.dart';
import 'package:dodal_app/src/common/theme/theme_data.dart';
import 'package:dodal_app/src/create_challenge/bloc/create_challenge_cubit.dart';
import 'package:dodal_app/src/create_challenge/page/create_challenge_complete_page.dart';
import 'package:dodal_app/src/create_challenge/page/create_challenge_route.dart';
import 'package:dodal_app/src/create_feed/bloc/create_feed_bloc.dart';
import 'package:dodal_app/src/create_feed/page/create_feed_page.dart';
import 'package:dodal_app/src/init/page/init_page.dart';
import 'package:dodal_app/src/main/feed_list/bloc/feed_list_bloc.dart';
import 'package:dodal_app/src/main/home/bloc/custom_challenge_list_bloc.dart';
import 'package:dodal_app/src/main/my_challenge/bloc/my_challenge_list_bloc.dart';
import 'package:dodal_app/src/main/my_info/bloc/user_room_feed_info_bloc.dart';
import 'package:dodal_app/src/main/root/page/main_route.dart';
import 'package:dodal_app/src/modify_user/bloc/modify_user_cubit.dart';
import 'package:dodal_app/src/modify_user/page/modify_user_page.dart';
import 'package:dodal_app/src/my_bookmark/bloc/my_bookmark_cubit.dart';
import 'package:dodal_app/src/my_bookmark/page/my_bookmark_page.dart';
import 'package:dodal_app/src/notification/bloc/notification_list_bloc.dart';
import 'package:dodal_app/src/notification/page/notification_page.dart';
import 'package:dodal_app/src/report/page/report_page.dart';
import 'package:dodal_app/src/search/page/search_page.dart';
import 'package:dodal_app/src/settings_menu/page/personal_data_rule_page.dart';
import 'package:dodal_app/src/settings_menu/page/service_rule_page.dart';
import 'package:dodal_app/src/settings_menu/page/settings_menu_page.dart';
import 'package:dodal_app/src/sign_in/bloc/sign_in_bloc.dart';
import 'package:dodal_app/src/sign_in/page/sign_in_page.dart';
import 'package:dodal_app/src/sign_up/bloc/sign_up_cubit.dart';
import 'package:dodal_app/src/sign_up/page/sign_up_complete_page.dart';
import 'package:dodal_app/src/sign_up/page/sign_up_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late GoRouter router;

  @override
  void initState() {
    super.initState();
    router = GoRouter(
      initialLocation: '/',
      refreshListenable: context.read<AuthBloc>(),
      redirect: (context, state) async {
        AuthStatus authStatus = context.read<AuthBloc>().state.status;
        var blockPageInAuthenticationState = ['/', '/sign-in', '/sign-up'];

        switch (authStatus) {
          case AuthStatus.authenticated:
            return blockPageInAuthenticationState
                    .contains(state.matchedLocation)
                ? '/main'
                : state.matchedLocation;
          case AuthStatus.unauthenticated:
            return '/sign-up';
          case AuthStatus.unknown:
            return '/sign-in';
          case AuthStatus.init:
          case AuthStatus.error:
            break;
        }
        return state.path;
      },
      routes: [
        /* init */ GoRoute(
          path: '/',
          builder: (context, state) => const InitPage(),
        ),
        /* main */ GoRoute(
          path: '/main',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => CustomChallengeListBloc(
                  context.read<AuthBloc>().state.user!.categoryList,
                ),
              ),
              BlocProvider(create: (context) => FeedListBloc()),
              BlocProvider(create: (context) => MyChallengeListBloc()),
              BlocProvider(create: (context) => UserRoomFeedInfoBloc()),
            ],
            child: const MainRoute(),
          ),
        ),
        /* sign-in */ GoRoute(
          path: '/sign-in',
          builder: (context, state) => BlocProvider(
            create: (context) => SignInBloc(const FlutterSecureStorage()),
            child: const SignInPage(),
          ),
        ),
        /* sign-up */ GoRoute(
          path: '/sign-up',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  final infoData =
                      context.read<AuthBloc>().state.signInInfoData!;
                  return SignUpCubit(
                    secureStorage: const FlutterSecureStorage(),
                    socialId: infoData.id,
                    email: infoData.email,
                    socialType: infoData.type,
                  );
                },
              ),
              BlocProvider(create: (context) => NicknameBloc()),
            ],
            child: const SignUpRoute(),
          ),
        ),
        /* sign-up-complete */ GoRoute(
          path: '/sign-up-complete',
          builder: (context, state) => const SignUpCompletePage(),
        ),
        /* notification */ GoRoute(
          path: '/notification',
          builder: (context, state) => BlocProvider(
            create: (context) => NotificationListBloc(
              userId: context.read<AuthBloc>().state.user!.id,
            ),
            child: const NotiFicationPage(),
          ),
        ),
        /* report */ GoRoute(
          path: '/report/:id',
          builder: (context, state) => ReportPage(
              roomId: int.parse(state.pathParameters['id'] as String)),
        ),
        /* search */ GoRoute(
          path: '/search',
          builder: (context, state) => const SearchPage(),
        ),
        /* modify-user */ GoRoute(
          path: '/modify-user',
          builder: (context, state) {
            final user = context.read<AuthBloc>().state.user!;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) {
                    return ModifyUserCubit(
                      nickname: user.nickname,
                      content: user.content,
                      image: user.profileUrl,
                      category: user.tagList,
                    );
                  },
                ),
                BlocProvider(
                  create: (context) => NicknameBloc(nickname: user.nickname),
                ),
              ],
              child: const ModifyUserPage(),
            );
          },
        ),
        /* my-bookmark */ GoRoute(
          path: '/bookmark',
          builder: (context, state) => BlocProvider(
            create: (context) => MyBookmarkCubit(),
            child: const MyBookmarkPage(),
          ),
        ),
        /* settings-menu */ GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsMenuPage(),
          routes: [
            GoRoute(
              path: 'personal-data-rule',
              builder: (context, state) => PersonalDataRulePage(),
            ),
            GoRoute(
              path: 'service-rule',
              builder: (context, state) => ServiceRulePage(),
            ),
          ],
        ),
        /* create-feed */ GoRoute(
          path: '/create-feed/:challengeId/:challengeTitle',
          builder: (context, state) => BlocProvider(
            create: (context) => CreateFeedBloc(
                int.parse(state.pathParameters['challengeId'] as String)),
            child:
                CreateFeedPage(title: state.pathParameters['title'] as String),
          ),
        ),
        /* comment */ GoRoute(
          path: '/comment/:feedId',
          builder: (context, state) => BlocProvider(
            create: (context) => CommentBloc(
                int.parse(state.pathParameters['feedId'] as String)),
            child: const CommentPage(),
          ),
        ),
        /* challenge */ GoRoute(
          path: '/challenge/:challengeId',
          builder: (context, state) => BlocProvider(
            create: (context) => ChallengeInfoBloc(
                int.parse(state.pathParameters['challengeId'] as String)),
            child: const ChallengeRootPage(),
          ),
          routes: [
            GoRoute(
              path: 'feed/:title',
              builder: (context, state) => ChallengeFeedPage(
                roomId:
                    int.parse(state.pathParameters['challengeId'] as String),
                roomName: state.pathParameters['title'] as String,
              ),
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) =>
                  ChallengeMenuPage(challenge: state.extra as ChallengeDetail),
            ),
            GoRoute(
              path: 'notice-list/:targetIndex/:isAdmin',
              builder: (context, state) => BlocProvider(
                create: (context) => ChallengeNoticeListBloc(
                  int.parse(state.pathParameters['challengeId'] as String),
                  state.pathParameters['targetIndex'] is String
                      ? int.parse(state.pathParameters['targetIndex'] as String)
                      : null,
                  (state.pathParameters['isAdmin'] == 'true'),
                ),
                child: const RoomNoticeListPage(),
              ),
            ),
            GoRoute(
              path: 'create-notice',
              builder: (context, state) => BlocProvider(
                create: (context) => CreateChallengeNoticeBloc(
                  roomId:
                      int.parse(state.pathParameters['challengeId'] as String),
                ),
                child: const CreateNoticePage(),
              ),
            ),
            GoRoute(
              path: 'manage/:index',
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ManageChallengeMemberBloc(
                      int.parse(state.pathParameters['challengeId'] as String),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => ManageChallengeFeedBloc(
                      int.parse(state.pathParameters['challengeId'] as String),
                    ),
                  ),
                ],
                child: ChallengeManagePage(
                    index: int.parse(state.pathParameters['index'] as String)),
              ),
            )
          ],
        ),
        /* create-challenge */ GoRoute(
          path: '/create-challenge',
          builder: (context, state) => BlocProvider(
            create: (context) {
              if (state.extra != null) {
                final challenge = state.extra as ChallengeDetail;
                return CreateChallengeBloc(
                  roomId: challenge.id,
                  title: challenge.title,
                  content: challenge.content,
                  certContent: challenge.certContent,
                  tagValue: challenge.tag,
                  thumbnailImg: challenge.thumbnailImgUrl,
                  certCorrectImg: challenge.certCorrectImgUrl,
                  certWrongImg: challenge.certWrongImgUrl,
                  recruitCnt: challenge.recruitCnt,
                  certCnt: challenge.certCnt,
                );
              }
              return CreateChallengeBloc();
            },
            child: const CreateChallengeRoute(),
          ),
          routes: [
            GoRoute(
              path: 'complete/:isUpdate',
              builder: (context, state) => CreateChallengeCompletePage(
                isUpdate: state.pathParameters['isUpdate'] == 'true',
              ),
            )
          ],
        ),
        /* challenge-list */ GoRoute(
          path: '/challenge-list',
          builder: (context, state) {
            final extra = (state.extra as Map<String, dynamic>);
            return BlocProvider(
              create: (ctx) {
                return ChallengeListFilterCubit(
                  category: extra['category'] as Category,
                  condition: extra['condition'] as ConditionEnum,
                );
              },
              child: BlocProvider(
                create: (context) => ChallengeListBloc(
                  category: extra['category'] as Category,
                  tag: extra['tag'] as Tag,
                  condition: extra['condition'] as ConditionEnum,
                  certCntList: extra['certCntList'] as List<int>,
                ),
                child: const ChallengeListPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '도달',
      routerConfig: router,
      scrollBehavior: CustomScrollBehavior(),
      theme: lightTheme,
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
