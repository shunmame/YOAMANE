import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';

class ScheduleEditPage extends StatefulWidget {
  ScheduleEditPage({this.scheduleData, this.currentDate});

  final scheduleData;
  final currentDate;

  @override
  State<StatefulWidget> createState() => _ScheduleEditPage();
}

class _ScheduleEditPage extends State<ScheduleEditPage> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _schedule = {};
  String _startHour = '';
  String _startMinute = '';
  String _endHour = '';
  String _endMinute = '';

  List<String> friendList = [];
  List<Map<String, dynamic>> _hour = [];
  List<Map<String, dynamic>> _minute = [];
  List<Map<String, dynamic>> _notificationTime = [];

  void setup() {
    _schedule = widget.scheduleData;
    _startHour = DateFormat('HH時')
        .format(DateTime.parse(_schedule["start_time"]).toLocal());
    _startMinute = DateFormat('mm分')
        .format(DateTime.parse(_schedule["start_time"]).toLocal());
    _endHour = DateFormat('HH時')
        .format(DateTime.parse(_schedule["end_time"]).toLocal());
    _endMinute = DateFormat('mm分')
        .format(DateTime.parse(_schedule["end_time"]).toLocal());

    DateTime now = DateTime.now();

    _hour = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                12,
                (j) => DateTime(now.year, now.month, now.day, 07)
                    .add(Duration(hours: i))),
            key: (item) => 'value',
            value: (item) => DateFormat('HH時').format(item)));

    _minute = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                12,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: i * 5))),
            key: (item) => 'value',
            value: (item) => DateFormat('mm分').format(item)));

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

    return Scaffold(
      appBar: AppBar(
        title: Text('予定の変更'),
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
              Text('変更前', style: TextStyle(fontSize: 20.0)),
              Text(utf8Convert(_schedule['title']),
                  style: TextStyle(fontSize: 45.0)),
              SizedBox(width: 20.0, height: 20.0),
              Text('変更後', style: TextStyle(fontSize: 20.0)),
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
                onSaved: (String? value) => _schedule["title"] = value!,
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('開始時間', style: TextStyle(fontSize: 20.0)),
              Row(
                children: [
                  Container(
                    width: deviceWidth / 2.0 - 20.0,
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      initialValue: _startHour,
                      icon: Icon(Icons.calendar_today_sharp),
                      labelText: '時',
                      items: _hour,
                      style: TextStyle(fontSize: 25.0),
                      onSaved: (String? value) => setState(() {
                        _startHour = (value!).replaceFirst('時', ':');
                      }),
                    ),
                  ),
                  Container(
                    width: deviceWidth / 2.0 - 20.0,
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      initialValue: _startMinute,
                      icon: Icon(Icons.calendar_today_sharp),
                      labelText: '分',
                      items: _minute,
                      style: TextStyle(fontSize: 25.0),
                      onSaved: (String? value) => setState(() {
                        _startMinute = (value!).replaceFirst('分', '');
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('終了時間', style: TextStyle(fontSize: 20.0)),
              Row(
                children: [
                  Container(
                    width: deviceWidth / 2.0 - 20.0,
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      initialValue: _endHour,
                      icon: Icon(Icons.calendar_today_sharp),
                      labelText: '時',
                      items: _hour,
                      style: TextStyle(fontSize: 25.0),
                      onSaved: (String? value) => setState(() {
                        _endHour = (value!).replaceFirst('時', ':');
                      }),
                    ),
                  ),
                  Container(
                    width: deviceWidth / 2.0 - 20.0,
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      initialValue: _endMinute,
                      icon: Icon(Icons.calendar_today_sharp),
                      labelText: '分',
                      items: _minute,
                      style: TextStyle(fontSize: 25.0),
                      onSaved: (String? value) => setState(() {
                        _endMinute = (value!).replaceFirst('分', '');
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('通知時間', style: TextStyle(fontSize: 20.0)),
              SelectFormField(
                type: SelectFormFieldType.dropdown,
                initialValue: '-',
                icon: Icon(Icons.calendar_today_sharp),
                labelText: '分前',
                items: _notificationTime,
                style: TextStyle(fontSize: 25.0),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('メモ', style: TextStyle(fontSize: 20.0)),
              TextFormField(
                initialValue: utf8Convert(_schedule["memo"]),
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (String? value) => _schedule["memo"] = value!,
              ),
              Container(
                width: double.infinity,
                height: 125.0,
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('保存', style: TextStyle(fontSize: 20.0)),
                  onPressed: () async {
                    _formKey.currentState?.save();
                    final _date =
                        DateFormat('yyyy-MM-ddT').format(widget.currentDate);
                    if (_startHour != '' && _startMinute != '')
                      _schedule["start_time"] =
                          _date + _startHour + _startMinute;
                    if (_endHour != '' && _endMinute != '')
                      _schedule["end_time"] = _date + _endHour + _endMinute;
                    final _address = Uri.parse(
                        'http://sysken8.japanwest.cloudapp.azure.com/api/schedule/${_schedule["id"]}/');
                    final _headers = {
                      'content-type': 'application/json',
                      'Authorization': token
                    };
                    final _body = json.encode({
                      "title": _schedule["title"],
                      "start_time": _schedule["start_time"],
                      "end_time": _schedule["end_time"],
                      "is_all_day": false,
                      "nofitying_time": null,
                      "collaborating_member_id": 2,
                      "memo": _schedule["memo"],
                      "user": 2,
                    });
                    final _resp = await http.put(_address,
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
