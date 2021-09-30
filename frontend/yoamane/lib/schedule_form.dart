import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';

class ScheduleFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScheduleFormPage();
}

class _ScheduleFormPage extends State<ScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> friendList = [];
  List<bool> _values = [];
  List<Map<String, dynamic>> _hour = [];
  List<Map<String, dynamic>> _minute = [];
  List<Map<String, dynamic>> _notificationTime = [];

  void setup() {
    DateTime now = DateTime.now();
    _hour = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                12,
                (j) => DateTime(now.year, now.month, now.day, 07)
                    .add(Duration(hours: i))),
            key: (item) => 'value',
            value: (item) => DateFormat('H時').format(item)));

    _minute = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                12,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: i * 5))),
            key: (item) => 'value',
            value: (item) => DateFormat('m分').format(item)));

    _notificationTime = new List.generate(
        11,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                11,
                (j) => DateTime(now.year, now.month, now.day, 00, 05)
                    .add(Duration(minutes: i * 5))),
            key: (item) => 'value',
            value: (item) => DateFormat('m分前').format(item)));
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

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
              Text('予定名'),
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('開始時間'),
              Row(
                children: [
                  Container(
                    width: deviceWidth / 2.0 - 20.0,
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      initialValue: '-',
                      icon: Icon(Icons.calendar_today_sharp),
                      labelText: '時',
                      items: _hour,
                      // onChanged: (val) => print(val),
                      // onSaved: (val) => print(val),
                    ),
                  ),
                  Container(
                    width: deviceWidth / 2.0 - 20.0,
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      initialValue: '-',
                      icon: Icon(Icons.calendar_today_sharp),
                      labelText: '分',
                      items: _minute,
                      // onChanged: (val) => print(val),
                      // onSaved: (val) => print(val),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('終了時間'),
              Row(
                children: [
                  Container(
                    width: deviceWidth / 2.0 - 20.0,
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      initialValue: '-',
                      icon: Icon(Icons.calendar_today_sharp),
                      labelText: '時',
                      items: _hour,
                      // onChanged: (val) => print(val),
                      // onSaved: (val) => print(val),
                    ),
                  ),
                  Container(
                    width: deviceWidth / 2.0 - 20.0,
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      initialValue: '-',
                      icon: Icon(Icons.calendar_today_sharp),
                      labelText: '分',
                      items: _minute,
                      // onChanged: (val) => print(val),
                      // onSaved: (val) => print(val),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('通知時間'),
              SelectFormField(
                type: SelectFormFieldType.dropdown,
                initialValue: '-',
                icon: Icon(Icons.calendar_today_sharp),
                labelText: '分',
                items: _notificationTime,
                // onChanged: (val) => print(val),
                // onSaved: (val) => print(val),
              ),
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
