import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';
import 'timetable.dart';

class TimetableEditPage extends StatefulWidget {
  TimetableEditPage({
    this.subjectName,
    this.subjectID,
    this.classNumber,
    this.currentIndex,
  });

  final subjectName;
  final subjectID;
  final classNumber;
  final currentIndex;

  @override
  State<StatefulWidget> createState() => _TimetableEditPage();
}

class _TimetableEditPage extends State<TimetableEditPage> {
  int _subjectID = 0;
  Set<String> subjectList = {};

  void setup() {
    _subjectID = widget.subjectID[widget.currentIndex];
    subjectList = (widget.subjectName).toSet();
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
        title: Text('時間割の変更'),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 20.0, height: 20.0),
            Text('変更前', style: TextStyle(fontSize: 25.0)),
            Text(widget.subjectName[widget.currentIndex],
                style: TextStyle(fontSize: 30.0)),
            SizedBox(width: 20.0, height: 20.0),
            Text('変更後', style: TextStyle(fontSize: 25.0)),
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
            Container(
              width: double.infinity,
              height: 125.0,
              alignment: Alignment.center,
              child: ElevatedButton(
                  child: Text('保存', style: TextStyle(fontSize: 20.0)),
                  onPressed: () async {
                    final _address = Uri.parse(
                        'http://sysken8.japanwest.cloudapp.azure.com/api/timetable/1/');
                    final _headers = {
                      'content-type': 'application/json',
                      'Authorization': token
                    };

                    final _tableResp =
                        await http.get(_address, headers: _headers);
                    final _currentBody = json.decode(_tableResp.body);

                    Map<String, dynamic> _table = {
                      'mon': json.decode(_currentBody["monday_timetable"]),
                      'tue': json.decode(_currentBody["tuesday_timetable"]),
                      'wed': json.decode(_currentBody["wednesday_timetable"]),
                      'thu': json.decode(_currentBody["thursday_timetable"]),
                      'fri': json.decode(_currentBody["friday_timetable"]),
                    };

                    final _weekList = ['mon', 'tue', 'wed', 'thu', 'fri'];
                    final _ordinal = ['first', 'second', 'third', 'fourth'];
                    final _weekday = widget.currentIndex % 5;
                    _table[_weekList[_weekday]]
                        [_ordinal[widget.classNumber - 1]] = _subjectID;

                    final _body = json.encode({
                      "user": _currentBody["user"],
                      "monday_timetable":
                          "{\"first\": ${_table['mon']["first"]},\"second\": ${_table['mon']["second"]},\"third\": ${_table['mon']["third"]},\"fourth\": ${_table['mon']["fourth"]}}",
                      "tuesday_timetable":
                          "{\"first\": ${_table['tue']["first"]},\"second\": ${_table['tue']["second"]},\"third\": ${_table['tue']["third"]},\"fourth\": ${_table['tue']["fourth"]}}",
                      "wednesday_timetable":
                          "{\"first\": ${_table['wed']["first"]},\"second\": ${_table['wed']["second"]},\"third\": ${_table['wed']["third"]},\"fourth\": ${_table['wed']["fourth"]}}",
                      "thursday_timetable":
                          "{\"first\": ${_table['thu']["first"]},\"second\": ${_table['thu']["second"]},\"third\": ${_table['thu']["third"]},\"fourth\": ${_table['thu']["fourth"]}}",
                      "friday_timetable":
                          "{\"first\": ${_table['fri']["first"]},\"second\": ${_table['fri']["second"]},\"third\": ${_table['fri']["third"]},\"fourth\": ${_table['fri']["fourth"]}}",
                      "saturday_timetable": "{}",
                      "sunday_timetable": "{}",
                    });
                    final _resp = await http.put(_address,
                        headers: _headers, body: _body);

                    final _subjectAddress = Uri.parse(
                        'http://sysken8.japanwest.cloudapp.azure.com/api/subject/');
                    final _subjectHeaders = {'Authorization': token};
                    final _subjectResp = await http.get(_subjectAddress,
                        headers: _subjectHeaders);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      // ignore: unrelated_type_equality_checks
                      content: Text(
                          _resp.statusCode == 200 || _resp.statusCode == 201
                              ? '保存しました'
                              : '保存できませんでした'),
                    ));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimetablePage(
                          timetableList: json.decode(_body),
                          subjectList: json.decode(_subjectResp.body),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
