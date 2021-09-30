import 'yoamane_libraries.dart';

class LogoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LogoutPage();
}

class _LogoutPage extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログアウト'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ログアウトしますか？', style: TextStyle(fontSize: 35.0)),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text('はい', style: TextStyle(fontSize: 15.0)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('いいえ', style: TextStyle(fontSize: 15.0)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
