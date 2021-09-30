import './yoamane_libraries.dart';
import 'package:http/http.dart' as http;

class ApiPage extends StatefulWidget {
  @override
  _ApiPageState createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  List<dynamic> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            child: Row(
              children: <Widget>[
                Text("${data[index]["user_id"]}"),
              ],
            ),
          );
        },
      ),
    );
  }

  void apiGet() async {
    final Uri address =
        Uri.parse('http://sysken8.japanwest.cloudapp.azure.com/api/user/1');

    http.Response resp = await http.get(address);
    data = json.decode(resp.body);
  }

  @override
  void initState() {
    super.initState();
    apiGet();
  }
}
