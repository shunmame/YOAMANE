import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'yoamane_libraries.dart';
import 'friend_list.dart';
import 'schedule_form.dart';
import 'assignment_list.dart';
import 'logout.dart';
import 'assignment_detail.dart';
import 'schedule_list.dart';
import 'timetable_list.dart';

class TimetablePage extends StatefulWidget {
  TimetablePage({required this.timetableList, this.subjectList});

  final Map<String, dynamic> timetableList;
  final subjectList;

  @override
  State<StatefulWidget> createState() => _TimetablePage();
}

class _TimetablePage extends State<TimetablePage> {
  DateTime _currentDate = DateTime.now();
  List<String> subjectName = [];
  List<int> subjectID = [];
  final weekday = [
    'monday_timetable',
    'tuesday_timetable',
    'wednesday_timetable',
    'thursday_timetable',
    'friday_timetable',
  ];
  final ordinal = ['first', 'second', 'third', 'fourth'];

  void setup() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 5; j++) {
        int _index =
            json.decode(widget.timetableList[weekday[j]])[ordinal[i]] - 1;
        subjectName.add(
            utf8.decode((widget.subjectList[_index]['name']).runes.toList()));
        subjectID.add(_index + 1);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  void onDayPressed(DateTime date, List<Event> events) async {
    setState(() => _currentDate = date);

    final _address = Uri.parse(
        'http://sysken8.japanwest.cloudapp.azure.com/api/schedule/?user=2&date=' +
            DateFormat('yyyy-MM-dd').format(_currentDate));
    final _headers = {'Authorization': token};
    final _resp = await http.get(_address, headers: _headers);

    final _scheduleTask = json.decode(_resp.body);
    for (int i = 0; i < _scheduleTask.length; i++) {
      final _title = utf8.decode((_scheduleTask[i]['title']).runes.toList());
      if (_title == '空き') {
        _scheduleTask.removeAt(i);
      }
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ScheduleListPage(
        currentDate: _currentDate,
        scheduleTask: _scheduleTask,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    List<String> _articles = ['予定', '課題', '時間割', 'フレンド', 'ログアウト'];

    return Scaffold(
      appBar: AppBar(
        title: Text('YOAMANE'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String s) async {
              // 予定追加ページ
              if (s == _articles[0]) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScheduleFormPage(
                          currentDate: _currentDate,
                        )));
              }

              // 課題リストページ
              else if (s == _articles[1]) {
                List<String> _subjectName = [...subjectName].toSet().toList();
                List<int> _subjectID = [...subjectID].toSet().toList();
                List<dynamic> _subjectTask = [];

                for (int i = 0; i < _subjectName.length; i++) {
                  final _address = Uri.parse(
                      'http://sysken8.japanwest.cloudapp.azure.com/api/todolist/?subject=${_subjectID[i]}');
                  final _headers = {'Authorization': token};
                  final _resp = await http.get(_address, headers: _headers);

                  _subjectTask.add(json.decode(_resp.body));
                }
                for (int i = 0; i < _subjectName.length; i++) {
                  if (_subjectName[i] == '空き') {
                    _subjectName.removeAt(i);
                    _subjectTask.removeAt(i);
                  }
                }

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AssignmentListPage(
                    subjectName: _subjectName,
                    subjectID: subjectID,
                    subjectTask: _subjectTask,
                    currentDate: _currentDate,
                  ),
                ));
              }

              // 時間割調整ページ
              else if (s == _articles[2]) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TimetableListPage(
                          subjectName: subjectName,
                          subjectID: subjectID,
                        )));
              }

              // フレンドリストページ
              else if (s == _articles[3]) {
                List<String> _friendUserName = [];
                final _friendIDAddress = Uri.parse(
                    'http://sysken8.japanwest.cloudapp.azure.com/api/friend/?user=2');
                final _friendIDHeader = {'Authorization': token};
                final _friendIDResp =
                    await http.get(_friendIDAddress, headers: _friendIDHeader);
                final _friendNum = json.decode(_friendIDResp.body).length;

                for (int i = 1; i < _friendNum; i++) {
                  final _friendID =
                      json.decode(_friendIDResp.body)[i]['friend_user'];

                  final _friendUserAddress = Uri.parse(
                      'http://sysken8.japanwest.cloudapp.azure.com/api/user/$_friendID');
                  final _friendUserHeader = {'Authorization': token};
                  final _friendUserResp = await http.get(_friendUserAddress,
                      headers: _friendUserHeader);
                  _friendUserName.add(utf8.decode(
                      (json.decode(_friendUserResp.body)['username'])
                          .runes
                          .toList()));
                }

                final _tagAddress = Uri.parse(
                    'http://sysken8.japanwest.cloudapp.azure.com/api/groupname/?create_user=2');
                final _tagHeaders = {'Authorization': token};
                final _tagResp =
                    await http.get(_tagAddress, headers: _tagHeaders);

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FriendListPage(
                    friendName: _friendUserName,
                    tagList: json.decode(_tagResp.body),
                  ),
                ));
              }

              // ログアウトページ
              else if (s == _articles[4]) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LogoutPage()));
              }
            },
            itemBuilder: (context) {
              return _articles
                  .map((String s) => PopupMenuItem(child: Text(s), value: s))
                  .toList();
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Column(
          children: [
            CalendarCarousel<Event>(
              childAspectRatio: 1.5,
              width: double.infinity,
              height: deviceHeight / 2.0 - 50.0,
              locale: 'ja_JP',
              headerTextStyle:
                  TextStyle(color: Colors.lightBlueAccent, fontSize: 25.0),
              daysTextStyle: TextStyle(color: Colors.black, fontSize: 20.0),
              weekendTextStyle: TextStyle(color: Colors.red, fontSize: 20.0),
              todayTextStyle: TextStyle(color: Colors.orange, fontSize: 20.0),
              todayButtonColor: Colors.transparent,
              selectedDateTime: _currentDate,
              selectedDayButtonColor: Colors.cyanAccent,
              customGridViewPhysics: NeverScrollableScrollPhysics(),
              onDayPressed: onDayPressed,
            ),
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(right: 25.0),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ScheduleFormPage(
                              currentDate: _currentDate,
                            )),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: Text('時間割', style: TextStyle(fontSize: 30.0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('月', style: TextStyle(fontSize: 20.0)),
                Text('火', style: TextStyle(fontSize: 20.0)),
                Text('水', style: TextStyle(fontSize: 20.0)),
                Text('木', style: TextStyle(fontSize: 20.0)),
                Text('金', style: TextStyle(fontSize: 20.0)),
              ],
            ),
            SizedBox(width: double.infinity, height: 10.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.5,
                ),
                itemCount: subjectName.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${(index / 5).floor() + 1}限',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      subtitle: Text(
                        subjectName[index] == '空き' ? '' : subjectName[index],
                        style: TextStyle(fontSize: 30.0),
                      ),
                      onTap: () async {
//                        final _subtask = [
//                          {'name': '37~42'},
//                          {'name': '自己採点・修正'},
//                          {'name': '40のグラフは書かなくてよい(後日扱う)'},
//                        ];

                        final _headers = {'Authorization': token};
                        final _taskAddress = Uri.parse(
                            'http://sysken8.japanwest.cloudapp.azure.com/api/todolist/?subject=${subjectID[index]}');
                        final _taskResp =
                            await http.get(_taskAddress, headers: _headers);
                        final _subtaskAddress = Uri.parse(
                            'http://sysken8.japanwest.cloudapp.azure.com/api/todolisttask/?to_do_list_id=${subjectID[index]}');
                        final _subtaskResp =
                            await http.get(_subtaskAddress, headers: _headers);

                        if (subjectName[index] != '空き') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AssignmentDetailPage(
                                subjectName: subjectName[index],
                                subjectTask: json.decode(_taskResp.body),
//                                subjectSubtask:
//                                    _subtask, //json.decode(_subtaskResp.body),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
