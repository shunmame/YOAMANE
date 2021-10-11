import 'yoamane_libraries.dart';

class TagFormPage extends StatefulWidget {
  TagFormPage({this.friendName});

  final friendName;

  @override
  State<StatefulWidget> createState() => _TagFormPage();
}

class _TagFormPage extends State<TagFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<bool> _values = [];

  void setup() {
    _values = List.filled(widget.friendName.length, false);
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

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
              Text('タグ名', style: TextStyle(fontSize: 25.0)),
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('タグ付けする友達', style: TextStyle(fontSize: 25.0)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.friendName.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(widget.friendName[index],
                        style: TextStyle(fontSize: 30.0)),
                    activeColor: Colors.black,
                    value: _values[index],
                    onChanged: (bool? value) => setState(() {
                      _values[index] = value!;
                    }),
                  );
                },
              ),
              Container(
                width: double.infinity,
                height: 125.0,
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('保存', style: TextStyle(fontSize: 20.0)),
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
