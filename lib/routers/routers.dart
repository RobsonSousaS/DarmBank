import 'package:bank_darm/pages/client/createnewcard.dart';
import 'package:bank_darm/pages/client/splashscreen.dart';
import 'package:go_router/go_router.dart';
import 'package:bank_darm/pages/client/slider.dart';
import 'package:bank_darm/pages/client/login.dart';
import 'package:bank_darm/pages/client/login_signup.dart';
import 'package:bank_darm/pages/client/signup.dart';
import 'package:bank_darm/pages/client/forgotpass.dart';
import 'package:bank_darm/pages/client/listcards.dart';
import 'package:bank_darm/pages/client/usercli.dart';
import 'package:bank_darm/pages/client/carddemonst.dart';
import 'package:bank_darm/pages/administrator/listclients.dart';
import 'package:bank_darm/pages/administrator/signup.dart';
import 'package:flutter/material.dart';

GoRouter routers = GoRouter(initialLocation: '/', routes: <GoRoute>[
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/slider',
    builder: (BuildContext context, GoRouterState state) => SliderPage(),
  ),
  GoRoute(
    path: '/loginorsignup',
    builder: (BuildContext context, GoRouterState state) => Loginsignuppage(),
  ),
  GoRoute(
    path: '/login',
    builder: (BuildContext context, GoRouterState state) => const Loginpage(),
  ),
  GoRoute(
    path: '/signup',
    builder: (BuildContext context, GoRouterState state) => CreateAccountPage(),
  ),
  GoRoute(
    path: '/signupadm',
    builder: (BuildContext context, GoRouterState state) =>
        CreateAccountPageAdm(),
  ),
  GoRoute(
    path: '/resetpassword',
    builder: (BuildContext context, GoRouterState state) =>
        const Forgotpasspage(),
  ),
  GoRoute(
    path: '/passwordmessag',
    builder: (BuildContext context, GoRouterState state) =>
        const ForgotpassMessage(),
  ),
  GoRoute(
      path: '/listcards',
      builder: (BuildContext context, GoRouterState state) => CardPage()),
  GoRoute(
      path: '/listcardscli',
      builder: (BuildContext context, GoRouterState state) => CardPage()),
  GoRoute(
    path: '/datailscard/:cardId',
    builder: (BuildContext context, GoRouterState state) {
      final cardId = state.pathParameters['cardId'] as String;
      return CardDetailsPage(
        cardId: cardId,
      );
    },
  ),
  GoRoute(path: '/usercli', builder: (context, state) => UserPage()),
  GoRoute(path: '/createcard', builder: (context, state) => CreatecardPage()),
  GoRoute(path: '/demonstcard', builder: (context, state) => CarddemonstPage()),
  GoRoute(path: '/listcli', builder: (context, state) => ListCliPage()),
  GoRoute(
      path: '/createnewcard', builder: (context, state) => CreateNewcardPage()),
  GoRoute(
    path: '/demonstnewcard/:newCard/:selectedCardType',
    builder: (BuildContext context, GoRouterState state) {
      final newCard = state.pathParameters['newCard'] as String;
      final selectedCardType =
          state.pathParameters['selectedCardType'] as String;
      return CardNewDemonstPage(
          newCard: newCard, selectedCardType: selectedCardType);
    },
  ),
]);
