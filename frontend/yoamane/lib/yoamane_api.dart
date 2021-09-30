import './yoamane_libraries.dart';
import 'package:http/http.dart' as http;

String url = 'http://sysken8.japanwest.cloudapp.azure.com/api/user/';

Future apiGet() async {
  final Uri address = Uri.parse(url);

  http.Response resp = await http.get(address);
  return json.decode(resp.body);
}

Future apiPost(Map<String, String> data) async {
  final Uri address = Uri.parse(url);
  Map<String, String> headers = {'content-type': 'application/json'};
  String body = json.encode(data);

  http.Response resp = await http.post(address, headers: headers, body: body);
  return resp;
}

Future apiPut(Map<String, String> data, int number) async {
  final Uri address = Uri.parse(url + number.toString());
  Map<String, String> headers = {'content-type': 'application/json'};
  String body = json.encode(data);

  http.Response resp = await http.put(address, headers: headers, body: body);
  return resp;
}

Future apiDelete(Map<String, String> data, int number) async {
  final Uri address = Uri.parse(url + number.toString());

  http.Response resp = await http.delete(address);
  return resp;
}
