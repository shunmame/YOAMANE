import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

class ScheduleListPage extends StatefulWidget {
  ScheduleListPage({required this.today, this.scheduleTask});

  final DateTime today;
  final scheduleTask;

  @override
  State<StatefulWidget> createState() => _ScheduleListPage();
}

class _ScheduleListPage extends State<ScheduleListPage> {
  List<TableEvent> events = [];

  void setup() {
    events = new List.generate(
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
        title: Text('${DateFormat('M月d日').format(widget.today)}の予定'),
      ),
      body: TimetableView(
        timetableStyle: TimetableStyle(
          laneWidth: deviceWidth - 80.0,
          laneHeight: 25.0,
        ),
        laneEventsList: [
          LaneEvents(
            lane: Lane(name: ''),
            events: events.length == 0 ? [] : events,
          ),
        ],
      ),
    );
  }
}
