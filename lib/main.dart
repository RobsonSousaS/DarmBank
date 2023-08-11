import 'package:bank_darm/Imports/imports.dart';
import 'package:bank_darm/routers/routers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp.router(
    title: 'DarmBank',
    debugShowCheckedModeBanner: false,
    routerDelegate: routers.routerDelegate,
    routeInformationParser: routers.routeInformationParser,
    routeInformationProvider: routers.routeInformationProvider,
  ));
}
