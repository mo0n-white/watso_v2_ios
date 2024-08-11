import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:watso_v2/common/router/routes.dart';
import 'package:watso_v2/common/widgets/Layout.dart';

import '../auth/auth_provider.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter myRouter(ref) {
  final auth = ref.watch(authControllerProvider);
  ref.onDispose(() => auth.dispose());

  return GoRouter(
      routes: _routes,
      navigatorKey: _rootNavigatorKey,
      initialLocation: Routes.tMain.path,
      refreshListenable: auth,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        // 유저 정보를 불러올때까지 로딩...
        if (auth.isLoading || !auth.hasValue) {
          return Routes.splash.path;
        }

        final authValue = auth.requireValue;
        if (authValue == null) {
          return Routes.login.path;
        }
        // 로그인이 되어있는 상태에서 로그인 페이지로 가려고 하면 메인으로 리다이렉트
        if (state.uri.path == Routes.splash.path) {
          return authValue ? Routes.tMain.path : Routes.login.path;
        }
        if (state.uri.path == Routes.login.path) {
          return authValue ? Routes.tMain.path : null;
        }
        return authValue ? null : Routes.login.path;
      });
}
// splash screen 만들어야함.

final List<RouteBase> _routes = [
  GoRoute(
    path: Routes.splash.path,
    builder: (context, state) {
      return Routes.splash.screen;
    },
  ),
  GoRoute(
    path: Routes.login.path,
    builder: (context, state) {
      return Routes.login.screen;
    },
  ),
  ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, child) {
        return PageLayout(
          body: child,
          location: state.fullPath ?? Routes.tMain.path,
        );
      },
      routes: [
        GoRoute(
          path: Routes.tMain.path,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state) {
            return Routes.tMain.screen;
          },
        ),
        GoRoute(
            path: Routes.tMessaging.path,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              return Routes.tMessaging.screen;
            }),
        GoRoute(
            path: Routes.tHistory.path,
            parentNavigatorKey: _shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              return Routes.tHistory.screen;
            }),
      ]),
  GoRoute(
    path: Routes.recruitment(':pageId').path,
    parentNavigatorKey: _rootNavigatorKey,
    builder: (BuildContext context, GoRouterState state) {
      if (state.pathParameters['pageId'] == null) {
        return Routes.tMain.screen;
      }
      return Routes.recruitment(state.pathParameters['pageId']!).screen;
    },
  ),
];
