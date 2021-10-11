import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';

class TerminationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TerminationPage();
}

class _TerminationPage extends State<TerminationPage> {
  List<Map<String, dynamic>> _month = [];
  List<Map<String, dynamic>> _day = [];
  List<Map<String, dynamic>> _hour = [];
  List<Map<String, dynamic>> _minute = [];

  DateTime now = DateTime.now();

  void setup() {
    _month = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(12, (j) => DateTime(now.year, i + 1)),
            key: (item) => 'value',
            value: (item) => DateFormat('M月').format(item)));

    _day = new List.generate(
        31,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(31, (j) => DateTime(now.year, now.month, i + 1)),
            key: (item) => 'value',
            value: (item) => DateFormat('dd日').format(item)));

    _hour = new List.generate(
        24,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                24,
                (j) => DateTime(now.year, now.month, now.day, 00)
                    .add(Duration(hours: i))),
            key: (item) => 'value',
            value: (item) => DateFormat('HH時').format(item)));

    _minute = new List.generate(
        60,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                60,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: i))),
            key: (item) => 'value',
            value: (item) => DateFormat('mm分').format(item)));
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('課題終了'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              '課題が終了しました！お疲れ様でした！\n今回の課題の終了時間を教えてください',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0),
            ),
          ),
          SizedBox(width: 20.0, height: 20.0),
          Row(
            children: [
              Container(
                width: deviceWidth / 2.0 - 20.0,
                margin: EdgeInsets.only(left: 20.0),
                child: SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  initialValue: DateFormat('MM月').format(now),
                  icon: Icon(Icons.calendar_today_sharp),
                  labelText: '月',
                  items: _month,
                  style: TextStyle(fontSize: 25.0),
//                  onSaved: (String? value) => setState(() {
//                    _dueMonth = (value!).replaceFirst('月', '');
//                  }),
                ),
              ),
              Container(
                width: deviceWidth / 2.0 - 20.0,
                child: SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  initialValue: DateFormat('dd日').format(now),
                  icon: Icon(Icons.calendar_today_sharp),
                  labelText: '日',
                  items: _day,
                  style: TextStyle(fontSize: 25.0),
//                  onSaved: (String? value) => setState(() {
//                    _dueDay = (value!).replaceFirst('日', '');
//                  }),
                ),
              ),
            ],
          ),
          SizedBox(width: 20.0, height: 20.0),
          Row(
            children: [
              Container(
                width: deviceWidth / 2.0 - 20.0,
                margin: EdgeInsets.only(left: 20.0),
                child: SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  initialValue: DateFormat('HH時').format(now),
                  icon: Icon(Icons.calendar_today_sharp),
                  labelText: '時',
                  items: _hour,
                  style: TextStyle(fontSize: 25.0),
//                  onSaved: (String? value) => setState(() {
//                    _dueMonth = (value!).replaceFirst('月', '');
//                  }),
                ),
              ),
              Container(
                width: deviceWidth / 2.0 - 20.0,
                child: SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  initialValue: DateFormat('mm分').format(now),
                  icon: Icon(Icons.calendar_today_sharp),
                  labelText: '分',
                  items: _minute,
                  style: TextStyle(fontSize: 25.0),
//                  onSaved: (String? value) => setState(() {
//                    _dueDay = (value!).replaceFirst('日', '');
//                  }),
                ),
              ),
            ],
          ),
          SizedBox(width: 20.0, height: 20.0),
          ElevatedButton(
            child: Text('終了'),
            onPressed: () async {
//              _formKey.currentState?.save();
//              if (_dueMonth != '' && _dueDay != '')
//                _assignment["limited_time"] =
//                    "${DateTime.now().year}-$_dueMonth-${_dueDay}T23:59";
//              if (_estimated != '-')
//                _assignment["estimated_work_time"] = "$_estimated:00";
//
//              final _address = Uri.parse(
//                  'http://sysken8.japanwest.cloudapp.azure.com/api/todolist/${_assignment['id']}/');
//              final _headers = {
//                'content-type': 'application/json',
//                'Authorization': token
//              };
//              final _body = json.encode({
//                "name": _assignment["name"],
//                "subject": _assignment["subject"],
//                "limited_time": _assignment["limited_time"],
//                "estimated_work_time": _assignment["estimated_work_time"],
//                "notifying_time": null,
//                "is_work_finished": false,
//                "memo": _assignment["memo"],
//                "user": 2,
//              });
//
//              final _resp =
//                  await http.put(_address, headers: _headers, body: _body);
//
//              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
////                          ignore: unrelated_type_equality_checks
//                content: Text(_resp.statusCode == 200 || _resp.statusCode == 201
//                    ? '保存しました'
//                    : '保存できませんでした'),
//              ));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
