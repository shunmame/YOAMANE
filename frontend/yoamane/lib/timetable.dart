import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'yoamane_libraries.dart';
import 'subject_form.dart';
import 'friend_list.dart';
import 'schedule_form.dart';
import 'assignment_list.dart';
import 'logout.dart';
import 'assignment_detail.dart';
import 'schedule_list.dart';
import 'timetable_list.dart';

class TimetablePage extends StatefulWidget {
  TimetablePage({required this.token, this.subjectList});

  final String token;
  final subjectList;

  @override
  State<StatefulWidget> createState() => _TimetablePage();
}

class _TimetablePage extends State<TimetablePage> {
  DateTime _currentDate = DateTime.now();
  List<String> subjectName = [];
  List<int> subjectID = [];

  // void getToken() async {
  //   var userData = await SharedPreferences.getInstance();
  //   token = userData.getString('token');
  // }

  // http.Response? timetableData;

  // List<dynamic> subjectData = [];

  // void getTimetableApi() async {
  //   final Uri address =
  //       Uri.parse('http://sysken8.japanwest.cloudapp.azure.com/api/timetable/');
  //   Map<String, String> headers = {'Authorization': widget.token};
  //
  //   timetableData = await http.get(address, headers: headers);
  // }

  void setup() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 5; j++) {
        subjectName
            .add(utf8.decode((widget.subjectList[i]['name']).runes.toList()));
        subjectID.add(widget.subjectList[i]['id']);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // getToken();
    setup();
    // getTimetableApi();
  }

  void onDayPressed(DateTime date, List<Event> events) async {
    setState(() => _currentDate = date);

    final _address = Uri.parse(
        'http://sysken8.japanwest.cloudapp.azure.com/api/schedule/?user=2&date=' +
            DateFormat('yyyy-MM-dd').format(_currentDate));
    final _headers = {'Authorization': widget.token};
    final _resp = await http.get(_address, headers: _headers);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ScheduleListPage(
        today: _currentDate,
        scheduleTask: json.decode(_resp.body),
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
                    builder: (context) => ScheduleFormPage()));
              }

              // 課題リストページ
              else if (s == _articles[1]) {
                List<String> _subjectName = [];
                List<dynamic> _subjectTask = [];
                for (int i = 0; i < widget.subjectList.length; i++) {
                  _subjectName.add(utf8
                      .decode((widget.subjectList[i]['name']).runes.toList()));

                  final _address = Uri.parse(
                      'http://sysken8.japanwest.cloudapp.azure.com/api/todolist/${widget.subjectList[i]['id']}/');
                  final _headers = {'Authorization': widget.token};
                  final _resp = await http.get(_address, headers: _headers);

                  _subjectTask.add(json.decode(_resp.body));
                }

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AssignmentListPage(
                    subjectName: _subjectName,
                    subjectTask: _subjectTask,
                  ),
                ));
              }

              // 時間割調整ページ
              else if (s == _articles[2]) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TimetableListPage(
                          subjectName: subjectName,
                        )));
              }

              // フレンドリストページ
              else if (s == _articles[3]) {
                final _friendAddress = Uri.parse(
                    'http://sysken8.japanwest.cloudapp.azure.com/api/friend/?user=2');
                final _friendHeader = {'Authorization': widget.token};
                final _friendResp =
                    await http.get(_friendAddress, headers: _friendHeader);
                // final List<String> _friendList = json.decode(_friendResp.body);

                final _tagAddress = Uri.parse(
                    'http://sysken8.japanwest.cloudapp.azure.com/api/grouptag/?create_user=2');
                final _tagHeaders = {'Authorization': widget.token};
                final _tagResp =
                    await http.get(_tagAddress, headers: _tagHeaders);

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FriendListPage(
                    friendList: friendList,
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
      body: Column(
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
                  MaterialPageRoute(builder: (context) => ScheduleFormPage()),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            child: Text('時間割', style: TextStyle(fontSize: 35.0)),
          ),
          SizedBox(width: double.infinity, height: 10.0),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.5,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    child: Text(
                      subjectName[index],
                      style: TextStyle(fontSize: 25.0),
                    ),
                    onTap: () async {
                      final _taskAddress = Uri.parse(
                          'http://sysken8.japanwest.cloudapp.azure.com/api/todolist/?user=2&subject_id=${subjectID[index]}');
                      final _taskHeaders = {'Authorization': widget.token};
                      final _taskResp =
                          await http.get(_taskAddress, headers: _taskHeaders);
                      final _subtaskAddress = Uri.parse(
                          'http://sysken8.japanwest.cloudapp.azure.com/api/todolisttask/?to_do_list_id=${subjectID[index]}');
                      final _subtaskHeaders = {'Authorization': widget.token};
                      final _subtaskResp = await http.get(_subtaskAddress,
                          headers: _subtaskHeaders);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AssignmentDetailPage(
                            subjectName: subjectName[index],
                            subjectTask: json.decode(_taskResp.body)[0],
                            subjectSubtask: json.decode(_subtaskResp.body),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
