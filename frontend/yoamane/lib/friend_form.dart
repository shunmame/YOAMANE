import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';

class FriendFormPage extends StatefulWidget {
  FriendFormPage({this.id});

  final id;

  @override
  State<StatefulWidget> createState() => _FriendFormPage();
}

class _FriendFormPage extends State<FriendFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _friendUserID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('友達追加フォーム'),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 20.0, height: 20.0),
              Text('ID入力', style: TextStyle(fontSize: 25.0)),
              TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
                onSaved: (String? value) => _friendUserID = value!,
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('あなたのID', style: TextStyle(fontSize: 25.0)),
              SizedBox(width: 20.0, height: 25.0),
              Text(
                widget.id,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 45.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Container(
                width: double.infinity,
                height: 125.0,
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('登録', style: TextStyle(fontSize: 20.0)),
                  onPressed: () async {
                    _formKey.currentState?.save();
                    final _address = Uri.parse(
                        'http://sysken8.japanwest.cloudapp.azure.com/api/friend/');
                    final _headers = {
                      'content-type': 'application/json',
                      'Authorization': token
                    };
                    final _body = json.encode({
                      "user": 2,
                      "friend_user": 1,
                      "friend_user_id": _friendUserID,
                    });
                    final _resp = await http.post(_address,
                        headers: _headers, body: _body);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      // ignore: unrelated_type_equality_checks
                      content: Text(
                          _resp.statusCode == 200 || _resp.statusCode == 201
                              ? '保存しました'
                              : '保存できませんでした'),
                    ));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
