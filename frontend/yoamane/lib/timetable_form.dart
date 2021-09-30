import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';

class TimetableFormPage extends StatefulWidget {
  TimetableFormPage({this.subjectName, this.classNumber});

  final subjectName;
  final classNumber;

  @override
  State<StatefulWidget> createState() => _TimetableFormPage();
}

class _TimetableFormPage extends State<TimetableFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> friendList = [];
  List<Map<String, dynamic>> _startHour = [];
  List<Map<String, dynamic>> _startMinute = [];
  List<Map<String, dynamic>> _classTime = [];

  void setup() {
    DateTime now = DateTime.now();
    _startHour = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                12,
                (j) => DateTime(now.year, now.month, now.day, 07)
                    .add(Duration(hours: i))),
            key: (item) => 'value',
            value: (item) => DateFormat('H時').format(item)));

    _startMinute = new List.generate(
        6,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                6,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: i * 10))),
            key: (item) => 'value',
            value: (item) => DateFormat('mm分').format(item)));

    _classTime = new List.generate(
        10,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                10,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: i * 10))),
            key: (item) => 'value',
            value: (item) => '${i * 10}分'));
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
        title: Text('予定の追加'),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 20.0, height: 20.0),
              Text('変更前'),
              Text(widget.subjectName, style: TextStyle(fontSize: 30.0)),
              SizedBox(width: 20.0, height: 20.0),
              Text('変更後'),
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('開始時間'),
              SelectFormField(
                type: SelectFormFieldType.dropdown,
                initialValue: '-',
                icon: Icon(Icons.calendar_today_sharp),
                labelText: '時',
                items: _startHour,
                // onChanged: (val) => print(val),
                // onSaved: (val) => print(val),
              ),
              SizedBox(width: 20.0, height: 20.0),
              SelectFormField(
                type: SelectFormFieldType.dropdown,
                initialValue: '-',
                icon: Icon(Icons.calendar_today_sharp),
                labelText: '分',
                items: _startMinute,
                // onChanged: (val) => print(val),
                // onSaved: (val) => print(val),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('授業時間'),
              SelectFormField(
                type: SelectFormFieldType.dropdown,
                initialValue: '-',
                icon: Icon(Icons.calendar_today_sharp),
                labelText: '分',
                items: _classTime,
                // onChanged: (val) => print(val),
                // onSaved: (val) => print(val),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('カラー'),
              SizedBox(width: 20.0, height: 20.0),
              Container(
                width: double.infinity,
                height: 125.0,
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('保存'),
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

List<Color> labelColor = [
  Color.fromARGB(255, 10, 10, 10),
  Color.fromARGB(255, 128, 128, 128),
  Color.fromARGB(255, 192, 192, 192),
  Color.fromARGB(255, 255, 255, 255),
  Color.fromARGB(255, 0, 0, 255),
  Color.fromARGB(255, 0, 0, 128),
  Color.fromARGB(255, 0, 128, 128),
  Color.fromARGB(255, 0, 128, 0),
  Color.fromARGB(255, 0, 255, 0),
  Color.fromARGB(255, 0, 255, 255),
  Color.fromARGB(255, 255, 255, 0),
  Color.fromARGB(255, 255, 0, 0),
  Color.fromARGB(255, 255, 0, 255),
  Color.fromARGB(255, 128, 0, 0),
  Color.fromARGB(255, 128, 0, 128),
  Color.fromARGB(255, 128, 128, 0),
];

List<String> labelName = [
  'black',
  'grey',
  'silver',
  'white',
  'blue',
  'navy',
  'teal',
  'green',
  'lime',
  'aqua',
  'yellow',
  'red',
  'fuchsia',
  'maroon',
  'purple',
  'olive',
];
