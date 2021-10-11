// @dart=2.9

import 'yoamane_libraries.dart';
import 'login.dart';
import 'api_sample.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YOAMANE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
//      home: token == '' ? LoginPage() : TimetableTimeFormPage(),
      home: LoginPage(),
    );
  }
}
