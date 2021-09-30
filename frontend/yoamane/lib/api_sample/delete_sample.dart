import '../yoamane_libraries.dart';

import 'package:http/http.dart' as http;

// void main() {
//   // main.dartは基本これだけを呼ぶ
//   runApp(MaterialApp(
//     // runAppにはStatelessWidget or StatefullWidgetを継承したものを渡す
//     home: DeletePage(), //homeで、ルーティング情報ここにかいてく。
//   ));
// }

class DeletePage extends StatefulWidget {
  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  Map data = {};
  List userData = [];

  @override
  Widget build(BuildContext context) {
    // debugPrint(data[0]['name']);

    return Scaffold(
        body: ListView.builder(
          itemCount: userData == null ? 0 : userData.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Row(
                children: <Widget>[
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage(userData[index]["avator"]),
                  // ),
                  Text("${userData[index]["user_id"]}"),
                ],
              ),
            );
          },
        ));
  }

  Future getData() async {
    //Future xxx async{} という記法
    final url =
    Uri.parse('http://sysken8.japanwest.cloudapp.azure.com/api/user/');
    http.Response response = await http.get(url);

    userData = json.decode(response.body); //json->Mapオブジェクトに格納
    // setState(() {
    //   userData = data[0];
    // });

    debugPrint(userData[0].toString());
  }

  void _request() async {
    final url =
    Uri.parse('http://sysken8.japanwest.cloudapp.azure.com/api/user/4/');
    Map<String, String> headers = {'content-type': 'application/json'};
    // String body = json.encode({
    //   'user_id': '00003',
    //   'name': 'user1',
    //   'password': 'tmp',
    // });

    http.Response resp = await http.delete(url);
    // if (resp.statusCode != 200) {
    //   setState(() {
    //     int statusCode = resp.statusCode;
    //     _content = "Failed to post $statusCode";
    //   });
    //   return;
    // }
    // setState(() {
    //   _content = resp.body;
    // });

    debugPrint(resp.statusCode.toString());
  }

// 非同期処理は、デフォルトでは呼び出し元は処理の完了を待ちませんが、
// await キーワードをつけると完了を待つことができる。
  @override
  void initState() {
    super.initState();
    _request();
    // getData();
  }
}
