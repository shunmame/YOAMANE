import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';

class ScheduleFormPage extends StatefulWidget {
  ScheduleFormPage({this.currentDate});

  final currentDate;

  @override
  State<StatefulWidget> createState() => _ScheduleFormPage();
}

class _ScheduleFormPage extends State<ScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<String> friendList = [];
  List<Map<String, dynamic>> _month = [];
  List<Map<String, dynamic>> _day = [];
  List<Map<String, dynamic>> _hour = [];
  List<Map<String, dynamic>> _minute = [];
  List<Map<String, dynamic>> _notificationTime = [];

  void setup() {
    DateTime now = DateTime.now();
    _month = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(12, (j) => DateTime(now.year, i + 1)),
            key: (item) => 'value',
            value: (item) => DateFormat('M月').format(item)));

    _day = new List.generate(
        // 2月30日、みたいな指定もできてしまうのよくない
        31,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(31, (j) => DateTime(now.year, now.month, i + 1)),
            key: (item) => 'value',
            value: (item) => DateFormat('d日').format(item)));

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
    String _title = '';
    String _memo = '';
    String _startHour = '';
    String _startMinute = '';
    String _endHour = '';
    String _endMinute = '';

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
              Text('予定名', style: TextStyle(fontSize: 20.0)),
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
                onSaved: (String? value) => _title = value!,
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('日付', style: TextStyle(fontSize: 20.0)),
              Row(
                children: [
                  Container(
                    width: deviceWidth / 2.0 - 20.0,
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      initialValue: DateFormat('M月').format(widget.currentDate),
                      icon: Icon(Icons.calendar_today_sharp),
                      labelText: '月',
                      items: _month,
                      style: TextStyle(fontSize: 25.0),
                      // onChanged: (val) => print(val),
                      // onSaved: (val) => print(val),
                    ),
                  ),
                  Container(
                    width: deviceWidth / 2.0 - 20.0,
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      initialValue: DateFormat('d日').format(widget.currentDate),
                      icon: Icon(Icons.calendar_today_sharp),
                      labelText: '日',
                      items: _day,
                      style: TextStyle(fontSize: 25.0),
                      // onChanged: (val) => print(val),
                      // onSaved: (val) => print(val),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('開始時間', style: TextStyle(fontSize: 20.0)),
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
                      initialValue: '-',
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
                      initialValue: '-',
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
                      initialValue: '-',
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
                decoration: InputDecoration(border: OutlineInputBorder()),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
                onSaved: (String? value) => _memo = value!,
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
                    final _address = Uri.parse(
                        'http://sysken8.japanwest.cloudapp.azure.com/api/schedule/');
                    final _headers = {
                      'content-type': 'application/json',
                      'Authorization': token
                    };
                    final _body = json.encode({
                      "title": "$_title",
                      "start_time": _date + _startHour + _startMinute + ":00",
                      "end_time": _date + _endHour + _endMinute + ":00",
                      "is_all_day": false,
                      "nofitying_time": null,
                      "collaborating_member_id": 2,
                      "memo": "$_memo",
                      "user": 2,
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
