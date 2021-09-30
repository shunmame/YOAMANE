import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';
import 'select_working_time.dart';

class AssignmentFormPage extends StatefulWidget {
  AssignmentFormPage({required this.subjectName});

  final List<String> subjectName;

  @override
  State<StatefulWidget> createState() => _AssignmentFormPage();
}

class _AssignmentFormPage extends State<AssignmentFormPage> {
  final _formKey = GlobalKey<FormState>();

  Set<String> subjectList = {};
  List<bool> _values = [];
  List<Map<String, dynamic>> _startTime = [];
  List<Map<String, dynamic>> _requiredTime = [];
  List<Map<String, dynamic>> _notificationTime = [];

  void setup() {
    subjectList = (widget.subjectName).toSet();

    _values = List.filled(subjectList.length, false);

    DateTime now = DateTime.now();
    _startTime = new List.generate(
        18,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                18,
                (j) => DateTime(now.year, now.month, now.day, 06, 00)
                    .add(Duration(hours: i))),
            key: (item) => 'value',
            value: (item) => DateFormat('HH時mm分').format(item)));

    _requiredTime = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                12,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: 30) * (i + 1))),
            key: (item) => 'value',
            value: (item) => DateFormat('H時間mm分').format(item)));

    _notificationTime = new List.generate(
        10,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                10,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: 15) * (i + 1))),
            key: (item) => 'value',
            value: (item) => DateFormat('H時間mm分前').format(item)));
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('課題の追加'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 20.0, height: 20.0),
              Text('課題名'),
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('日時'),
              SelectFormField(
                type: SelectFormFieldType.dropdown,
                initialValue: '-',
                icon: Icon(Icons.calendar_today_sharp),
                labelText: '開始時間',
                items: _startTime,
                // onChanged: (val) => print(val),
                // onSaved: (val) => print(val),
              ),
              SelectFormField(
                type: SelectFormFieldType.dropdown,
                initialValue: '-',
                icon: Icon(Icons.calendar_today_sharp),
                labelText: '所要時間',
                items: _requiredTime,
                // onChanged: (val) => print(val),
                // onSaved: (val) => print(val),
              ),
              SelectFormField(
                type: SelectFormFieldType.dropdown,
                initialValue: '-',
                icon: Icon(Icons.calendar_today_sharp),
                labelText: '通知時間',
                items: _notificationTime,
                // onChanged: (val) => print(val),
                // onSaved: (val) => print(val),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('教科'),
              LimitedBox(
                maxHeight: deviceHeight / 5.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: subjectList.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(subjectList.elementAt(index)),
                      activeColor: Colors.black,
                      value: _values[index],
                      onChanged: (bool? value) => setState(() {
                        _values[index] = value!;
                      }),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 125.0,
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('次へ'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SelectWorkingTimePage()),
                    );
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
