import 'yoamane_libraries.dart';

import 'package:http/http.dart' as http;

class ApiPage extends StatefulWidget {
  @override
  _ApiPageState createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }

  void _request() async {
    final _address =
        Uri.parse('http://sysken8.japanwest.cloudapp.azure.com/api/todolist/');
    final _headers = {
      'content-type': 'application/json',
      'Authorization': token
    };
    final _body = json.encode({
      "name": "WebClass小テスト",
      "limited_time": "${DateTime.now().year}-10-14T23:59",
      "estimated_work_time": "01:00:00",
      "notifying_time": null,
      "memo": "",
      "user": 2,
      "is_work_finished": false,
      "subject": 9,
    });
//    final _body = json.encode({
//      "name": "演習1~4",D
//      "user": 2,
//    });

    final _resp = await http.post(_address, headers: _headers, body: _body);
    debugPrint('${_resp.statusCode}');

//    final tmp = json.decode(_resp.body);
//    for (int i = 0; i < tmp.length; i++) {
////      if (tmp[i]['subject'] == 1) debugPrint('${tmp[i]['id']}');
//      debugPrint(
//          '${utf8.decode((tmp[i]["name"]).runes.toList())} ${tmp[i]['id']} ${tmp[i]['subject']}');
//    }
//    debugPrint('$tmp');
//    debugPrint('${tmp["subject_id"].runtimeType}');
//    debugPrint('${utf8.decode((tmp["name"]).runes.toList())}');
  }

  @override
  void initState() {
    super.initState();
    _request();
  }
}
