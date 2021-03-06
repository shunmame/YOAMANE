import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';
import 'select_working_time.dart';

class AssignmentFormPage extends StatefulWidget {
  AssignmentFormPage({
    this.subjectName,
    this.subjectID,
    this.friendList,
    this.currentDate,
  });

  final subjectName;
  final subjectID;
  final friendList;
  final currentDate;

  @override
  State<StatefulWidget> createState() => _AssignmentFormPage();
}

class _AssignmentFormPage extends State<AssignmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _dueMonth = '';
  String _dueDay = '';
  String _estimated = '';
  String _memo = '';
  int _subjectID = -1;

  List<bool> _values = [];
  Set<String> subjectList = {};
  List<Map<String, dynamic>> _month = [];
  List<Map<String, dynamic>> _day = [];
  List<Map<String, dynamic>> _estimatedTime = [];
  List<Map<String, dynamic>> _notificationTime = [];

  void setup() {
    _values = List.filled(widget.friendList.length, false);
    subjectList = (widget.subjectName).toSet();

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
            value: (item) => DateFormat('dd日').format(item)));

    _estimatedTime = new List.generate(
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
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

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
                Text('課題名', style: TextStyle(fontSize: 20.0)),
                TextFormField(
                  maxLength: 50,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => formStatus(value),
                  onSaved: (String? value) => _name = value!,
                ),
                SizedBox(width: 20.0, height: 20.0),
                Text('提出期限', style: TextStyle(fontSize: 20.0)),
                Row(
                  children: [
                    Container(
                      width: deviceWidth / 2.0 - 20.0,
                      child: SelectFormField(
                        type: SelectFormFieldType.dropdown,
                        initialValue:
                            DateFormat('M月').format(widget.currentDate),
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
                        initialValue:
                            DateFormat('d日').format(widget.currentDate),
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
                Text('教科', style: TextStyle(fontSize: 20.0)),
                LimitedBox(
                  maxHeight: deviceHeight / 5.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: subjectList.length,
                    itemBuilder: (context, index) {
                      return RadioListTile<int>(
                        groupValue: _subjectID,
                        title: Text(subjectList.elementAt(index)),
                        activeColor: Colors.black,
                        value: widget.subjectID.toSet().toList()[index],
                        onChanged: (int? value) => setState(() {
                          _subjectID = value!;
                        }),
                      );
                    },
                  ),
                ),
                SizedBox(width: 20.0, height: 20.0),
                Text('タグ付けする友達', style: TextStyle(fontSize: 20.0)),
                LimitedBox(
                  maxHeight: 100.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.friendList.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(widget.friendList[index],
                            style: TextStyle(fontSize: 20.0)),
                        activeColor: Colors.black,
                        value: _values[index],
                        onChanged: (bool? value) => setState(() {
                          _values[index] = value!;
                        }),
                      );
                    },
                  ),
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
                    child: Text('次へ'),
                    onPressed: () async {
                      _formKey.currentState?.save();
                      final _address = Uri.parse(
                          'http://sysken8.japanwest.cloudapp.azure.com/api/todolist/');
                      final _headers = {
                        'content-type': 'application/json',
                        'Authorization': token
                      };
                      final _body = json.encode({
                        "name": "$_name",
                        "subject": _subjectID,
                        "limited_time":
                            "${DateTime.now().year}-$_dueMonth-${_dueDay}T23:59",
                        "estimated_work_time": "$_estimated:00",
                        "notifying_time": null,
                        "is_work_finished": false,
                        "memo": "$_memo",
                        "user": 2,
                      });
                      final _resp = await http.post(_address,
                          headers: _headers, body: _body);

                      final _ID = json.decode(_resp.body)['id'];
                      final _getAddress = Uri.parse(
                          'http://sysken8.japanwest.cloudapp.azure.com/api/suggest-time/?to_do_list=$_ID');
                      final _getResp =
                          await http.get(_getAddress, headers: _headers);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SelectWorkingTimePage(
                                  candidate:
                                      json.decode(_getResp.body)["candidate"],
                                  assignmentData: json.decode(_body),
                                )),
                      );
                    },
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
