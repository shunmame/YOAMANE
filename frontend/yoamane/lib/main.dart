// @dart=2.9

import 'yoamane_libraries.dart';
import 'login.dart';
import 'timetable.dart';
import 'api_sample/get_sample.dart';
import 'api_sample/post_sample.dart';
import 'termination_message.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LoginPage(),
    );
  }
}
