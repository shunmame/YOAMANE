import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';
import 'timetable.dart';

class TimetableTimeFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TimetableTimeFormPage();
}

class _TimetableTimeFormPage extends State<TimetableTimeFormPage> {
  List<String> friendList = [];
  List<Map<String, dynamic>> _startHour = [];
  List<Map<String, dynamic>> _startMinute = [];
  List<Map<String, dynamic>> _classTime = [];
  List<Map<String, dynamic>> _breakTime = [];
  List<Map<String, dynamic>> _lunchStartHour = [];
  List<Map<String, dynamic>> _lunchStartMinute = [];
  List<Map<String, dynamic>> _lunchEndHour = [];
  List<Map<String, dynamic>> _lunchEndMinute = [];

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
            value: (item) => DateFormat('Hæ').format(item)));

    _startMinute = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                12,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: i * 5))),
            key: (item) => 'value',
            value: (item) => DateFormat('må').format(item)));

    _classTime = new List.generate(
        18,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                18,
                (j) => DateTime(now.year, now.month, now.day, 00, 05)
                    .add(Duration(minutes: i * 5))),
            key: (item) => 'value',
            value: (item) => '${i * 5 + 5}å'));

    _breakTime = new List.generate(
        7,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                7,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: i * 5))),
            key: (item) => 'value',
            value: (item) => '${i * 5}å'));

    _lunchStartHour = new List.generate(
        5,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                5,
                (j) => DateTime(now.year, now.month, now.day, 10)
                    .add(Duration(hours: i))),
            key: (item) => 'value',
            value: (item) => DateFormat('Hæ').format(item)));

    _lunchStartMinute = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                12,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: i * 5))),
            key: (item) => 'value',
            value: (item) => DateFormat('må').format(item)));

    _lunchEndHour = new List.generate(
        5,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                5,
                (j) => DateTime(now.year, now.month, now.day, 10)
                    .add(Duration(hours: i))),
            key: (item) => 'value',
            value: (item) => DateFormat('Hæ').format(item)));

    _lunchEndMinute = new List.generate(
        12,
        (i) => Map<String, dynamic>.fromIterable(
            new List.generate(
                12,
                (j) => DateTime(now.year, now.month, now.day, 00, 00)
                    .add(Duration(minutes: i * 5))),
            key: (item) => 'value',
            value: (item) => DateFormat('må').format(item)));
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
        title: Text('ãããã'),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        // child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: token == ''
              ? [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'YOAMANEãžããããïŒ\nã¯ããã«ããªãã®æ¥çšãç»é²ããŸãããïŒ',
                      style: TextStyle(fontSize: 35.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 20.0, height: 50.0),
                  Text('ææ¥­éå§æé', style: TextStyle(fontSize: 20.0)),
                  Row(
                    children: [
                      Container(
                        width: deviceWidth / 2.0 - 20.0,
                        child: SelectFormField(
                          type: SelectFormFieldType.dropdown,
                          initialValue: _startHour[1]['value'],
                          icon: Icon(Icons.calendar_today_sharp),
                          labelText: 'æ',
                          items: _startHour,
                          style: TextStyle(fontSize: 25.0),
                          // onChanged: (val) => print(val),
                          // onSaved: (val) => print(val),
                        ),
                      ),
                      Container(
                        width: deviceWidth / 2.0 - 20.0,
                        child: SelectFormField(
                          type: SelectFormFieldType.dropdown,
                          initialValue: _startMinute[10]['value'],
                          icon: Icon(Icons.calendar_today_sharp),
                          labelText: 'å',
                          items: _startMinute,
                          style: TextStyle(fontSize: 25.0),
                          // onChanged: (val) => print(val),
                          // onSaved: (val) => print(val),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20.0, height: 20.0),
                  Text('ææ¥­æé', style: TextStyle(fontSize: 20.0)),
                  SelectFormField(
                    type: SelectFormFieldType.dropdown,
                    initialValue: _classTime[17]['value'],
                    icon: Icon(Icons.calendar_today_sharp),
                    labelText: 'å',
                    items: _classTime,
                    style: TextStyle(fontSize: 25.0),
                    // onChanged: (val) => print(val),
                    // onSaved: (val) => print(val),
                  ),
                  SizedBox(width: 20.0, height: 20.0),
                  Text('äŒã¿æé', style: TextStyle(fontSize: 20.0)),
                  SelectFormField(
                    type: SelectFormFieldType.dropdown,
                    initialValue: _breakTime[2]['value'],
                    icon: Icon(Icons.calendar_today_sharp),
                    labelText: 'å',
                    items: _breakTime,
                    style: TextStyle(fontSize: 25.0),
                    // onChanged: (val) => print(val),
                    // onSaved: (val) => print(val),
                  ),
                  SizedBox(width: 20.0, height: 20.0),
                  Text('æŒäŒã¿éå§æé', style: TextStyle(fontSize: 20.0)),
                  Row(
                    children: [
                      Container(
                        width: deviceWidth / 2.0 - 20.0,
                        child: SelectFormField(
                          type: SelectFormFieldType.dropdown,
                          initialValue: _lunchStartHour[2]['value'],
                          icon: Icon(Icons.calendar_today_sharp),
                          labelText: 'æ',
                          items: _lunchStartHour,
                          style: TextStyle(fontSize: 25.0),
                          // onChanged: (val) => print(val),
                          // onSaved: (val) => print(val),
                        ),
                      ),
                      Container(
                        width: deviceWidth / 2.0 - 20.0,
                        child: SelectFormField(
                          type: SelectFormFieldType.dropdown,
                          initialValue: _lunchStartMinute[0]['value'],
                          icon: Icon(Icons.calendar_today_sharp),
                          labelText: 'å',
                          items: _lunchStartMinute,
                          style: TextStyle(fontSize: 25.0),
                          // onChanged: (val) => print(val),
                          // onSaved: (val) => print(val),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20.0, height: 20.0),
                  Text('æŒäŒã¿çµäºæé', style: TextStyle(fontSize: 20.0)),
                  Row(
                    children: [
                      Container(
                        width: deviceWidth / 2.0 - 20.0,
                        child: SelectFormField(
                          type: SelectFormFieldType.dropdown,
                          initialValue: _lunchEndHour[3]['value'],
                          icon: Icon(Icons.calendar_today_sharp),
                          labelText: 'æ',
                          items: _lunchEndHour,
                          style: TextStyle(fontSize: 25.0),
                          // onChanged: (val) => print(val),
                          // onSaved: (val) => print(val),
                        ),
                      ),
                      Container(
                        width: deviceWidth / 2.0 - 20.0,
                        child: SelectFormField(
                          type: SelectFormFieldType.dropdown,
                          initialValue: _lunchEndMinute[3]['value'],
                          icon: Icon(Icons.calendar_today_sharp),
                          labelText: 'å',
                          items: _lunchEndMinute,
                          style: TextStyle(fontSize: 25.0),
                          // onChanged: (val) => print(val),
                          // onSaved: (val) => print(val),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 125.0,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text('ã¯ããã', style: TextStyle(fontSize: 20.0)),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('ã­ã°ã€ã³ããŠããŸã...'),
                        ));

                        final _timetableAddress = Uri.parse(
                            'http://sysken8.japanwest.cloudapp.azure.com/api/timetable/');
                        final _timetableHeaders = {'Authorization': token};
                        final _timetableResp = await http.get(_timetableAddress,
                            headers: _timetableHeaders);
                        final _subjectAddress = Uri.parse(
                            'http://sysken8.japanwest.cloudapp.azure.com/api/subject/');
                        final _subjectHeaders = {'Authorization': token};
                        final _subjectResp = await http.get(_subjectAddress,
                            headers: _subjectHeaders);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimetablePage(
                              timetableList:
                                  json.decode(_timetableResp.body)[0],
                              subjectList: json.decode(_subjectResp.body),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]
              : [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'YOAMANEãžããããïŒ\nuser1 ãšããŠã­ã°ã€ã³ããŠããŸã',
                      style: TextStyle(fontSize: 35.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 125.0,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text('ã¯ããã', style: TextStyle(fontSize: 20.0)),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('ã­ã°ã€ã³ããŠããŸã...'),
                        ));

                        final _timetableAddress = Uri.parse(
                            'http://sysken8.japanwest.cloudapp.azure.com/api/timetable/');
                        final _timetableHeaders = {'Authorization': token};
                        final _timetableResp = await http.get(_timetableAddress,
                            headers: _timetableHeaders);
                        final _subjectAddress = Uri.parse(
                            'http://sysken8.japanwest.cloudapp.azure.com/api/subject/');
                        final _subjectHeaders = {'Authorization': token};
                        final _subjectResp = await http.get(_subjectAddress,
                            headers: _subjectHeaders);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimetablePage(
                              timetableList:
                                  json.decode(_timetableResp.body)[0],
                              subjectList: json.decode(_subjectResp.body),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
        ),
        // ),
      ),
    );
  }
}
