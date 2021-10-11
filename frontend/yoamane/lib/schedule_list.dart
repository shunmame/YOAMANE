import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';
import 'schedule_edit.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

class ScheduleListPage extends StatefulWidget {
  ScheduleListPage({required this.currentDate, this.scheduleTask});

  final DateTime currentDate;
  final scheduleTask;

  @override
  State<StatefulWidget> createState() => _ScheduleListPage();
}

class _ScheduleListPage extends State<ScheduleListPage> {
  List<TableEvent> _events = [];

  void setup() {
    _events = new List.generate(
      widget.scheduleTask.length,
      (index) => TableEvent(
        title:
            '${utf8.decode((widget.scheduleTask[index]['title']).runes.toList())}',
        start: TableEventTime(
          hour: DateTime.parse(widget.scheduleTask[index]['start_time'])
              .toLocal()
              .hour,
          minute: DateTime.parse(widget.scheduleTask[index]['start_time'])
              .toLocal()
              .minute,
        ),
        end: TableEventTime(
          hour: DateTime.parse(widget.scheduleTask[index]['end_time'])
              .toLocal()
              .hour,
          minute: DateTime.parse(widget.scheduleTask[index]['end_time'])
              .toLocal()
              .minute,
        ),
        textStyle: TextStyle(fontSize: 15.0, color: Colors.black),
        onTap: () async {
          final _date = DateFormat('yyyy-MM-dd').format(widget.currentDate);
          final _address = Uri.parse(
              'http://sysken8.japanwest.cloudapp.azure.com/api/schedule/?user=2&date=$_date');
          final _headers = {
            'content-type': 'application/json',
            'Authorization': token
          };
          final _resp = await http.get(_address, headers: _headers);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScheduleEditPage(
                    scheduleData: json.decode(_resp.body)[index],
                    currentDate: widget.currentDate,
                  )));
        },
      ),
    );
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
        title: Text('${DateFormat('M月d日').format(widget.currentDate)}の予定'),
      ),
      body: TimetableView(
        timetableStyle: TimetableStyle(
          laneWidth: deviceWidth - 80.0,
          laneHeight: 25.0,
        ),
        laneEventsList: [
          LaneEvents(
            lane: Lane(name: ''),
            events: _events.length != 0 ? _events : [],
          ),
        ],
      ),
    );
  }
}
