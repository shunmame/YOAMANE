import 'yoamane_libraries.dart';

class TerminationMessagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TerminationMessagePage();
}

class _TerminationMessagePage extends State<TerminationMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('課題終了'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '****の課題が終了しました！\nお疲れ様でした！',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
