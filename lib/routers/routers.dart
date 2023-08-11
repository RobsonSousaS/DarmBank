import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/pages/client/createnewcard.dart';
import 'package:bank_darm/pages/client/splashscreen.dart';
import 'package:go_router/go_router.dart';
export 'package:bank_darm/pages/client/slider.dart';
export 'package:bank_darm/pages/client/login.dart';
export 'package:bank_darm/pages/client/login_signup.dart';
export 'package:bank_darm/pages/client/signup.dart';
export 'package:bank_darm/pages/client/forgotpass.dart';
export 'package:bank_darm/pages/client/listcards.dart';
export 'package:bank_darm/pages/client/usercli.dart';
export 'package:bank_darm/pages/client/carddemonst.dart';
export 'package:bank_darm/pages/administrator/listclients.dart';
export 'package:bank_darm/pages/administrator/listcardsclient.dart';

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
