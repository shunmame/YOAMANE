import 'package:intl/intl.dart';

import '../yoamane_libraries.dart';
import 'package:http/http.dart' as http;

class GetPage extends StatefulWidget {
  @override
  _GetPageState createState() => _GetPageState();
}

class _GetPageState extends State<GetPage> {
  // Map tmpData = {};
  late http.Response resp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
//        children: [
//          SizedBox(width: double.infinity, height: 50.0),
//          Text('${utf8.decode((tmpData[1]['name']).runes.toList())}'),
//        ],
          ),
    );
  }

  void getApi() async {
    final Uri address =
        Uri.parse('http://sysken8.japanwest.cloudapp.azure.com/api/schedule/');
    Map<String, String> headers = {
      'Authorization':
          'JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6InVzZXIxIiwiZXhwIjoxNjMzMDU0NTc4fQ.BwUuKkShcvjduPN8laSfwUsW9G6XSAGIUw-cNZCzU14'
    };

    resp = await http.get(address, headers: headers);

    var tmpData = json.decode(resp.body);

     // debugPrint('${utf8.decode((tmpData[4]['title']).runes.toList())}');
   debugPrint('$tmpData');
  }

  @override
  void initState() {
    super.initState();
    getApi();
  }
}
