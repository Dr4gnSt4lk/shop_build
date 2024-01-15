import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_build/mainwrapper.dart';
import 'package:shop_build/screens/home/homepage.dart';
import 'package:shop_build/screens/search/searchpage.dart';
import 'package:shop_build/screens/search/tags.dart';
import 'package:shop_build/screens/settings/settingspage.dart';
import 'package:shop_build/screens/shopping/cart.dart';

class AppNavigation {
  AppNavigation._();

  static String initR = '/home';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _rootNavigatorHome =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');

  static final _rootNavigatorSearch =
      GlobalKey<NavigatorState>(debugLabel: 'shellSearch');
  static final _rootNavigatorCart =
      GlobalKey<NavigatorState>(debugLabel: 'shellCart');
  static final _rootNavigatorSettings =
      GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

  static final GoRouter router = GoRouter(
    initialLocation: initR,
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainWrapper(
              navigationShell: navigationShell,
            );
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(navigatorKey: _rootNavigatorHome, routes: [
              GoRoute(
                path: '/home',
                name: 'Home',
                builder: (context, state) {
                  return HomePage(
                    key: state.pageKey,
                  );
                },
              )
            ]),
            StatefulShellBranch(navigatorKey: _rootNavigatorSearch, routes: [
              GoRoute(
                  path: '/tags',
                  name: 'Tags',
                  builder: (context, state) {
                    return TagsPage(
                      key: state.pageKey,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'search',
                      name: 'Search',
                      builder: (context, state) {
                        return SearchPage(
                          key: state.pageKey,
                        );
                      },
                    )
                  ])
            ]),
            StatefulShellBranch(navigatorKey: _rootNavigatorCart, routes: [
              GoRoute(
                path: '/cart',
                name: 'Cart',
                builder: (context, state) {
                  return CartPage(
                    key: state.pageKey,
                  );
                },
              )
            ]),
            StatefulShellBranch(navigatorKey: _rootNavigatorSettings, routes: [
              GoRoute(
                path: '/settings',
                name: 'Settings',
                builder: (context, state) {
                  return SettingsPage(
                    key: state.pageKey,
                  );
                },
              )
            ]),
          ])
    ],
  );
}
