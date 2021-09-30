import 'yoamane_libraries.dart';

class FriendFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendFormPage();
}

class _FriendFormPage extends State<FriendFormPage> {
  final _formKey = GlobalKey<FormState>();

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
              Text('ID入力'),
              TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('あなたのID'),
              SizedBox(width: 20.0, height: 25.0),
              Text(
                'user01',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Container(
                width: double.infinity,
                height: 125.0,
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('登録'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
