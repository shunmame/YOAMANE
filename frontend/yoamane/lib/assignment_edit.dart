import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';
import 'termination.dart';

class AssignmentEditPage extends StatefulWidget {
  AssignmentEditPage({this.assignmentData, this.subjectID, this.currentDate});

  final subjectID;
  final currentDate;
  final assignmentData;

  @override
  State<StatefulWidget> createState() => _AssignmentEditPage();
}

class _AssignmentEditPage extends State<AssignmentEditPage> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _assignment = {};

  String _dueMonth = '';
  String _dueDay = "";
  String _estimated = '';

  List<Map<String, dynamic>> _month = [];
  List<Map<String, dynamic>> _day = [];
  List<Map<String, dynamic>> _estimatedTime = [];
  List<Map<String, dynamic>> _notificationTime = [];

  void setup() {
    _assignment = widget.assignmentData;

    DateTime now = DateTime.now();
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

    _estimatedTime = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                12,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: 30) * (i + 1))),
            key: (item) => 'value',
            value: (item) => DateFormat('HH時間mm分').format(item)));

    _notificationTime = new List.generate(
        10,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                10,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: 15) * (i + 1))),
            key: (item) => 'value',
            value: (item) => DateFormat('HH時間mm分前').format(item)));
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
        title: Text('課題の追加'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20.0, height: 20.0),
                Text('変更前', style: TextStyle(fontSize: 20.0)),
                Text(utf8Convert(_assignment['name']),
                    style: TextStyle(fontSize: 45.0)),
                SizedBox(width: 20.0, height: 20.0),
                Text('変更後', style: TextStyle(fontSize: 20.0)),
                TextFormField(
                  maxLength: 50,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => formStatus(value),
                  onSaved: (String? value) => _assignment["name"] = value!,
                ),
                SizedBox(width: 20.0, height: 20.0),
                Text('提出期限', style: TextStyle(fontSize: 20.0)),
                Row(
                  children: [
                    Container(
                      width: deviceWidth / 2.0 - 20.0,
                      child: SelectFormField(
                        type: SelectFormFieldType.dropdown,
                        initialValue: DateFormat('MM月').format(
                            DateTime.parse(_assignment["limited_time"])),
                        icon: Icon(Icons.calendar_today_sharp),
                        labelText: '月',
                        items: _month,
                        style: TextStyle(fontSize: 25.0),
                        onSaved: (String? value) => setState(() {
                          _dueMonth = (value!).replaceFirst('月', '');
                        }),
                      ),
                    ),
                    Container(
                      width: deviceWidth / 2.0 - 20.0,
                      child: SelectFormField(
                        type: SelectFormFieldType.dropdown,
                        initialValue: DateFormat('dd日').format(
                            DateTime.parse(_assignment["limited_time"])),
                        icon: Icon(Icons.calendar_today_sharp),
                        labelText: '日',
                        items: _day,
                        style: TextStyle(fontSize: 25.0),
                        onSaved: (String? value) => setState(() {
                          _dueDay = (value!).replaceFirst('日', '');
                        }),
                      ),
                    ),
                  ],
                ),
                SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  initialValue: '-',
                  icon: Icon(Icons.calendar_today_sharp),
                  labelText: '所要時間',
                  items: _estimatedTime,
                  style: TextStyle(fontSize: 25.0),
                  onSaved: (String? value) => setState(() {
                    _estimated =
                        (value!).replaceFirst('時間', ':').replaceFirst('分', '');
                  }),
                ),
                SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  initialValue: '-',
                  icon: Icon(Icons.calendar_today_sharp),
                  labelText: '通知時間',
                  items: _notificationTime,
                  style: TextStyle(fontSize: 25.0),
                ),
                SizedBox(width: 20.0, height: 20.0),
                Text('メモ', style: TextStyle(fontSize: 20.0)),
                TextFormField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => formStatus(value),
                  onSaved: (String? value) => _assignment["memo"] = value!,
                ),
                Container(
                  width: double.infinity,
                  height: 125.0,
                  alignment: Alignment.center,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text('保存'),
                        onPressed: () async {
                          _formKey.currentState?.save();
                          if (_dueMonth != '' && _dueDay != '')
                            _assignment["limited_time"] =
                                "${DateTime.now().year}-$_dueMonth-${_dueDay}T23:59";
                          if (_estimated != '-')
                            _assignment["estimated_work_time"] =
                                "$_estimated:00";

                          final _address = Uri.parse(
                              'http://sysken8.japanwest.cloudapp.azure.com/api/todolist/${_assignment['id']}/');
                          final _headers = {
                            'content-type': 'application/json',
                            'Authorization': token
                          };
                          final _body = json.encode({
                            "name": _assignment["name"],
                            "subject": _assignment["subject"],
                            "limited_time": _assignment["limited_time"],
                            "estimated_work_time":
                                _assignment["estimated_work_time"],
                            "notifying_time": null,
                            "is_work_finished": false,
                            "memo": _assignment["memo"],
                            "user": 2,
                          });

                          final _resp = await http.put(_address,
                              headers: _headers, body: _body);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                          ignore: unrelated_type_equality_checks
                            content: Text(_resp.statusCode == 200 ||
                                    _resp.statusCode == 201
                                ? '保存しました'
                                : '保存できませんでした'),
                          ));
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text('終了'),
                        onPressed: () async {
                          final _address = Uri.parse(
                              'http://sysken8.japanwest.cloudapp.azure.com/api/todolist/${_assignment['id']}/');
                          final _headers = {
                            'content-type': 'application/json',
                            'Authorization': token
                          };
                          final _resp =
                              await http.delete(_address, headers: _headers);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TerminationPage()));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
