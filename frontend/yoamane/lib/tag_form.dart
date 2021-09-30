import 'yoamane_libraries.dart';

class TagFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TagFormPage();
}

class _TagFormPage extends State<TagFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<bool> _values = List.filled(friendList.length, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新規タグ'),
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
              Text('タグ名'),
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('タグ付けする友達'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: friendList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(friendList[index]),
                    activeColor: Colors.black,
                    value: _values[index],
                    onChanged: (bool? value) => setState(() {
                      _values[index] = value!;
                    }),
                  );
                },
              ),
//              Text('あなたのタグ'),
//              ListView.builder(
//                shrinkWrap: true,
//                itemCount: tags.length,
//                itemBuilder: (context, index) {
//                  return Text(tags[index]);
//                },
//              ),
              Container(
                width: double.infinity,
                height: 125.0,
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('保存'),
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => CalendarPage(),
                    //     ),
                    //   );
                    // }
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
