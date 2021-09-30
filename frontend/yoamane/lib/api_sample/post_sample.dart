import '../yoamane_libraries.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  @override
  _PostPage createState() => _PostPage();
}

class _PostPage extends State<PostPage> {
  Map data = {};
  List userData = [];
  late http.Response resp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(width: double.infinity, height: 50.0),
          Text('${resp.body}'),
        ],
      ),
    );
  }

  Future postData() async {
    final url = Uri.parse(
        'http://sysken8.japanwest.cloudapp.azure.com/api-token-auth/');
    http.Response response = await http.get(url);

    userData = json.decode(response.body);
    setState(() {
      userData = data[0];
    });

    // debugPrint(userData[0].toString());
  }

  void getJwt() async {
    final url = Uri.parse(
        'http://sysken8.japanwest.cloudapp.azure.com/api-token-auth/');
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({
      'username': 'user1',
      'password': 'user1',
    });

    resp = await http.post(url, headers: headers, body: body);
  }

  @override
  void initState() {
    super.initState();
    getJwt();
    // postData();
  }
}

// "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6InVzZXIxIiwiZXhwIjoxNjMzMDU0NTc4fQ.BwUuKkShcvjduPN8laSfwUsW9G6XSAGIUw-cNZCzU14"
